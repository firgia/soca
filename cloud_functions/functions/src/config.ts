/* eslint-disable max-len */
import * as dotenv from "dotenv";
dotenv.config();

export const ENVIRONMENT: "dev"| "prod" = "prod";
export const AGORA_APP_ID = process.env.AGORA_APP_ID;
export const AGORA_APP_CERTIFICATE = process.env.AGORA_APP_CERTIFICATE;
export const AGORA_VIDEO_CALL_LIMIT_IN_SECONDS = 600;
export const ONESIGNAL_URL_NOTIFICATIONS = process.env.ONESIGNAL_URL_NOTIFICATIONS;
export const ONESIGNAL_URL_PLAYERS = process.env.ONESIGNAL_URL_PLAYERS;
export const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
export const ONESIGNAL_VOIP_APP_ID = process.env.ONESIGNAL_VOIP_APP_ID;
export const ONESIGNAL_REST_API_KEY = process.env.ONESIGNAL_REST_API_KEY;
export const ONESIGNAL_VOIP_REST_API_KEY = process.env.ONESIGNAL_VOIP_REST_API_KEY;
export const ONESIGNAL_ANDROID_CHANNEL_ID_SYSTEM_IMPORTANT = process.env.ONESIGNAL_ANDROID_CHANNEL_ID_SYSTEM_IMPORTANT;
export const ONESIGNAL_ANDROID_CHANNEL_ID_SYSTEM_ACCOUNT = process.env.ONESIGNAL_ANDROID_CHANNEL_ID_SYSTEM_ACCOUNT;
