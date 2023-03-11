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
import {getArrayFromAny, getNumberFromAny, getObjectFromAny, getStringFromAny} from "../../utility";


/**
 * Get user profile
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeGetProfileInFirestore(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const authUID = context.auth?.uid;
  const queryUID : string | undefined = data?.uid ?? undefined;

  if (!authUID) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }

  let uid = authUID;
  if (queryUID && typeof queryUID == "string") {
    uid = queryUID;
  }
  // ----------------> END OF ARGUMENT VALIDATION

  return await getUserProfileInFirestore(uid);
}


/**
 * Get user profile
 * @param {string} uid
 * @return {Promise}
 */
export async function getUserProfileInFirestore(uid: string) {
  const userDoc = admin.firestore().collection("users").doc(uid);
  const query = await userDoc.get();
  const userData = query.data();

  if (!query.exists || !userData) {
    throw new functions.https.HttpsError("not-found", "User "+uid+" not found");
  }

  const avatar = getObjectFromAny(userData.avatar);
  const lastSeen = getStringFromAny(userData.activity?.last_seen);
  const online = getStringFromAny(userData.activity?.online);
  const dateOfBirth = getStringFromAny(userData.date_of_birth);
  const device = getObjectFromAny(userData.device);
  const gender = getStringFromAny(userData.gender);
  const language = getArrayFromAny(userData.language);
  const name = getStringFromAny(userData.name);
  const dateJoined = getStringFromAny(userData.info?.date_joined);
  const totalCalls = getNumberFromAny(userData.info?.total_calls);
  const totalFriends = getNumberFromAny(userData.info?.total_friends);
  const totalVisitors = getNumberFromAny(userData.info?.total_visitors);
  const listOfCallYears = getArrayFromAny(userData.info?.list_of_call_years);
  const type = getStringFromAny(userData.type);
  const selfIntroduction = getStringFromAny(userData.self_introduction);

  const result = {
    id: query.id,
    avatar: avatar,
    activity: {
      last_seen: lastSeen,
      online: online,
    },
    date_of_birth: dateOfBirth,
    device: device,
    gender: gender,
    language: language,
    name: name,
    info: {
      date_joined: dateJoined,
      total_calls: totalCalls,
      total_friends: totalFriends,
      total_visitors: totalVisitors,
      list_of_call_years: listOfCallYears,
    },
    type: type,
    self_introduction: selfIntroduction,
  };

  console.log(result);
  return result;
}
