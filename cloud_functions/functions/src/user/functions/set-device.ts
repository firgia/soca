/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable valid-jsdoc */
/* eslint-disable max-len */
import * as admin from "firebase-admin";
import * as notification from "../../notification";
import {isValidPlatform} from "../../utility";

/**
 * Update new device user in firebase and database.
 * If device id is different old device will receive new message,
 * and client will automatically sign out.
 *
 * @param {string} uid
 * @param {string} id
 * @param {string} playerID
 * @param {string} platform
 * return Promise
 */
export async function setDevice(uid :string, id: string, playerID: string, platform: string): Promise<void> {
  const docFS = admin.firestore().collection("users").doc(uid);
  const docDB = admin.database().ref("users").child(uid);

  const user = await docFS.get();
  const userData = user.data();

  if (user.exists && userData !== undefined) {
    const oldDeviceData = userData["device"];

    let tempPlatform = platform;
    tempPlatform = tempPlatform.trim();
    platform = tempPlatform.toLowerCase();

    if (!isValidPlatform(platform)) {
      throw new Error("The valid 'platform' is android or ios. invalid "+ tempPlatform +" as a `platform`");
    }

    const oldDevice = {
      "device.id": oldDeviceData["id"],
      "device.player_id": oldDeviceData["player_id"],
      "device.platform": oldDeviceData["platform"],
    };

    const newDevice = {
      "device.id": id,
      "device.player_id": playerID,
      "device.platform": platform,
    };


    const isDifferent = (JSON.stringify(newDevice) !== JSON.stringify(oldDevice));

    if (oldDeviceData === undefined || isDifferent) {
      // Update new device
      try {
        await docFS.update(newDevice);
        console.log("Success to update user device on Firestore");
      } catch (e) {
        console.log("Failed to update user device on Firestore");
      }

      try {
        const userInDB = await docDB.get();
        const newDeviceDBData = {
          "id": id,
          "player_id": playerID,
          "platform": platform,
        };

        if (userInDB.exists()) {
          await docDB.child("device").update(newDeviceDBData);
        } else {
          await docDB.child("device").set(newDeviceDBData);
        }

        console.log("Success to update user device on Realtime Database");
      } catch (e) {
        console.log(e);
        console.log("Failed to update user device on Realtime Database");
      }

      // Send message to temporary device
      const oldPlayerID : string| undefined = oldDeviceData["player_id"];
      if (oldDeviceData !== undefined && oldPlayerID !== undefined) {
        try {
          await notification.sendDifferentDevice(oldPlayerID, uid).then(( )=> {
            console.log("'Different device' message has been sent by onesignal");
          }).catch(() => {
            console.log("Error to send 'Different device' message from onesignal");
          });
        } catch (e) {
          console.log("Failed to send 'different device' message");
          console.log(e);
        }
      }
    }
  }
  return Promise.resolve();
}
