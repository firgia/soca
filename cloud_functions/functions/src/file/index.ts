/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
import * as functions from "firebase-functions";
import {saveAvatar} from "../user/functions/save-avatar";

export const onUpload = functions.storage.object().onFinalize(async (object) => {
  await saveAvatar(object);
  return Promise.resolve();
});
