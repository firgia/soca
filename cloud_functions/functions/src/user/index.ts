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
import {createUserInFirestore} from "./functions/create-user-in-firestore";
import {createUserInRealtimeDatabase} from "./functions/create-user-in-realtime-database";
import {deleteAvatar} from "./functions/delete-avatar";
import {executeGetProfileInFirestore} from "./functions/get-profile-in-firestore";

/**
 * Create new user based on auth uid and save into Firestore & Realtime Database
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [invalid-argument] if some argument is not valid to execute this functions
 */
export const create = functions.https.onCall(async (data, context ) => {
  return Promise.all([createUserInFirestore(data, context), createUserInRealtimeDatabase(data, context)]);
});

/**
 * Get profile based on uid from `authentication` or uid from `argument`.
 * if uid from argument is empty then this functions will be sent profile based on uid from auth
 *
 * Error code maybe thrown :
 *
 * * [unauthenticated] if user not signed-in
 * * [not-found] if user is not available on firestore
 */
export const getProfile = functions.https.onCall(async (data, context ) => {
  return executeGetProfileInFirestore(data, context);
});


export const onUpdate = functions.firestore.document("users/{documentId}").onUpdate(async (change) => {
  await deleteAvatar(change);
  return Promise.resolve();
});
