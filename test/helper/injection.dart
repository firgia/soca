/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'helper.dart';

final locator = GetIt.I;

/* ---------------------------------> CONFIG <------------------------------- */
MockAppNavigator getMockAppNavigator() {
  MockAppNavigator mock = MockAppNavigator();
  _removeRegistrationIfExists<AppNavigator>();
  locator.registerSingleton<AppNavigator>(mock);

  return mock;
}

/* ----------------------------------> CORE <-------------------------------- */

MockPlatformInfo getMockPlatformInfo() {
  MockPlatformInfo mock = MockPlatformInfo();
  _removeRegistrationIfExists<PlatformInfo>();
  locator.registerSingleton<PlatformInfo>(mock);

  return mock;
}

/* ---------------------------------> LOGIC <-------------------------------- */

MockLanguageBloc getMockLanguageBloc() {
  MockLanguageBloc mock = MockLanguageBloc();
  _removeRegistrationIfExists<LanguageBloc>();
  locator.registerSingleton<LanguageBloc>(mock);

  return mock;
}

void registerLocator() {
  /* --------------------------------> CONFIG <------------------------------ */
  getMockAppNavigator();

  /* ---------------------------------> CORE <------------------------------- */
  getMockPlatformInfo();

  /* --------------------------------> LOGIC <------------------------------- */
  getMockLanguageBloc();
}

void unregisterLocator() {
  /* --------------------------------> CONFIG <------------------------------ */
  locator.unregister<AppNavigator>();

  /* ---------------------------------> CORE <------------------------------- */
  locator.unregister<PlatformInfo>();

  /* --------------------------------> LOGIC <------------------------------- */
  locator.unregister<LanguageBloc>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
