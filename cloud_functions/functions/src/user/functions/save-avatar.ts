/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Storage} from "@google-cloud/storage";
const gcs = new Storage();
import {tmpdir} from "os";
import {join, dirname} from "path";
import sharp from "sharp";
import * as fs from "fs-extra";

/**
 * Get url storage.
 * @param {string} bucket
 * @param {string} id
 * @param {string} fileName
 * @param {string} token
 * @return {string} url for show or download file.
*/
function getUrlStorage(bucket: string, id: string, fileName: string, token: string) : string {
  return "https://firebasestorage.googleapis.com/v0/b/" + bucket + "/o/users%2F"+id+"%2Favatar%2F" + fileName + "?alt=media&token=" + token;
}


/**
 * Resize avatar image and Save link avatar image to firestore
 * @param {functions.storage.ObjectMetadata} object
 * @return {Promise} .
 */
export async function saveAvatar(object:functions.storage.ObjectMetadata): Promise<unknown> {
  const objectName = object.name;
  const token = object.metadata?.firebaseStorageDownloadTokens;
  const contentType = object.contentType;

  if (objectName == undefined || token == undefined || contentType == undefined) {
    return Promise.resolve();
  }

  // sample correct name : users/{id}/avatar/{filename}.jpg
  const explode = objectName.split("/");

  // check is avatar image or not
  if (explode[0] != "users" || explode[2] != "avatar") {
    return Promise.resolve();
  } else if (!contentType.startsWith("image/")) {
    console.log("Invalid avatar image");

    return admin.storage().bucket(object.bucket).file(objectName).delete();
  } else {
    // Get User Id from file name
    const id = explode[1];

    try {
      const document = admin.firestore().collection("users").doc(id);

      // get url image
      const fileName = explode[3];
      const isAvatar = fileName.includes("avatar@");

      // creating avatarnail image & save url
      if (!isAvatar) {
        const bucket = gcs.bucket(object.bucket);
        const filePath = objectName;
        const fileName = filePath.split("/").pop();
        const bucketDir = dirname(filePath);

        if (fileName == undefined) {
          return Promise.reject(Error("Undifined file name"));
        }

        const workingDir = join(tmpdir(), "avatar");
        const tmpFilePath = join(workingDir, fileName);

        await fs.ensureDir(workingDir);
        await bucket.file(filePath).download({
          destination: tmpFilePath,
        });

        // get all URL
        const urlOriginal = getUrlStorage(object.bucket, id, fileName, token);
        let urlSmall = "";
        let urlMedium = "";
        let urlLarge = "";

        const pathOriginal = object.name;
        let pathSmall = "";
        let pathMedium = "";
        let pathLarge = "";

        const sizes = [128, 256, 512];
        const uploadPromises = sizes.map(async (size) => {
          let avatarName = "";

          const jpegFileName = fileName.split(".")[0] +".jpeg";
          if (size == 128) {
            avatarName = "avatar@small-"+ jpegFileName;
            urlSmall = getUrlStorage(object.bucket, id, avatarName, token);
            pathSmall = objectName.replace(fileName, avatarName);
          } else if (size == 256) {
            avatarName = "avatar@medium-"+jpegFileName;
            urlMedium = getUrlStorage(object.bucket, id, avatarName, token);
            pathMedium = objectName.replace(fileName, avatarName);
          } else {
            avatarName = "avatar@large-"+jpegFileName;
            urlLarge = getUrlStorage(object.bucket, id, avatarName, token);
            pathLarge = objectName.replace(fileName, avatarName);
          }

          const avatarPath = join(workingDir, avatarName);

          await sharp(tmpFilePath).resize(size, size).toFormat("jpeg").jpeg(
              {
                quality: 100,
                chromaSubsampling: "4:4:4",
              },
          ).toFile(avatarPath);

          return bucket.upload(avatarPath, {
            destination: join(bucketDir, avatarName),
            metadata: {
              metadata: {
                firebaseStorageDownloadTokens: token,
              },
            },
          });
        });
        await Promise.all(uploadPromises);
        await fs.remove(workingDir);

        return document.update({
          "avatar": {
            "url": {
              "original": urlOriginal,
              "small": urlSmall,
              "medium": urlMedium,
              "large": urlLarge,
            },
            "path": {
              "original": pathOriginal,
              "small": pathSmall,
              "medium": pathMedium,
              "large": pathLarge,
            },
          },
        }).then(() => {
          console.log("Success to add avatar image");
        }).catch(() => {
          console.log("Failed to add avatar image" + id);
        });
      } else {
        return Promise.resolve();
      }
    } catch (err) {
      console.log("Invalid User ID : "+ id);

      return admin.storage().bucket(object.bucket).file(objectName).delete();
    }
  }
}

