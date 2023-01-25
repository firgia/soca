/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
import {ONESIGNAL_APP_ID, ONESIGNAL_REST_API_KEY, ONESIGNAL_URL_NOTIFICATIONS, ONESIGNAL_VOIP_APP_ID, ONESIGNAL_VOIP_REST_API_KEY} from "../../config";
import {User} from "../../model";

/**
 * Send voip call to ios device
 * @param {string[]} playerIDs player id
 * @param {User} userCaller user caller data
 * @param {string} uuid uniq uuid call
 * @param {string} type type of send voip call
 */
export async function getSendVoIPCallToIOSOptions(
    playerIDs: string[],
    userCaller: User,
    uuid: string,
    type: string,
) {
  const options = {
    method: "POST",
    url: ONESIGNAL_URL_NOTIFICATIONS,
    headers: {
      "Accept": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Authorization": "Basic " + ONESIGNAL_VOIP_REST_API_KEY,
      "content-type": "application/json",
    },
    data: {
      "app_id": ONESIGNAL_VOIP_APP_ID,
      "apns_push_type_override": "voip",
      "include_player_ids": playerIDs,
      "data": {
        "type": type,
        "uuid": uuid,
        "user_caller": userCaller.toObject(),
      },
      "content_available": true,
    },
  };

  return options;
}

/**
 * Send incoming call to android device
 * @param {string[]} playerIDs player id
 * @param {User} userCaller user caller data
 * @param {string} uuid uniq uuid call
 * @param {string} type type of send voip call
 */
export async function getSendCallToAndroidOptions(
    playerIDs: string[],
    userCaller: User,
    uuid: string,
    type: string,
) {
  const options = {
    method: "POST",
    url: ONESIGNAL_URL_NOTIFICATIONS,
    headers: {
      "Accept": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Authorization": "Basic " + ONESIGNAL_REST_API_KEY,
      "content-type": "application/json",
    },
    data: {
      "app_id": ONESIGNAL_APP_ID,
      "include_player_ids": playerIDs,
      "data": {
        "type": type,
        "uuid": uuid,
        "user_caller": userCaller.toObject(),
      },
      "isAndroid": true,
      "isIos": false,
      "content_available": true,
      // high priority = 10
      "priority": 10,
    },
  };

  return options;
}
