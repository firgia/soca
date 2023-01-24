/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {convertTimestampToString, isCallStateEnded, isCallStateEndedWithCanceled, isCallStateEndedWithUnanswered, isCallStateOngoing, isCallStateWaiting} from "../../utility";
import {CallRole, CallState} from "../../type";

/**
 * Decline call
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeDeclineCall(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  const callID : string | undefined = data?.id;
  const blindID : string | undefined = data?.blind_id;

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
  let targetVolunteerIDs: string[] | undefined;

  if (!result.exists || !callData) {
    throw new functions.https.HttpsError("not-found", "Call of "+callID+" not found");
  } else {
    const state = callData.state;
    targetVolunteerIDs = callData.target_volunteer_ids;

    if (!targetVolunteerIDs || !targetVolunteerIDs.includes(uid)) {
      throw new functions.https.HttpsError("permission-denied", "You cannot decline this call");
    } else if (!isCallStateWaiting(state)) {
      if (isCallStateOngoing(state)) {
        throw new functions.https.HttpsError("permission-denied", "You cannot decline this call because another volunteer already answer this call");
      } else if (isCallStateEnded(state) || isCallStateEndedWithCanceled(state)||isCallStateEndedWithUnanswered(state) ) {
        throw new functions.https.HttpsError("permission-denied", "You cannot decline this call because the call is ended");
      } else {
        throw new functions.https.HttpsError("permission-denied", "You cannot decline this call");
      }
    }
  }
  // ----------------> END OF CALL DATA VALIDATION


  // ----------------> UPDATE CALL DATA
  const indexRemove = targetVolunteerIDs.indexOf(uid);
  if (indexRemove !== -1) {
    targetVolunteerIDs.splice(indexRemove, 1);
  }

  callData.state = CallState.ENDED_WITH_DECLINED;
  callData.target_volunteer_ids = targetVolunteerIDs;

  const isLastTargetVolunteer = targetVolunteerIDs.length == 0;
  const volunteerCallData = callData;
  volunteerCallData.role = CallRole.ANSWERER;

  await Promise.all([
    fsDocBlindCallData.update({
      ...(isLastTargetVolunteer && {"state": CallState.ENDED_WITH_UNANSWERED}),
      "target_volunteer_ids": targetVolunteerIDs,
    }),
    fsDocVolunteerCallData.set(volunteerCallData),
  ]);

  await dbDocCallData.update({
    ...(isLastTargetVolunteer && {"state": CallState.ENDED_WITH_UNANSWERED}),
    "target_volunteer_ids": targetVolunteerIDs,
  });
  // ----------------> END OF UPDATE CALL DATA


  volunteerCallData.created_at = convertTimestampToString(volunteerCallData.created_at);
  const response = {
    id: callID,
    ...volunteerCallData,
  };

  console.log(response);
  return response;
}
