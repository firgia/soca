/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {v4 as uuidv4} from "uuid";
import {CallRole, CallState, UserType} from "../../type";
import {isBlindUser} from "../../utility";
import {User} from "../../model";
import {pushIncomingCall} from "./push-incoming-call";

/**
 * Create new call
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeCreateCall(data: any, context: functions.https.CallableContext) {
  // #1 ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  if (!uid) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }
  // END OF ARGUMENT VALIDATION

  // #2 CHECK USER DATA
  const result = await admin.firestore().collection("users").doc(uid).get();
  const user = User.fromDocumentData(result);

  if (!user) {
    throw new functions.https.HttpsError("not-found", "User "+uid+" not found");
  }

  if (!isBlindUser(user.type)) {
    throw new functions.https.HttpsError("permission-denied", "You cannot create a call. Creating a call for the 'non-blind' user is not allowed.");
  }

  const language: string[] = result.data()?.language ?? [];

  // END OF CHECK USER DATA

  // #3 GET TARGET VOLUNTEERS
  const volunteerIDs :string[] = [];

  // Criteria of volunteer selected
  // 1. Same language (at least one language)
  // 2. Not ansewring other call
  // 3. Not disabled user
  const volunteerResult = await admin.firestore().collection("users")
      .where("type", "==", UserType.VOLUNTEER)
      .where("status.call_availability", "==", true)
      .where("status.disabled", "==", false)
      .where("language", "array-contains-any", language)
      .get();
  const volunteerDocs = volunteerResult.docs;

  for (const doc of volunteerDocs) {
    if (doc.exists) {
      const id = doc.id;
      volunteerIDs.push(id);
    }
  }

  if (volunteerIDs.length == 0 ) {
    throw new functions.https.HttpsError("unavailable", "Volunteers is not available.");
  }

  // END OF GET TARGET VOLUNTEERS

  // #4 CREATING CALL
  const id = uuidv4();
  const rtcChannelID = uuidv4();

  const docFS = admin.firestore().collection("users").doc(uid).collection("calls").doc(id);
  const docDB = admin.database().ref("calls").child(id);

  const currentDate = new Date();
  const timestampCreateAt = admin.firestore.Timestamp.fromDate(currentDate);

  const initCall = {
    target_volunteer_ids: volunteerIDs,
    rtc_channel_id: rtcChannelID,
    settings: {
      enable_flashlight: false,
      enable_flip: false,
    },
    users: {
      blind_id: uid,
      volunteer_id: null,
    },
    role: CallRole.CALLER,
    state: CallState.WAITING,
  };

  const payload = {
    ...initCall,
    created_at: timestampCreateAt,
  };

  await Promise.all([
    docFS.set(payload),
    docDB.set(payload),
  ]);

  await pushIncomingCall(volunteerDocs, user, id);
  // END OF CREATING  CALL

  const response = {
    id: id,
    ...initCall,
    created_at: timestampCreateAt.toDate().toISOString(),
  };

  console.log(response);
  return response;
}

