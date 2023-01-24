/* eslint-disable max-len */
import * as functions from "firebase-functions";
import {setDevice} from "../user/functions/set-device";
import {isIOSPlatform, isValidPlatform} from "../utility";
import {executeSaveVoIPToken} from "./functions/save_voip_token";

export const onSignIn = functions.https.onCall(async (data, context ) => {
  const uid = context.auth?.uid;
  const playerID : string | undefined = data.player_id;
  const deviceID : string | undefined = data.device_id;
  let voipToken : string | null | undefined = data.voip_token;
  let platform : string | undefined = data.platform;

  // Checking argument
  if (!uid) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }

  if (!deviceID) {
    throw new functions.https.HttpsError("invalid-argument", "'device_id' can not be empty");
  } else if (typeof deviceID != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'device_id' must a string");
  }

  if (!playerID) {
    throw new functions.https.HttpsError("invalid-argument", "'player_id' can not be empty");
  } else if (typeof playerID != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'player_id' must a string");
  }

  if (!platform) {
    throw new functions.https.HttpsError("invalid-argument", "'platform' can not be empty");
  } else if (typeof platform != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'platform' must a string");
  } else {
    let tempPlatform = platform;
    tempPlatform = tempPlatform.trim();
    platform = tempPlatform.toLowerCase();

    if (!isValidPlatform(platform)) {
      throw new functions.https.HttpsError("invalid-argument", "The valid 'platform' is android or ios. invalid "+ tempPlatform +" as a `platform`");
    }
  }

  if (isIOSPlatform(platform) ) {
    if (!voipToken) {
      throw new functions.https.HttpsError("invalid-argument", "'voip_token' can not be empty");
    } else if (typeof voipToken != "string") {
      throw new functions.https.HttpsError("invalid-argument", "'voip_token' must a string");
    }
  } else {
    voipToken = null;
  }

  if (uid && playerID && deviceID) {
    await Promise.all([
      setDevice(uid, deviceID, playerID, platform),
      executeSaveVoIPToken(uid, voipToken),
    ]);
  }

  return Promise.resolve();
});
