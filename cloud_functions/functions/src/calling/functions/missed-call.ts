/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */

import * as admin from "firebase-admin";
import {FieldPath} from "firebase-admin/firestore";

import {pushMissedCall} from "./push-missed-call";
import {User} from "../../model";

/**
 * Missed Call
 * @param {string[]} volunteerIDs
 * @param {string} blindID
 * @param {string} callID
 * @return {Promise}
 */
export async function executeMissedCall(volunteerIDs : string[], blindID: string, callID: string) {
  // ----------------> ARGUMENT VALIDATION
  if (volunteerIDs.length == 0) return;
  // ----------------> END OF ARGUMENT VALIDATION

  // ----------------> DEFINE DATA LOCATION
  const fsDoc = admin.firestore().collection("users");
  const fsBlindDoc = admin.firestore().collection("users").doc(blindID);
  // ----------------> END OF DEFINE DATA LOCATION


  // ----------------> GET DATA
  const volunteersResult = await fsDoc.where(FieldPath.documentId(), "in", volunteerIDs).get();
  const blindResult = await fsBlindDoc.get();
  // ----------------> END OF GET DATA

  // ----------------> PUSH DISMISS INCOMING CALL
  const userCaller = User.fromDocumentData(blindResult);

  if (userCaller) {
    await pushMissedCall(volunteersResult.docs, userCaller, callID);
  }
  // ----------------> END OF PUSH DISMISS INCOMING CALL

  const response = {
    id: callID,
    user_caller: userCaller?.toObject(),
    volunteer_ids: volunteerIDs,
    message: (userCaller)? "Successfully to push missed call" : "Failed to push missed call because user caller is empty",
  };

  console.log(response);
}

