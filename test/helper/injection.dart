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
MockAuthProvider getMockAuthProvider() {
  MockAuthProvider mock = MockAuthProvider();
  _removeRegistrationIfExists<AuthProvider>();
  locator.registerSingleton<AuthProvider>(mock);

  return mock;
}

MockLocalLanguageProvider getMockLocalLanguageProvider() {
  MockLocalLanguageProvider mock = MockLocalLanguageProvider();
  _removeRegistrationIfExists<LocalLanguageProvider>();
  locator.registerSingleton<LocalLanguageProvider>(mock);

  return mock;
}

MockFunctionsProvider getMockFunctionsProvider() {
  MockFunctionsProvider mock = MockFunctionsProvider();
  _removeRegistrationIfExists<FunctionsProvider>();
  locator.registerSingleton<FunctionsProvider>(mock);

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

MockFirebaseAuth getMockFirebaseAuth() {
  MockFirebaseAuth mock = MockFirebaseAuth();
  _removeRegistrationIfExists<FirebaseAuth>();
  locator.registerSingleton<FirebaseAuth>(mock);

  return mock;
}

MockGoogleSignIn getMockGoogleSignIn() {
  MockGoogleSignIn mock = MockGoogleSignIn();
  _removeRegistrationIfExists<GoogleSignIn>();
  locator.registerSingleton<GoogleSignIn>(mock);

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

  /* ---------------------------------> DATA <------------------------------- */
  getMockAuthProvider();
  getMockFunctionsProvider();
  getMockLocalLanguageProvider();
  getMockLanguageRepository();

  /* ------------------------------> DEPENDENCIES <-------------------------- */
  getMockFlutterSecureStorage();
  getMockFirebaseAuth();
  getMockGoogleSignIn();
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

  /* ---------------------------------> DATA <------------------------------- */
  locator.unregister<AuthProvider>();
  locator.unregister<FunctionsProvider>();
  locator.unregister<LocalLanguageProvider>();
  locator.unregister<LanguageRepository>();

  /* -----------------------------> DEPENDENCIES <--------------------------- */
  locator.unregister<FlutterSecureStorage>();
  locator.unregister<FirebaseAuth>();
  locator.unregister<GoogleSignIn>();
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
