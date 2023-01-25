/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
/* eslint-disable @typescript-eslint/no-explicit-any */
import {Timestamp} from "firebase-admin/firestore";

import {CallState, DevicePlatform, Gender, UserType} from "./type";
import * as admin from "firebase-admin";

/**
 * Check is volunteer user or not
 * @param {any} userType
 * @return {boolean} true if is volunteer user
 */
export function isVolunteerUser(userType: any) {
  if (typeof userType === "string") {
    return (userType === UserType.VOLUNTEER);
  } else {
    return false;
  }
}

/**
 * Check is blind user or not
 * @param {any} userType
 * @return {boolean} true if is blind user
 */
export function isBlindUser(userType: any) {
  if (typeof userType === "string") {
    return (userType === UserType.BLIND);
  } else {
    return false;
  }
}

/**
 * Check is valid user type
 * @param {any} userType
 * @return {boolean} true if is valid user type
 */
export function isValidUserType(userType: any) {
  return isBlindUser(userType) || isVolunteerUser(userType);
}

/**
 * Check is male gender
 * @param {any} gender
 * @return {boolean} true if is male gender
 */
export function isMaleGender(gender: any) {
  if (typeof gender === "string") {
    return (gender === Gender.MALE);
  } else {
    return false;
  }
}

/**
 * Check is female gender
 * @param {any} gender
 * @return {boolean} true if is female gender
 */
export function isFemaleGender(gender: any) {
  if (typeof gender === "string") {
    return (gender === Gender.FEMALE);
  } else {
    return false;
  }
}

/**
 * Check is valid gender
 * @param {any} gender
 * @return {boolean} true if is valid gender
 */
export function isValidGender(gender: any) {
  return isMaleGender(gender) || isFemaleGender(gender);
}


/**
 * Check is Android platform
 * @param {any} platform
 * @return {boolean} true if is Android platform
 */
export function isAndroidPlatform(platform: any) {
  if (typeof platform === "string") {
    return (platform === DevicePlatform.ANDROID);
  } else {
    return false;
  }
}

/**
 * Check is iOS platform
 * @param {any} platform
 * @return {boolean} true if is iOS platform
 */
export function isIOSPlatform(platform: any) {
  if (typeof platform === "string") {
    return (platform === DevicePlatform.IOS);
  } else {
    return false;
  }
}

/**
 * Check is valid platform
 * @param {any} platform
 * @return {boolean} true if is valid platform
 */
export function isValidPlatform(platform: any) {
  return isAndroidPlatform(platform) || isIOSPlatform(platform);
}


/**
 * Check is waiting call state
 * @param {any} state
 * @return {boolean} true if is waiting call state
 */
export function isCallStateWaiting(state: any) {
  if (typeof state === "string") {
    return (state === CallState.WAITING);
  } else {
    return false;
  }
}

/**
 * Check is ongoing call state
 * @param {any} state
 * @return {boolean} true if is ongoing call state
 */
export function isCallStateOngoing(state: any) {
  if (typeof state === "string") {
    return (state === CallState.ONGOING);
  } else {
    return false;
  }
}

/**
 * Check is ended with canceled call state
 * @param {any} state
 * @return {boolean} true if is ended with canceled call state
 */
export function isCallStateEndedWithCanceled(state: any) {
  if (typeof state === "string") {
    return (state === CallState.ENDED_WITH_CANCELED);
  } else {
    return false;
  }
}

/**
 * Check is ended with unanswered call state
 * @param {any} state
 * @return {boolean} true if is ended with unanswered call state
 */
export function isCallStateEndedWithUnanswered(state: any) {
  if (typeof state === "string") {
    return (state === CallState.ENDED_WITH_UNANSWERED);
  } else {
    return false;
  }
}

/**
 * Check is ended with declined call state
 * @param {any} state
 * @return {boolean} true if is ended with declined call state
 */
export function isCallStateEndedWithDeclined(state: any) {
  if (typeof state === "string") {
    return (state === CallState.ENDED_WITH_DECLINED);
  } else {
    return false;
  }
}

/**
 * Check is ended call state
 * @param {any} state
 * @return {boolean} true if is ended call state
 */
export function isCallStateEnded(state: any) {
  if (typeof state === "string") {
    return (state === CallState.ENDED);
  } else {
    return false;
  }
}

/**
 * Check is valid call state
 * @param {any} state
 * @return {boolean} true if is valid call state
 */
export function isValidCallState(state: any) {
  return isCallStateWaiting(state) ||
  isCallStateOngoing(state) ||
  isCallStateEndedWithCanceled(state) ||
  isCallStateEndedWithUnanswered(state) ||
  isCallStateEndedWithDeclined(state) ||
  isCallStateEnded(state)
  ;
}

/**
 * Convert timestamp to string for showing to json
 * @param {admin.firestore.Timestamp| string|null |undefined} timestamp
 * @return {string | null}
 */
export function convertTimestampToString(timestamp: admin.firestore.Timestamp| string|null |undefined) {
  if (timestamp && timestamp instanceof admin.firestore.Timestamp ) {
    return timestamp.toDate().toISOString();
  } else if (timestamp) {
    return timestamp;
  } else {
    return null;
  }
}

/**
 * Get string from any data and convert to null if undefined or not string
 * @param {any} data
 * @return {string | null}
 */
export function getStringFromAny(data: any):string|null {
  try {
    if (data) {
      if (data instanceof Timestamp) {
        return data.toDate().toISOString();
      } else {
        return data as string;
      }
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}


/**
 * Get number from any data and convert to null if undefined or not number
 * @param {any} data
 * @return {number | null}
 */
export function getNumberFromAny(data: any):number|null {
  try {
    if (data) {
      return data as number;
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}

/**
 * Get object from any data and convert to null if undefined or invalid object
 * @param {any} data
 * @return {object | null}
 */
export function getObjectFromAny(data: any):object|null {
  try {
    if (data) {
      return data as object;
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}


/**
 * Get array from any data and convert to null if undefined or invalid array
 * @param {any} data
 * @return {[] | null}
 */
export function getArrayFromAny(data: any):[]|null {
  try {
    if (data) {
      return data as [];
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}

