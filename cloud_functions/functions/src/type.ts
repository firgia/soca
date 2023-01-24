/* eslint-disable max-len */
/* eslint-disable @typescript-eslint/no-namespace */
export namespace UserType {
    export const BLIND = "blind";
    export const VOLUNTEER = "volunteer";
}

export namespace Gender {
    export const MALE = "male";
    export const FEMALE = "female";
}

export namespace DevicePlatform {
    export const ANDROID = "android";
    export const IOS = "ios";
}

export namespace CallState {
    // Represent calling is in progress or waiting for answer
    export const WAITING = "waiting";
    // Represent another user to answer the caller and communication between users is ongoing
    export const ONGOING = "ongoing";
    // Represent caller user has canceled the calling and the calling is ended
    export const ENDED_WITH_CANCELED = "ended_with_canceled";
    // Represent calling is ended becuase no body answer the call
    export const ENDED_WITH_UNANSWERED = "ended_with_unanswered";
    // Represent user has ended the conversation
    export const ENDED = "ended";
    // Represent user has declined the call
    export const ENDED_WITH_DECLINED = "ended_with_declined";
}
export namespace CallRole {
    // Represent the answerer user of calling
    export const ANSWERER = "answerer";
    // Represent the caller user of calling
    export const CALLER = "caller";
}

export namespace VoIPCallType {
    // Represent new call from other user
    export const INCOMING_VIDEO_CALL = "incoming_video_call";
    // Represent user has missed the call
    export const MISSED_VIDEO_CALL = "missed_video_call";
}
