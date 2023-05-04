/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Thu May 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

/**
 * Get minimum version
 * @return {Promise}
 */
export async function executeGetMinimumVersion() {
  const minimumVersionDoc = admin.firestore().collection("app").doc("minimum_version");

  try {
    const query = await minimumVersionDoc.get();
    const data = query.data();

    return data;
  } catch (_) {
    throw new functions.https.HttpsError("internal", "invalid document app/minimum_version");
  }
}
