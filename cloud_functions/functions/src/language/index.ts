/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import ar from "../../i18n/ar.json";
import en from "../../i18n/en.json";
import es from "../../i18n/es.json";
import hi from "../../i18n/hi.json";
import id from "../../i18n/id.json";
import ru from "../../i18n/ru.json";
import zh from "../../i18n/zh.json";
import language from "../../i18n/language.json";
import * as functions from "firebase-functions";
import * as tr from "./functions/translate";

export const getTranslations = functions.https.onCall( () => {
  return {
    version_code: 1,
    ar: ar,
    en: en,
    es: es,
    hi: hi,
    id: id,
    ru: ru,
    zh: zh,
  };
});

export const getLanguage = functions.https.onCall( () => {
  return language;
});

export const translate = (language: string, key: string): string => {
  return tr.translate(language, key);
};

// Get message from all language based on key
export const translateAll = (key: string): {[key:string] : string} =>{
  return tr.translateAll(key);
};
