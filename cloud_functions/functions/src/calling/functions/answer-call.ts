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
import {convertTimestampToString, isCallStateEnded, isCallStateEndedWithCanceled, isCallStateEndedWithUnanswered, isCallStateOngoing, isCallStateWaiting} from "../../utility";
import {CallRole, CallState} from "../../type";
import {executeMissedCall} from "./missed-call";
import {setCallAvailability} from "./set-call-availability";


/**
 * Answer call
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeAnswerCall(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  const callID : string | undefined = data?.id;
  const blindID : string | undefined = data?.blind_id;
  let targetVolunteerIDs :string[]| undefined;

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

  if (!blindID) {
    throw new functions.https.HttpsError("invalid-argument", "'blind_id' can not be empty");
  } else if (typeof blindID != "string") {
    throw new functions.https.HttpsError("invalid-argument", "'blind_id' must a string");
  }
  // ----------------> END OF ARGUMENT VALIDATION


  // ----------------> DEFINE DATA LOCATION
  const fsDocBlindCallData = admin.firestore().collection(`users/${blindID}/calls`).doc(callID);
  const fsDocVolunteerCallData = admin.firestore().collection(`users/${uid}/calls`).doc(callID);
  const dbDocCallData = admin.database().ref("calls").child(callID);
  // ----------------> END OF DEFINE DATA LOCATION


  // ----------------> CALL DATA VALIDATION
  const result = await fsDocBlindCallData.get();
  const callData = result.data();

  if (!result.exists || !callData) {
    throw new functions.https.HttpsError("not-found", "Call of "+callID+" not found");
  } else {
    const state = callData.state;
    targetVolunteerIDs = callData.target_volunteer_ids;

    if (!targetVolunteerIDs || !targetVolunteerIDs.includes(uid)) {
      throw new functions.https.HttpsError("permission-denied", "You cannot answer this call");
    } else if (!isCallStateWaiting(state)) {
      if (isCallStateOngoing(state)) {
        throw new functions.https.HttpsError("permission-denied", "You cannot answer this call because another volunteer already answer this call");
      } else if (isCallStateEnded(state) || isCallStateEndedWithCanceled(state)||isCallStateEndedWithUnanswered(state) ) {
        throw new functions.https.HttpsError("permission-denied", "You cannot answer this call because the call is ended");
      } else {
        throw new functions.https.HttpsError("permission-denied", "You cannot answer this call");
      }
    }
  }
  // ----------------> END OF CALL DATA VALIDATION


  // ----------------> UPDATE CALL DATA
  callData.state = CallState.ONGOING;
  callData.users.volunteer_id = uid;
  callData.role = CallRole.ANSWERER;
  const newCallData = callData;

  await Promise.all([
    fsDocBlindCallData.update({
      "state": CallState.ONGOING,
      "users.volunteer_id": uid,
    }),
    fsDocVolunteerCallData.set(newCallData),
  ]);

  await Promise.all([
    dbDocCallData.update({
      "state": CallState.ONGOING,
    }),
    dbDocCallData.child("users").update({
      "volunteer_id": uid,
    }),
  ]);
  // ----------------> END OF UPDATE CALL DATA


  // ----------------> PUSH MISSED CALL TO VOLUNTEER
  // Push missed call to unanswered volunteer
  const index = targetVolunteerIDs.indexOf(uid, 0);

  if (index > -1) {
    targetVolunteerIDs.splice(index, 1);
  }
  await executeMissedCall(targetVolunteerIDs, blindID, callID);
  // ----------------> END OF PUSH MISSED CALL TO VOLUNTEER


  // ----------------> SET VOLUNTEER AVAILABILITY TO CALL
  await setCallAvailability([uid], false);
  // ----------------> END OF SET VOLUNTEER AVAILABILITY TO CALL

  newCallData.created_at = convertTimestampToString(newCallData.created_at);
  const response = {
    id: callID,
    ...newCallData,
  };

  console.log(response);
  return response;
}
