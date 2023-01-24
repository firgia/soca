/* eslint-disable max-len */
import * as functions from "firebase-functions";
import {saveAvatar} from "../user/functions/save-avatar";

export const onUpload = functions.storage.object().onFinalize(async (object) => {
  await saveAvatar(object);
  return Promise.resolve();
});
