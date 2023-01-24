import ar from "../../../i18n/ar.json";
import en from "../../../i18n/en.json";
import es from "../../../i18n/es.json";
import hi from "../../../i18n/hi.json";
import id from "../../../i18n/id.json";
import ru from "../../../i18n/ru.json";
import zh from "../../../i18n/zh.json";

// Get message based on key and language
export const translate = (language: string, key: string): string =>{
  let langData : {[key: string] : string} ={};

  switch (language) {
    case "ar":
      langData = ar;
      break;
    case "es":
      langData = es;
      break;
    case "hi":
      langData = hi;
      break;
    case "id":
      langData = id;
      break;
    case "ru":
      langData = ru;
      break;
    case "zh":
      langData = zh;
      break;
    default:
      langData = en;
      break;
  }
  return langData[key];
};


// Get message from all language based on key
export const translateAll = (key: string): {[key:string] : string} =>{
  const langAR : {[key: string] : string} = ar;
  const langEN : {[key: string] : string} = en;
  const langES : {[key: string] : string} = es;
  const langHI : {[key: string] : string} = hi;
  const langID : {[key: string] : string} = id;
  const langRU : {[key: string] : string} = ru;
  const langZH : {[key: string] : string} = zh;


  const langData : {[key: string] : string} ={
    "ar": langAR[key],
    "en": langEN[key],
    "es": langES[key],
    "hi": langHI[key],
    "id": langID[key],
    "ru": langRU[key],
    "zh": langZH[key],
  };

  return langData;
};
