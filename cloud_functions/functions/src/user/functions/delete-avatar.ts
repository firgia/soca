/* eslint-disable max-len */
import * as admin from "firebase-admin";
import {Change} from "firebase-functions/lib/common/change";
import {QueryDocumentSnapshot} from "firebase-functions/v1/firestore";

/**
 * Avatar image in storage will deleted if user change the avatar
 * @param {functions.Change<functions.firestore.QueryDocumentSnapshot>} change
 * @return {Promise}.
 */
export async function deleteAvatar(change: Change<QueryDocumentSnapshot>):Promise<unknown> {
  // sample data in firestore
  // {
  //  "url": {original : a, small: b, medium: c, large: d},
  //  "path": {original : a, small: b, medium: c, large: d},
  // }

  // Get an object representing the document
  const update = change.after.data();
  const old = change.before.data();

  // Get Image
  const oldImg = old["avatar"];
  const updImg = update["avatar"];

  if (oldImg == undefined || updImg == undefined) {
    return Promise.resolve();
  }

  const deleteImages = [];

  if ((oldImg["url"]["original"] !== updImg["url"]["original"]) || (oldImg["url"]["small"] !== updImg["url"]["small"]) || (oldImg["url"]["medium"] !== updImg["url"]["medium"]) || (oldImg["url"]["large"] !== updImg["url"]["large"])) {
    const original = oldImg["path"]["original"];
    const small = oldImg["path"]["small"];
    const medium = oldImg["path"]["medium"];
    const large = oldImg["path"]["large"];

    if (original !== undefined && original !== null) deleteImages.push(original);
    if (small !== undefined && small !== null) deleteImages.push(small);
    if (medium !== undefined && medium !== null) deleteImages.push(medium);
    if (large !== undefined && large !== null) deleteImages.push(large);
  }

  // user not update the avatar image
  if (deleteImages.length == 0) {
    return Promise.resolve();
  }

  // delete image from storage
  const storage = admin.storage();
  const defaultBucket = storage.bucket();

  const imagesRemovePromises = deleteImages.map((imagePath) => {
    const file = defaultBucket.file(imagePath);

    return file.delete();
  });

  return Promise.all(imagesRemovePromises).catch(() => {
    console.log("Image not found");
  });
}
