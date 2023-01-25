/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

enum EnvirontmentType {
  /// This environment is used for publishing apps to end user
  production,

  /// This environment is used for publishing apps to team or stackholder
  staging,

  /// This environment is used for testing the update, fix bug or add new features
  development,
}
