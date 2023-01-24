/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {isValidPlatform} from "../../utility";


/**
 * Create new user
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function createUserInRealtimeDatabase(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  if (!uid) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }

  if (!data) {
    throw new functions.https.HttpsError("invalid-argument", "Argument is required");
  }

  const deviceLanguage : string | undefined = data.device.language;
  const playerID : string | undefined = data.device.player_id;
  const deviceID : string | undefined = data.device.id;
  let platform : string | undefined = data.device.platform;

  if (!deviceID) {
    throw new functions.https.HttpsError("invalid-argument", "'device.id' can not be empty");
  } else if (typeof deviceID != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'device.id' must a string");
  }

  if (!playerID) {
    throw new functions.https.HttpsError("invalid-argument", "'device.player_id' can not be empty");
  } else if (typeof playerID != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'device.player_id' must a string");
  }

  if (!deviceLanguage) {
    throw new functions.https.HttpsError("invalid-argument", "'device.language' can not be empty");
  } else if (typeof deviceLanguage != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'device.language' must a string");
  }

  if (!platform) {
    throw new functions.https.HttpsError("invalid-argument", "'device.platform' can not be empty");
  } else if (typeof platform != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'device.platform' must a string");
  } else {
    let tempPlatform = platform;
    tempPlatform = tempPlatform.trim();
    platform = tempPlatform.toLowerCase();

    if (!isValidPlatform(platform)) {
      throw new functions.https.HttpsError("invalid-argument", "The valid 'device.platform' is android or ios. invalid "+ tempPlatform +" as a `device.platform`");
    }
  }

  // ----------------> END OF ARGUMENT VALIDATION

  const form = {
    device: {
      id: deviceID,
      player_id: playerID,
      language: deviceLanguage,
      platform: platform,
    },
    activity: {
      online: true,
      last_seen: admin.firestore.Timestamp.fromDate(new Date()),
    },
  };

  console.log("Creating new user in realtime database");
  console.log(form);

  return admin.database().ref("users/"+uid).set(form);
}
