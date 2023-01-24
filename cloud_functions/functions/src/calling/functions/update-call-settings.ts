/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {isCallStateOngoing} from "../../utility";


/**
 * Update call settings
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeUpdateCallSettings(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  const callID : string | undefined = data?.id;
  const enableFlashlight : boolean | undefined = data?.enable_flashlight;
  const enableFlip : boolean | undefined = data?.enable_flip;


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

  // On no data should be updated
  if (enableFlip === undefined && enableFlashlight === undefined) {
    const response = {
      id: callID,
      message: "Nothing updated",
    };

    console.log(response);
    return response;
  }

  if (enableFlashlight) {
    if (typeof enableFlashlight !== "boolean") {
      throw new functions.https.HttpsError("invalid-argument", "'enable_flashlight' must a true or false. Invalid "+enableFlashlight);
    }
  }

  if (enableFlip) {
    if (typeof enableFlip !== "boolean") {
      throw new functions.https.HttpsError("invalid-argument", "'enable_flip' must a true or false. Invalid "+enableFlip);
    }
  }


  // ----------------> END OF ARGUMENT VALIDATION


  // ----------------> DEFINE DATA LOCATION
  const dbDocCallData = admin.database().ref("calls").child(callID);
  // ----------------> END OF DEFINE DATA LOCATION


  // ----------------> CALL DATA VALIDATION
  const result = await dbDocCallData.get();
  const callData = result.val();
  let state: string;
  let volunteerID: string | undefined;
  let blindID: string | undefined;

  if (!result.exists || !callData) {
    throw new functions.https.HttpsError("not-found", "Call of "+callID+" not found");
  } else {
    state = callData.state;
    volunteerID = callData.users.volunteer_id;
    blindID = callData.users.blind_id;

    if (!isCallStateOngoing(state) || (uid !== blindID && uid !== volunteerID)) {
      throw new functions.https.HttpsError("permission-denied", "You cannot update call settings");
    }
  }
  // ----------------> END OF CALL DATA VALIDATION


  // ----------------> UPDATE SETTINGS CALL DATA
  const newData = {
    ...(enableFlashlight !== undefined && {"enable_flashlight": enableFlashlight}),
    ...(enableFlip !== undefined && {"enable_flip": enableFlip}),
  };
  await dbDocCallData.child("settings").update(newData);

  // ----------------> END OF SETTINGS CALL FLASHLIGHT DATA

  const response = {
    id: callID,
    message: "Successfully to update call settings",
    data_updated: newData,
  };

  console.log(response);
  return response;
}
