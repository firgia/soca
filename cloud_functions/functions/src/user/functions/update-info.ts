/* eslint-disable valid-jsdoc */
/* eslint-disable max-len */
import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";

/**
 * Update the user info
 *
 * @param {string} uid
 * @param {number} totalCalls
 * @param {number} totalVisitors
 * @param {number} totalFriends
 * @param {string[]} listOfCallYears
 * return Promise
 */
export async function updateInfo(uid :string, totalCalls?: FieldValue, totalVisitors?: FieldValue, totalFriends?:FieldValue, listOfCallYears?: FieldValue) {
  const docFS = admin.firestore().collection("users").doc(uid);

  if (!totalCalls && !totalVisitors && !totalFriends && !listOfCallYears) {
    return Promise.resolve();
  }

  return docFS.update({
    ...((totalCalls) && {"info.total_calls": totalCalls}),
    ...((totalVisitors) && {"info.total_visitors": totalVisitors}),
    ...((totalFriends) && {"info.total_friends": totalFriends}),
    ...(listOfCallYears && {"info.list_of_call_years": listOfCallYears}),
  });
}
