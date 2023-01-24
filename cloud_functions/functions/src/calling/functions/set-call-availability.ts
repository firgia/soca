/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */

import * as admin from "firebase-admin";

/**
 * SET VOLUNTEER AVAILABILITY TO CALL
 * @param {string[]} volunteerIDs
 * @param {boolean} available
 * @return {Promise}
 */
export async function setCallAvailability(volunteerIDs : string[], available: boolean) {
  // ----------------> ARGUMENT VALIDATION
  if (volunteerIDs.length == 0) return;
  // ----------------> END OF ARGUMENT VALIDATION


  // ----------------> DEFINE DATA LOCATION
  const fsDoc = admin.firestore().collection("users");
  // ----------------> END OF DEFINE DATA LOCATION


  // ----------------> DEFINE DATA LOCATION
  const batch = admin.firestore().batch();

  for (let i = 0; i < volunteerIDs.length; i++) {
    const id = volunteerIDs[i];
    console.log(id);
    batch.update(fsDoc.doc(id), {
      "status.call_availability": available,
    });
  }

  // ----------------> UPDATE AVAILABILITY
  await batch.commit().then(
      () => {
        const response = {
          volunteer_ids: volunteerIDs,
          availability: available,
          message: "Successfully to update the volunteer availability to call",
        };
        console.log(response);
      },
      (e) => {
        console.log("Rejected because : "+e);
        const response = {
          volunteer_ids: volunteerIDs,
          message: "Failed to update the volunteer availability to call",
        };
        console.log(response);
      },
  );
  // ----------------> END OF UPDATE AVAILABILITY
}

