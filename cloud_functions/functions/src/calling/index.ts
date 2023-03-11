/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
import * as functions from "firebase-functions";
import {executeCreateCall} from "./functions/create-call";
import {executeGenerateRTCCredential} from "./functions/get-rtc-credential";
import {executeGetCallInFirestore} from "./functions/get-call-in-firestore";
import {executeAnswerCall} from "./functions/answer-call";
import {executeDeclineCall} from "./functions/decline-call";
import {executeEndCall} from "./functions/end-call";
import {executeUpdateCallSettings} from "./functions/update-call-settings";
import {executeGetCallHistoryInFirestore} from "./functions/get-call-history";
import {updateInfo} from "../user/functions/update-info";
import {getArrayFromAny, getStringFromAny} from "../utility";
import {getUserProfileInFirestore} from "../user/functions/get-profile-in-firestore";
import {FieldValue} from "firebase-admin/firestore";
import {executeGetCallStatistic} from "./functions/get-call-statistic";


/**
 * Answer call
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 * * [not-found] if call data is not available on firestore
 * * [permission-denied] if user cannot answer a call
 */
export const answerCall = functions.https.onCall(async (data, context ) => {
  return executeAnswerCall(data, context);
});

/**
 * Create call
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 * * [not-found] if call data is not available on firestore
 * * [permission-denied] if user cannot allowed to create call
 * * [unavailable] if the answered user is not available
 */
export const createCall = functions.https.onCall(async (data, context ) => {
  return executeCreateCall(data, context);
});


/**
 * Decline call
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 * * [not-found] if call data is not available on firestore
 * * [permission-denied] if user cannot decline a call
 */
export const declineCall = functions.https.onCall(async (data, context ) => {
  return executeDeclineCall(data, context);
});

/**
 * End call
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 * * [not-found] if call data is not available on firestore
 * * [permission-denied] if user cannot allowed to end call
 */
export const endCall = functions.https.onCall(async (data, context ) => {
  return executeEndCall(data, context);
});

/**
 * Get call based on id.
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 * * [not-found] if user is not available on firestore
 */
export const getCall = functions.https.onCall(async (data, context ) => {
  return executeGetCallInFirestore(data, context);
});

/**
 * Generate and Get RTC token for video calling
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 */
export const getRTCCredential = functions.https.onCall(async (data, context ) => {
  return executeGenerateRTCCredential(data, context);
});

/**
 * Update call setting
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 * * [not-found] if call data is not available on firestore
 * * [permission-denied] if user cannot allowed to update call settings
 */
export const updateCallSettings = functions.https.onCall(async (data, context ) => {
  return executeUpdateCallSettings(data, context);
});

/**
 * Get call history based on uid from `authentication`.
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [not-found] if call is not available on firestore
 */
export const getCallHistory = functions.https.onCall(async (data, context ) => {
  return executeGetCallHistoryInFirestore(data, context);
});

/**
 * Get call statistic based on uid from `authentication`.
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 * * [not-found] if call is not available on firestore
 */
export const getCallStatistic = functions.https.onCall(async (data, context ) => {
  return executeGetCallStatistic(data, context);
});

export const onCreate = functions.firestore.document("users/{userID}/calls/{callID}").onCreate(async (snapshot, context) => {
  const userID = context.params.userID;
  const createdAt = getStringFromAny(snapshot.data().created_at);
  const user = await getUserProfileInFirestore(userID);
  const listOfCallYears: string[] | null = getArrayFromAny(user.info.list_of_call_years);

  if (createdAt && listOfCallYears) {
    const date = new Date(createdAt);
    const year = date.getFullYear().toString();

    if (listOfCallYears.length > 0 && listOfCallYears.includes(year, 0)) {
      await updateInfo(userID, FieldValue.increment(1));
    } else {
      await updateInfo(userID, FieldValue.increment(1), undefined, undefined, FieldValue.arrayUnion(year));
    }
  }

  return Promise.resolve();
});
