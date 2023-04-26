/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

enum RTCRole {
  /// The publisher can publish a voice/video call or a live broadcast.
  ///
  /// [Explore more More Agora RTC role](https://docs.agora.io/en/voice-calling/reference/glossary?platform=flutter#app-certificate?platform=All%20Platforms)
  publisher,

  /// The audience can only subscribe to the remote audio and video streams,
  /// but cannot publish the audio and video streams
  ///
  /// [Explore more More Agora RTC role](https://docs.agora.io/en/voice-calling/reference/glossary?platform=flutter#app-certificate?platform=All%20Platforms)
  audience,
}
