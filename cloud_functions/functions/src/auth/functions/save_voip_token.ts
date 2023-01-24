/* eslint-disable max-len */
import * as admin from "firebase-admin";
import {addDeviceVoIPToken} from "../../notification";

/**
 * Save voip token
 *
 * @param {string} uid
 * @param {string | null} token
 */
export async function executeSaveVoIPToken(uid :string, token: string | null) {
  const docFS = admin.firestore().collection("users").doc(uid);

  const user = await docFS.get();
  const userData = user.data();

  if (user.exists && userData !== undefined) {
    if (token && token.trim()) {
      let playerID:string| undefined;
      try {
        const result = await addDeviceVoIPToken(token);
        playerID = result.data["id"];
      } catch (e) {
        console.log("Failed to add device voip token");
        console.log(e);
      }

      if (playerID) {
        return docFS.update({
          "device.voip.token": token,
          "device.voip.player_id": playerID,
        });
      } else {
        return Promise.reject(new Error("voip player id is empty"));
      }
    } else {
      return docFS.update({
        "device.voip": null,
      });
    }
  }

  return Promise.resolve();
}
