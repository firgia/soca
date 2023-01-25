/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */
import * as admin from "firebase-admin";
import {isAndroidPlatform, isIOSPlatform} from "../../utility";
import * as notification from "../../notification/index";
import {User} from "../../model";

/**
 * Push missed call
 * @param {admin.firestore.DocumentData[]} volunteers
 * @param {User} userCaller
 * @param {string} callID call id
 * @return {Promise}
 */
export async function pushMissedCall(volunteers: admin.firestore.DocumentData[], userCaller: User, callID: string) {
  // use this player ID for push notification on android user
  const volunteerPlayerIDs: string[] = [];

  // use this voip player id for push voip notification on iOS user
  const volunteerVoIPPlayerIDs: string[] = [];

  for (const doc of volunteers) {
    if (doc.exists) {
      const data = doc.data();

      const platform: string | undefined = data.device.platform;

      if (isIOSPlatform(platform)) {
        const voipPlayerID: string | undefined = data.device.voip.player_id;
        if (voipPlayerID) {
          volunteerVoIPPlayerIDs.push(voipPlayerID);
        }
      }

      if (isAndroidPlatform(platform) ) {
        const playerID: string | undefined = data.device.player_id;
        if (playerID) {
          volunteerPlayerIDs.push(playerID);
        }
      }
    }
  }

  if (volunteerVoIPPlayerIDs.length > 0) {
    // Send incoming call for iOS user
    try {
      await notification.sendMissedCallToIOS(volunteerVoIPPlayerIDs, userCaller, callID);
    } catch (e) {
      console.log("Failed to send missed call to iOS Device");
      console.log(e);
    }
  }

  if (volunteerPlayerIDs.length > 0) {
    // Send incoming call for android user
    try {
      await notification.sendMissedCallToAndroid(volunteerPlayerIDs, userCaller, callID);
    } catch (e) {
      console.log("Failed to send missed call to Android Device");
      console.log(e);
    }
  }
}
