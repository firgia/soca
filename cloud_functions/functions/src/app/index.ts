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
import {executeGetMinimumVersion} from "./functions/get-minimum-version";

/**
 * Get minimum version to use the mobile app
 *
 * Error code maybe thrown :
 *
 * * [internal] if minimum_version data is not found on firestore
 */
// eslint-disable-next-line @typescript-eslint/no-unused-vars
export const getMinimumVersion = functions.https.onCall(async (data, context ) => {
  return executeGetMinimumVersion();
});

