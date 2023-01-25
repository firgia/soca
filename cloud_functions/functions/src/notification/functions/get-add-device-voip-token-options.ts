/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
import {ENVIRONMENT, ONESIGNAL_URL_PLAYERS, ONESIGNAL_VOIP_APP_ID} from "../../config";

/**
 * Add the device with a VOIP token
 * @param {string} token voip token
 */
export async function getAddDeviceVoipTokenOptions(
    token: string,
) {
  // 0 = iOS
  // 1 = android
  const deviceType = 0;

  const options = {
    method: "POST",
    url: ONESIGNAL_URL_PLAYERS,
    headers: {
      "Accept": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "content-type": "application/json",
    },
    data: {
      "app_id": ONESIGNAL_VOIP_APP_ID,
      "identifier": token,
      "device_type": deviceType,
      ...(ENVIRONMENT === "dev" && {"test_type": 1}),
    },
  };

  return options;
}
