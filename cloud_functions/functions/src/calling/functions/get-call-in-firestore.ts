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
import {convertTimestampToString} from "../../utility";


/**
 * Get call
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeGetCallInFirestore(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  const callID : string | undefined = data?.id;

  if (!uid) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }

  if (!data) {
    throw new functions.https.HttpsError("invalid-argument", "Argument is required");
  }

  if (!callID) {
    throw new functions.https.HttpsError("invalid-argument", "'id' can not be empty");
  } else if (typeof callID != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'id' must a string");
  }

  // ----------------> END OF ARGUMENT VALIDATION

  const result = await admin.firestore().collection(`users/${uid}/calls`).doc(callID).get();
  const callData = result.data();

  if (!result.exists || !callData) {
    throw new functions.https.HttpsError("not-found", "Call of "+callID+" not found");
  }


  const createdAt = convertTimestampToString(callData.created_at);
  const rtcChannelID = callData.rtc_channel_id;
  const settings = callData.settings;
  const targetVolunteerIDs = callData.target_volunteer_ids;
  const state = callData.state;
  const users = callData.users;


  const response = {
    id: result.id,
    created_at: createdAt,
    target_volunteer_ids: targetVolunteerIDs,
    rtc_channel_id: rtcChannelID,
    settings: settings,
    users: users,
    state: state,
  };

  console.log(response);
  return response;
}
