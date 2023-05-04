/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import * as admin from "firebase-admin";
import * as app from "./app/index";
import * as auth from "./auth/index";
import * as calling from "./calling/index";
import * as file from "./file/index";
import * as language from "./language/index";
import * as notification from "./notification/index";
import * as user from "./user/index";

admin.initializeApp();

// App
export const getMinimumVersionApp = app.getMinimumVersion;

// Auth
export const onSignIn = auth.onSignIn;
export const onUploadFile = file.onUpload;

// Calling
export const answerCall = calling.answerCall;
export const createCall = calling.createCall;
export const declineCall = calling.declineCall;
export const endCall = calling.endCall;
export const getCall = calling.getCall;
export const getCallHistory = calling.getCallHistory;
export const getCallStatistic = calling.getCallStatistic;
export const getRTCCredential = calling.getRTCCredential;
export const updateCallSettings = calling.updateCallSettings;
export const onCreateCall = calling.onCreate;

// Language
export const getTranslationsLanguage = language.getTranslations;
export const getLanguage= language.getLanguage;

// User
export const createUser = user.create;
export const getProfileUser = user.getProfile;
export const onUpdateUser = user.onUpdate;

// Notification
export const sendOneSignalTestMessage = notification.sendTestMessage;
