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
import {getStringFromAny} from "../../utility";
import {getUserProfileInFirestore} from "../../user/functions/get-profile-in-firestore";


/**
 * Get user Call History
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeGetCallHistoryInFirestore(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;

  if (!uid) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }
  // ----------------> END OF ARGUMENT VALIDATION

  const userCollection = admin.firestore().collection("users");
  const query = await userCollection.doc(uid).collection("calls")
      .orderBy("created_at", "desc")
      .get();

  if (query.empty) {
    throw new functions.https.HttpsError("not-found", "Call history is not found");
  }

  const callDocs = query.docs;
  const response = [];
  for (const doc of callDocs) {
    const callData = doc.data();

    if (callData) {
      const id = doc.id;
      const createdAt = getStringFromAny(callData.created_at);
      const endedAt = getStringFromAny(callData.ended_at);
      const state = getStringFromAny(callData.state);
      const role = getStringFromAny(callData.role);

      let remoteUserData;

      const blindID = getStringFromAny(callData.users.blind_id);
      const volunteerID = getStringFromAny(callData.users.volunteer_id);

      if (blindID && blindID != uid) {
        remoteUserData = await getUserProfileInFirestore(blindID);
      }

      if (volunteerID && volunteerID != uid) {
        remoteUserData = await getUserProfileInFirestore(volunteerID);
      }

      response.push({
        id: id,
        created_at: createdAt,
        ended_at: endedAt,
        state: state,
        role: role,
        remote_user: remoteUserData ??null,
      });
    }
  }

  console.log(response);
  return response;
}

