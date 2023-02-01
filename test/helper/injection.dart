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

/* ----------------------------------> DATA <-------------------------------- */
MockLocalLanguageProvider getMockLocalLanguageProvider() {
  MockLocalLanguageProvider mock = MockLocalLanguageProvider();
  _removeRegistrationIfExists<LocalLanguageProvider>();
  locator.registerSingleton<LocalLanguageProvider>(mock);

  return mock;
}

MockLanguageRepository getMockLanguageRepository() {
  MockLanguageRepository mock = MockLanguageRepository();
  _removeRegistrationIfExists<LanguageRepository>();
  locator.registerSingleton<LanguageRepository>(mock);

  return mock;
}

/* ------------------------------> DEPENDENCIES <---------------------------- */

MockFlutterSecureStorage getMockFlutterSecureStorage() {
  MockFlutterSecureStorage mock = MockFlutterSecureStorage();
  _removeRegistrationIfExists<FlutterSecureStorage>();
  locator.registerSingleton<FlutterSecureStorage>(mock);

  return mock;
}

MockInternetConnectionChecker getMockInternetConnectionChecker() {
  MockInternetConnectionChecker mock = MockInternetConnectionChecker();
  _removeRegistrationIfExists<InternetConnectionChecker>();
  locator.registerSingleton<InternetConnectionChecker>(mock);

  return mock;
}

MockOneSignal getMockOneSignal() {
  MockOneSignal mock = MockOneSignal();
  _removeRegistrationIfExists<OneSignal>();
  locator.registerSingleton<OneSignal>(mock);

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

  /* ----------------------------------> DATA <-------------------------------- */
  getMockLocalLanguageProvider();
  getMockLanguageRepository();

  /* ------------------------------> DEPENDENCIES <-------------------------- */
  getMockFlutterSecureStorage();
  getMockInternetConnectionChecker();
  getMockOneSignal();

  /* --------------------------------> LOGIC <------------------------------- */
  getMockLanguageBloc();
}

void unregisterLocator() {
  /* --------------------------------> CONFIG <------------------------------ */
  locator.unregister<AppNavigator>();

  /* ---------------------------------> CORE <------------------------------- */
  locator.unregister<PlatformInfo>();

  /* ----------------------------------> DATA <-------------------------------- */
  locator.unregister<LocalLanguageProvider>();
  locator.unregister<LanguageRepository>();

  /* -----------------------------> DEPENDENCIES <--------------------------- */
  locator.unregister<FlutterSecureStorage>();
  locator.unregister<InternetConnectionChecker>();
  locator.unregister<OneSignal>();

  /* --------------------------------> LOGIC <------------------------------- */
  locator.unregister<LanguageBloc>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
