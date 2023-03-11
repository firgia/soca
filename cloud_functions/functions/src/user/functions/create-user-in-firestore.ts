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
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {isIOSPlatform, isValidGender, isValidPlatform, isValidUserType} from "../../utility";
import {addDeviceVoIPToken} from "../../notification";


/**
 * Create new user
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function createUserInFirestore(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  if (!uid) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }

  if (!data) {
    throw new functions.https.HttpsError("invalid-argument", "Argument is required");
  }

  const name : string | undefined = data.name;
  let type : string | undefined = data.type;
  let gender : string | undefined = data.gender;
  let dateOfBirth: string| admin.firestore.Timestamp | undefined = data.date_of_birth;
  const language : string[] | undefined = data.language;

  const deviceLanguage : string | undefined = data.device.language;
  const playerID : string | undefined = data.device.player_id;
  const deviceID : string | undefined = data.device.id;
  let voipToken : string | null | undefined = data.device.voip_token;
  let platform : string | undefined = data.device.platform;

  if (!name) {
    throw new functions.https.HttpsError("invalid-argument", "'name' can not be empty");
  } else if (typeof name != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'name' must a string");
  } else if (name.trim().length < 4 || name.trim().length > 25) {
    throw new functions.https.HttpsError("invalid-argument", "'name' must be 4 - 25 characters");
  }

  if (!type) {
    throw new functions.https.HttpsError("invalid-argument", "'type' can not be empty");
  } else if (typeof type != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'type' must a string");
  } else {
    let tempType = type;
    tempType = tempType.trim();
    type = tempType.toLowerCase();

    if (!isValidUserType(type)) {
      throw new functions.https.HttpsError("invalid-argument", "The valid 'type' is blind or volunteer. invalid "+ tempType +" as a `type`");
    }
  }

  if (!gender) {
    throw new functions.https.HttpsError("invalid-argument", "'gender' can not be empty");
  } else if (typeof gender != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'gender' must a string");
  } else {
    let tempGender = gender;
    tempGender = tempGender.trim();
    gender = tempGender.toLowerCase();

    if (!isValidGender(gender)) {
      throw new functions.https.HttpsError("invalid-argument", "The valid 'gender' is male or female. invalid "+ tempGender +" as a `gender`");
    }
  }


  if (!dateOfBirth) {
    throw new functions.https.HttpsError("invalid-argument", "'name' can not be empty");
  } else if (typeof dateOfBirth != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'date_of_birth' must a string");
  } else {
    const date = new Date(dateOfBirth);
    dateOfBirth = admin.firestore.Timestamp.fromDate(date);
  }

  if (!language) {
    throw new functions.https.HttpsError("invalid-argument", "'language' can not be empty");
  } else if (!Array.isArray(language)) {
    throw new functions.https.HttpsError("invalid-argument", "'language' must a array of string");
  } else {
    language as string[];
  }


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

  if (isIOSPlatform(platform) ) {
    if (!voipToken) {
      throw new functions.https.HttpsError("invalid-argument", "'device.voip_token' can not be empty");
    } else if (typeof voipToken != "string") {
      throw new functions.https.HttpsError("invalid-argument", "'device.voip_token' must a string");
    }
  } else {
    voipToken = null;
  }

  // ----------------> END OF ARGUMENT VALIDATION

  let voipPlayerID: string | undefined;

  //  Save voip token to OneSignal
  if (voipToken?.trim()) {
    try {
      const result = await addDeviceVoIPToken(voipToken);
      voipPlayerID = result.data["id"];
    } catch (e) {
      console.log("Failed to add device voip token");
      console.log(e);
    }
  }

  const form = {
    name: name,
    type: type,
    gender: gender,
    date_of_birth: dateOfBirth,
    language: language,
    device: {
      id: deviceID,
      player_id: playerID,
      language: deviceLanguage,
      platform: platform,
      ...((voipPlayerID && voipToken?.trim()) && {
        voip: {
          token: voipToken,
          player_id: voipPlayerID,
        },
      }),
      ...((!voipPlayerID && !voipToken?.trim()) && {
        voip: null,
      }),
    },
    activity: {
      online: true,
      last_seen: admin.firestore.Timestamp.fromDate(new Date()),
    },
    status: {
      disabled: false,
      call_availability: true,
    },
    info: {
      date_joined: admin.firestore.Timestamp.fromDate(new Date()),
      total_friends: 0,
      total_calls: 0,
      total_visitors: 0,
      list_of_call_years: [],
    },
    self_introduction: null,
  };

  console.log("Creating new user in firestore");
  console.log(form);
  return admin.firestore().collection("users").doc(uid).set(form);
}
