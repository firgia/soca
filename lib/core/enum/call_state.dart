/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

enum CallState {
  /// Represent calling is in progress or waiting for answer
  waiting,

  /// Represent another user to answer the caller and communication between users is ongoing
  ongoing,

  /// Represent caller user has canceled the calling and the calling is ended
  endedWithCanceled,

  /// Represent calling is ended becuase no body answer the call
  endedWithUnanswered,

  /// Represent user has ended the conversation
  ended,

  // Represent user has declined the call
  endedWithDeclined,
}
