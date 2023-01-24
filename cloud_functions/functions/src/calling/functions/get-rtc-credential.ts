/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */
import {RtcTokenBuilder, RtcRole} from "agora-access-token";
import * as functions from "firebase-functions";
import * as config from "../../config";

const AGORA_APP_ID = config.AGORA_APP_ID;
const AGORA_APP_CERTIFICATE = config.AGORA_APP_CERTIFICATE;


/**
 * Get rtc credential
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export function executeGenerateRTCCredential(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  if (!uid) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }

  if (!data) {
    throw new functions.https.HttpsError("invalid-argument", "Argument is required");
  }

  const channelName : string | undefined = data.channel_name;
  const rtcUID : string | undefined = data.uid;
  const role : string | undefined = data.role;
  let roleSelected: number | undefined;

  if (!channelName) {
    throw new functions.https.HttpsError("invalid-argument", "'channel_name' can not be empty");
  } else if (typeof channelName != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'channel_name' must a string");
  }

  if (!role) {
    throw new functions.https.HttpsError("invalid-argument", "'role' can not be empty");
  } else if (typeof role != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'role' must a string");
  } else if (role === "publisher") {
    roleSelected = RtcRole.PUBLISHER;
  } else if (role === "audience") {
    roleSelected = RtcRole.SUBSCRIBER;
  } else {
    throw new functions.https.HttpsError("invalid-argument", "The valid 'role' is publisher or audience. invalid "+ role +" as a `role`");
  }

  if (!rtcUID) {
    throw new functions.https.HttpsError("invalid-argument", "'uid' can not be empty");
  } else if (typeof rtcUID != "number") {
    throw new functions.https.HttpsError("invalid-argument", "'uid' must a number");
  }
  // ----------------> END OF ARGUMENT VALIDATION

  if (AGORA_APP_ID && AGORA_APP_CERTIFICATE) {
    // set the expired token time to 600 second or 10 minutes
    const expireTime = 600;

    // calculate privilege expire time
    const currentTime = Math.floor(Date.now() / 1000);
    const privilegeExpiredTime = currentTime + expireTime;

    // build the token
    const token = RtcTokenBuilder.buildTokenWithUid(AGORA_APP_ID, AGORA_APP_CERTIFICATE, channelName, rtcUID, roleSelected, privilegeExpiredTime);

    const result = {
      token: token,
      privilege_expired_time_seconds: privilegeExpiredTime,
      channel_name: channelName,
      uid: rtcUID,
    };

    console.log(result);
    return result;
  } else {
    const errorMessage = "AGORA_APP_ID and AGORA_APP_CERTIFICATE is required";
    console.log(errorMessage);

    throw new Error(errorMessage);
  }
}

