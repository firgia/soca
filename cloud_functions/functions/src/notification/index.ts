/* eslint-disable max-len */
import axios from "axios";
import {getDifferentDeviceMessageOptions} from "./functions/get-different-device-message-options";
import {getTestMessageOptions} from "./functions/get-test-message-options";
import * as functions from "firebase-functions";
import {getAddDeviceVoipTokenOptions} from "./functions/get-add-device-voip-token-options";
import {User} from "../model";
import {getSendCallToAndroidOptions, getSendVoIPCallToIOSOptions} from "./functions/get-send-call-options";
import {VoIPCallType} from "../type";

/**
 * Send different device notification to user
 * @param {string} playerID
 * @param {string} uid
 * @return {Promise}.
 */
export async function sendDifferentDevice(
    playerID: string,
    uid: string,
) {
  const options = await getDifferentDeviceMessageOptions( playerID, uid);
  const response = await axios.request(options);
  console.log(response.data);

  return response;
}

/**
 * Add device VoIP token to OneSignal
 * @param {string} token
 * @return {Promise} `id` will returning if VoIP token successfully added, use `id` to push VoIP notification
 */
export async function addDeviceVoIPToken(token: string) {
  const options = await getAddDeviceVoipTokenOptions(token);
  const response = await axios.request(options);
  console.log(response.data);

  return response;
}

/**
 * Send voip incoming call to ios device
 * @param {string[]} playerIDs player id
 * @param {User} userCaller user caller data
 * @param {string} uuid uniq uuid call
 */
export async function sendIncomingCallToIOS(playerIDs: string[], userCaller: User, uuid: string) {
  const options = await getSendVoIPCallToIOSOptions(playerIDs, userCaller, uuid, VoIPCallType.INCOMING_VIDEO_CALL);
  const response = await axios.request(options);
  console.log(response.data);

  return response;
}

/**
 * Send voip missed call to ios device
 * @param {string[]} playerIDs player id
 * @param {User} userCaller user caller data
 * @param {string} uuid uniq uuid call
 */
export async function sendMissedCallToIOS(playerIDs: string[], userCaller: User, uuid: string) {
  const options = await getSendVoIPCallToIOSOptions(playerIDs, userCaller, uuid, VoIPCallType.MISSED_VIDEO_CALL);
  const response = await axios.request(options);
  console.log(response.data);

  return response;
}

/**
 * Send incoming call to android device
 * @param {string[]} playerIDs list of player id
 * @param {User} userCaller user caller data
 * @param {string} uuid uniq uuid for call
 */
export async function sendIncomingCallToAndroid(playerIDs: string[], userCaller: User, uuid: string) {
  const options = await getSendCallToAndroidOptions(playerIDs, userCaller, uuid, VoIPCallType.INCOMING_VIDEO_CALL);
  const response = await axios.request(options);
  console.log(response.data);

  return response;
}

/**
 * Send missed call to android device
 * @param {string[]} playerIDs list of player id
 * @param {User} userCaller user caller data
 * @param {string} uuid uniq uuid for call
 */
export async function sendMissedCallToAndroid(playerIDs: string[], userCaller: User, uuid: string) {
  const options = await getSendCallToAndroidOptions(playerIDs, userCaller, uuid, VoIPCallType.MISSED_VIDEO_CALL);
  const response = await axios.request(options);
  console.log(response.data);

  return response;
}

/**
 * Send test message to all user
*/
export const sendTestMessage = functions.https.onRequest(async (req, res) => {
  const playerID = req.query["playerID"];

  if (playerID) {
    const options = await getTestMessageOptions(playerID.toString());
    const axiosState = await axios.request(options);

    if (axiosState.status == 200) {
      res.send(axiosState.data);
    } else {
      res.send(axiosState.statusText);
    }
  }

  res.send("PlayerID is required");
});
