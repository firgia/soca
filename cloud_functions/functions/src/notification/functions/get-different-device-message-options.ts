/* eslint-disable max-len */
import {translate} from "../../language";
import {ONESIGNAL_URL_NOTIFICATIONS, ONESIGNAL_REST_API_KEY, ONESIGNAL_APP_ID, ONESIGNAL_ANDROID_CHANNEL_ID_SYSTEM_ACCOUNT} from "../../config";

/**
 * Send different device notification to user
 * @param {string} playerID
 * @param {string} uid
 * @return {Promise}.
 */
export async function getDifferentDeviceMessageOptions(
    playerID: string,
    uid: string,
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
      data: {
        "uid": uid,
        "code": "different-device",
        "message": "User has been sign in with a different device.",
      },
      android_channel_id: ONESIGNAL_ANDROID_CHANNEL_ID_SYSTEM_ACCOUNT,
      ios_sound: "notification_info.aiff",
      content_available: true,
      filters: [
        {
          "field": "tag",
          "key": "player_id",
          "relation": "=",
          "value": playerID,
        },
        {
          "field": "tag",
          "key": "uid",
          "relation": "=",
          "value": uid,
        },
        {
          "field": "tag",
          "key": "is_signed_in",
          "relation": "=",
          "value": true,
        },
      ],
      headings: {
        ar: translate("ar", "different_device_title"),
        en: translate("en", "different_device_title"),
        es: translate("es", "different_device_title"),
        hi: translate("hi", "different_device_title"),
        id: translate("id", "different_device_title"),
        ru: translate("ru", "different_device_title"),
        zh: translate("zh", "different_device_title"),
      },
      contents: {
        ar: translate("ar", "different_device_desc"),
        en: translate("en", "different_device_desc"),
        es: translate("es", "different_device_desc"),
        hi: translate("hi", "different_device_desc"),
        id: translate("id", "different_device_desc"),
        ru: translate("ru", "different_device_desc"),
        zh: translate("zh", "different_device_desc"),
      },
      // high priority = 10
      priority: 10,
    },
  };

  return options;
}
