/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

abstract class AppState {
  /// Set user already to home page
  void setUserAlreadyToHomePage(bool value);

  /// Return `true` if user is already to home page
  bool? get userAlreadyToHomePage;
}

class AppStateImpl implements AppState {
  bool? _userAlreadyToHomePage;

  @override
  void setUserAlreadyToHomePage(bool value) => _userAlreadyToHomePage = value;

  @override
  bool? get userAlreadyToHomePage => _userAlreadyToHomePage;
}
