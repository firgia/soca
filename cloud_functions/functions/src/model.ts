/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 *
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/* eslint-disable max-len */
import {DocumentSnapshot, DocumentData} from "firebase-admin/firestore";
import {getStringFromAny} from "./utility";

/* eslint-disable require-jsdoc */
export class User {
  uid: string|null;
  name: string|null;
  avatar: string|null;
  type: string|null;
  gender: string|null;
  dateOfBirth: string|null;

  constructor( uid: string|null,
      name: string|null,
      avatar: string|null,
      type: string|null,
      gender: string|null,
      dateOfBirth: string|null) {
    this.uid = uid;
    this.name = name;
    this.avatar = avatar;
    this.type = type;
    this.gender = gender;
    this.dateOfBirth = dateOfBirth;
  }

  toObject() {
    return {
      "uid": this.uid,
      "name": this.name,
      "avatar": this.avatar,
      "type": this.type,
      "gender": this.gender,
      "date_of_birth": this.dateOfBirth,
    };
  }

  static fromDocumentData(doc: DocumentSnapshot<DocumentData>) {
    const userData = doc.data();

    if (!doc.exists || !userData) {
      return null;
    }

    return new User(
        getStringFromAny(doc.id),
        getStringFromAny(userData.name),
        getStringFromAny(userData.avatar.url.medium),
        getStringFromAny(userData.type),
        getStringFromAny(userData.gender),
        getStringFromAny(userData.date_of_birth),
    );
  }
}
