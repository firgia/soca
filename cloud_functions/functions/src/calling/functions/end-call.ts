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
import {convertTimestampToString, isCallStateEnded, isCallStateEndedWithCanceled, isCallStateEndedWithDeclined, isCallStateEndedWithUnanswered, isCallStateOngoing, isCallStateWaiting} from "../../utility";
import {CallState} from "../../type";
import {executeMissedCall} from "./missed-call";
import {setCallAvailability} from "./set-call-availability";


/**
 * End the call
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeEndCall(data: any, context: functions.https.CallableContext) {
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


  // ----------------> DEFINE DATA LOCATION
  const fsDocCallData = admin.firestore().collection(`users/${uid}/calls`).doc(callID);
  const dbDocCallData = admin.database().ref("calls").child(callID);
  // ----------------> END OF DEFINE DATA LOCATION


  // ----------------> CALL DATA VALIDATION
  const result = await fsDocCallData.get();
  const callData = result.data();
  let state: string;
  let volunteerID: string | undefined;
  let blindID: string | undefined;
  let targetVolunteerIDs :string[]| undefined;

  if (!result.exists || !callData) {
    throw new functions.https.HttpsError("not-found", "Call of "+callID+" not found");
  } else {
    state = callData.state;
    volunteerID = callData.users.volunteer_id;
    blindID = callData.users.blind_id;
    targetVolunteerIDs = callData.target_volunteer_ids;


    if (isCallStateEnded(state) || isCallStateEndedWithCanceled(state) || isCallStateEndedWithUnanswered(state) || isCallStateEndedWithDeclined(state)) {
      throw new functions.https.HttpsError("permission-denied", "You cannot end this call because the call is ended");
    }

    if (!blindID) {
      throw new functions.https.HttpsError("permission-denied", "You cannot end this call");
    }

    if (isCallStateOngoing(state)) {
      if (!volunteerID || (blindID !== uid && volunteerID !== uid)) {
        throw new functions.https.HttpsError("permission-denied", "You cannot end this call");
      }
    } else if (blindID !== uid) {
      throw new functions.https.HttpsError("permission-denied", "You cannot end this call");
    }
  }
  // ----------------> END OF CALL DATA VALIDATION


  // ----------------> UPDATE CALL DATA

  // Update blind user call data
  const fsDocBlindCallData = admin.firestore().collection(`users/${blindID}/calls`).doc(callID);
  const currentDate = new Date();
  const endedAt = admin.firestore.Timestamp.fromDate(currentDate);

  const updatedBlindCallState = (isCallStateWaiting(state))? CallState.ENDED_WITH_CANCELED: CallState.ENDED;
  const updatedVolunteerCallState = CallState.ENDED;

  const processBlindDataUpdate = fsDocBlindCallData.update({
    "state": updatedBlindCallState,
    "ended_at": endedAt,
  });

  if (volunteerID) {
    // Update volunteer user call data
    const fsDocVolunteerCallData = admin.firestore().collection(`users/${volunteerID}/calls`).doc(callID);
    const processVolunteerDataUpdate = fsDocVolunteerCallData.update({
      "state": updatedVolunteerCallState,
      "ended_at": endedAt,
    });

    await Promise.all([
      processBlindDataUpdate,
      processVolunteerDataUpdate,
    ]);
  } else {
    await processBlindDataUpdate;
  }

  await dbDocCallData.update({
    "state": updatedBlindCallState,
    "ended_at": endedAt,
  });
  // ----------------> END OF UPDATE CALL DATA


  // ----------------> PUSH MISSED CALL TO VOLUNTEER
  // Push missed call if call state is waiting,
  // also push missed call has been send when volunteer answer the call
  if (isCallStateWaiting(state) && targetVolunteerIDs) {
    await executeMissedCall(targetVolunteerIDs, blindID, callID);
  }
  // ----------------> END OF PUSH MISSED CALL TO VOLUNTEER


  // ----------------> SET VOLUNTEER AVAILABILITY TO CALL
  if (volunteerID) await setCallAvailability([volunteerID], true);
  // ----------------> END OF SET VOLUNTEER AVAILABILITY TO CALL


  const isVolunteerUser = (volunteerID && volunteerID === uid);
  const newCallData = callData;

  newCallData.state = isVolunteerUser? updatedVolunteerCallState : updatedBlindCallState,
  newCallData.ended_at = convertTimestampToString(endedAt);
  newCallData.created_at = convertTimestampToString(newCallData.created_at);

  const response = {
    id: callID,
    ...newCallData,
  };

  console.log(response);
  return response;
}
