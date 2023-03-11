/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
import {ONESIGNAL_URL_NOTIFICATIONS, ONESIGNAL_REST_API_KEY, ONESIGNAL_APP_ID} from "../../config";

/**
 * Send test notification to user
 * @param {string} playerID
 * @return {Promise}.
 */
export async function getTestMessageOptions(playerID: string
) : Promise<object> {
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
      app_id: ONESIGNAL_APP_ID,
      include_player_ids: [playerID],
      headings: {
        en: "Test push notification",
      },
      contents: {
        en: "This is test push notification by cloud functions",
      },
    },
  };

  return options;
}
