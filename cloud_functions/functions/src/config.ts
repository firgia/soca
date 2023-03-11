/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
import * as dotenv from "dotenv";

export const ENVIRONMENT: "development"| "staging" | "production" = "production";
dotenv.config({path: `.env.${ENVIRONMENT}`});

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
