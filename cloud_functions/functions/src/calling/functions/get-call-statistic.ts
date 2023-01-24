/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {getStringFromAny} from "../../utility";


/**
 * Get user Call Statistic
 * @param {any} data
 * @param {functions.https.CallableContext} context
 * @return {Promise}
 */
export async function executeGetCallStatistic(data: any, context: functions.https.CallableContext) {
  // ----------------> ARGUMENT VALIDATION
  const uid = context.auth?.uid;
  let year: number | string | undefined = data?.year;
  let locale: string | undefined = data?.locale;

  if (!uid) {
    throw new functions.https.HttpsError("unauthenticated", "Please Sign in to use this functions");
  }

  if (!year) {
    throw new functions.https.HttpsError("invalid-argument", "'year' can not be empty");
  } else if (typeof year == "string") {
    try {
      year = parseInt(year);
    } catch (_) {
      year = undefined;
    }
  } else {
    year = undefined;
  }

  if (!year || year < 2000 || year > 3000) {
    throw new functions.https.HttpsError("invalid-argument", "'year' must a number within 2000 - 3000");
  }

  if (!locale) {
    locale = "en";
  }

  // ----------------> END OF ARGUMENT VALIDATION


  // ----------------> GET CALL
  const nextYear = year + 1;
  const startDate = `${year}-01-01T00:00:00.000z`;
  const endDate = `${nextYear}-01-01T00:00:00.000z`;

  const start = new Date(startDate);
  const end = new Date(endDate);

  const userCollection = admin.firestore().collection("users");
  const query = await userCollection.doc(uid).collection("calls")
      .where("created_at", ">=", admin.firestore.Timestamp.fromDate(start))
      .where("created_at", "<", admin.firestore.Timestamp.fromDate(end))
      .get();

  if (query.empty) {
    throw new functions.https.HttpsError("not-found", "Call history is not found");
  }
  // ----------------> END OF GET CALL


  const initialStatisticMonth = [];
  const callDocs = query.docs;

  for (let month = 0; month < 12; month++) {
    const date = new Date(new Date("1970-01-01").setMonth(month));
    const localeMonth = date .toLocaleString(locale, {month: "short"});

    initialStatisticMonth.push({month: localeMonth, total: 0});
  }

  const response = {
    total: 0,
    monthly_statistics: initialStatisticMonth,
  };

  for (const doc of callDocs) {
    const callData = doc.data();

    if (callData) {
      const createdAt = getStringFromAny(callData.created_at);

      if (createdAt) {
        const month = new Date(createdAt).getMonth();
        response.total++;
        response.monthly_statistics[month].total++;
      }
    }
  }

  console.log(response);
  return response;
}

