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

MockDeviceFeedback getMockDeviceFeedback() {
  MockDeviceFeedback mock = MockDeviceFeedback();
  _removeRegistrationIfExists<DeviceFeedback>();
  locator.registerSingleton<DeviceFeedback>(mock);

  return mock;
}

MockDeviceInfo getMockDeviceInfo() {
  MockDeviceInfo mock = MockDeviceInfo();
  _removeRegistrationIfExists<DeviceInfo>();
  locator.registerSingleton<DeviceInfo>(mock);

  return mock;
}

/* ----------------------------------> DATA <-------------------------------- */
MockAuthProvider getMockAuthProvider() {
  MockAuthProvider mock = MockAuthProvider();
  _removeRegistrationIfExists<AuthProvider>();
  locator.registerSingleton<AuthProvider>(mock);

  return mock;
}

MockDeviceProvider getMockDeviceProvider() {
  MockDeviceProvider mock = MockDeviceProvider();
  _removeRegistrationIfExists<DeviceProvider>();
  locator.registerSingleton<DeviceProvider>(mock);

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

MockUserProvider getMockUserProvider() {
  MockUserProvider mock = MockUserProvider();
  _removeRegistrationIfExists<UserProvider>();
  locator.registerSingleton<UserProvider>(mock);

  return mock;
}

MockAuthRepository getMockAuthRepository() {
  MockAuthRepository mock = MockAuthRepository();
  _removeRegistrationIfExists<AuthRepository>();
  locator.registerSingleton<AuthRepository>(mock);

  return mock;
}

MockFileRepository getMockFileRepository() {
  MockFileRepository mock = MockFileRepository();
  _removeRegistrationIfExists<FileRepository>();
  locator.registerSingleton<FileRepository>(mock);

  return mock;
}

MockLanguageRepository getMockLanguageRepository() {
  MockLanguageRepository mock = MockLanguageRepository();
  _removeRegistrationIfExists<LanguageRepository>();
  locator.registerSingleton<LanguageRepository>(mock);

  return mock;
}

MockUserRepository getMockUserRepository() {
  MockUserRepository mock = MockUserRepository();
  _removeRegistrationIfExists<UserRepository>();
  locator.registerSingleton<UserRepository>(mock);

  return mock;
}

/* ------------------------------> DEPENDENCIES <---------------------------- */
MockDotEnv getMockDotEnv() {
  MockDotEnv mock = MockDotEnv();
  _removeRegistrationIfExists<DotEnv>();
  locator.registerSingleton<DotEnv>(mock);

  return mock;
}

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

MockFirebaseFunctions getMockFirebaseFunctions() {
  MockFirebaseFunctions mock = MockFirebaseFunctions();
  _removeRegistrationIfExists<FirebaseFunctions>();
  locator.registerSingleton<FirebaseFunctions>(mock);

  return mock;
}

MockFirebaseStorage getMockFirebaseStorage() {
  MockFirebaseStorage mock = MockFirebaseStorage();
  _removeRegistrationIfExists<FirebaseStorage>();
  locator.registerSingleton<FirebaseStorage>(mock);

  return mock;
}

MockGoogleSignIn getMockGoogleSignIn() {
  MockGoogleSignIn mock = MockGoogleSignIn();
  _removeRegistrationIfExists<GoogleSignIn>();
  locator.registerSingleton<GoogleSignIn>(mock);

  return mock;
}

MockImageCropper getMockImageCropper() {
  MockImageCropper mock = MockImageCropper();
  _removeRegistrationIfExists<ImageCropper>();
  locator.registerSingleton<ImageCropper>(mock);

  return mock;
}

MockImagePicker getMockImagePicker() {
  MockImagePicker mock = MockImagePicker();
  _removeRegistrationIfExists<ImagePicker>();
  locator.registerSingleton<ImagePicker>(mock);

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

MockWidgetsBinding getMockWidgetsBinding() {
  MockWidgetsBinding mock = MockWidgetsBinding();
  _removeRegistrationIfExists<WidgetsBinding>();
  locator.registerSingleton<WidgetsBinding>(mock);

  return mock;
}

/* ---------------------------------> LOGIC <-------------------------------- */

MockFileBloc getMockFileBloc() {
  MockFileBloc mock = MockFileBloc();
  _removeRegistrationIfExists<FileBloc>();
  locator.registerSingleton<FileBloc>(mock);

  return mock;
}

MockLanguageBloc getMockLanguageBloc() {
  MockLanguageBloc mock = MockLanguageBloc();
  _removeRegistrationIfExists<LanguageBloc>();
  locator.registerSingleton<LanguageBloc>(mock);

  return mock;
}

MockSignInBloc getMockSignInBloc() {
  MockSignInBloc mock = MockSignInBloc();
  _removeRegistrationIfExists<SignInBloc>();
  locator.registerSingleton<SignInBloc>(mock);

  return mock;
}

MockSignUpBloc getMockSignUpBloc() {
  MockSignUpBloc mock = MockSignUpBloc();
  _removeRegistrationIfExists<SignUpBloc>();
  locator.registerSingleton<SignUpBloc>(mock);

  return mock;
}

MockSignUpFormBloc getMockSignUpFormBloc() {
  MockSignUpFormBloc mock = MockSignUpFormBloc();
  _removeRegistrationIfExists<SignUpFormBloc>();
  locator.registerSingleton<SignUpFormBloc>(mock);

  return mock;
}

MockAccountCubit getMockAccountCubit() {
  MockAccountCubit mock = MockAccountCubit();
  _removeRegistrationIfExists<AccountCubit>();
  locator.registerSingleton<AccountCubit>(mock);

  return mock;
}

MockRouteCubit getMockRouteCubit() {
  MockRouteCubit mock = MockRouteCubit();
  _removeRegistrationIfExists<RouteCubit>();
  locator.registerSingleton<RouteCubit>(mock);

  return mock;
}

MockSignOutCubit getMockSignOutCubit() {
  MockSignOutCubit mock = MockSignOutCubit();
  _removeRegistrationIfExists<SignOutCubit>();
  locator.registerSingleton<SignOutCubit>(mock);

  return mock;
}

void registerLocator() {
  /* --------------------------------> CONFIG <------------------------------ */
  getMockAppNavigator();

  /* ---------------------------------> CORE <------------------------------- */
  getMockDeviceFeedback();
  getMockDeviceInfo();

  /* ---------------------------------> DATA <------------------------------- */
  getMockAuthProvider();
  getMockDeviceProvider();
  getMockFunctionsProvider();
  getMockUserProvider();
  getMockLocalLanguageProvider();
  getMockAuthRepository();
  getMockFileRepository();
  getMockLanguageRepository();
  getMockUserRepository();

  /* ------------------------------> DEPENDENCIES <-------------------------- */
  getMockDotEnv();
  getMockFlutterSecureStorage();
  getMockFirebaseAuth();
  getMockFirebaseFunctions();
  getMockFirebaseStorage();
  getMockGoogleSignIn();
  getMockImageCropper();
  getMockImagePicker();
  getMockInternetConnectionChecker();
  getMockOneSignal();
  getMockWidgetsBinding();

  /* --------------------------------> LOGIC <------------------------------- */
  getMockFileBloc();
  getMockLanguageBloc();
  getMockSignInBloc();
  getMockSignUpBloc();
  getMockSignUpFormBloc();
  getMockAccountCubit();
  getMockRouteCubit();
  getMockSignOutCubit();
}

void unregisterLocator() {
  /* --------------------------------> CONFIG <------------------------------ */
  locator.unregister<AppNavigator>();

  /* ---------------------------------> CORE <------------------------------- */
  locator.unregister<DeviceFeedback>();
  locator.unregister<DeviceInfo>();

  /* ---------------------------------> DATA <------------------------------- */
  locator.unregister<AuthProvider>();
  locator.unregister<DeviceProvider>();
  locator.unregister<FunctionsProvider>();
  locator.unregister<UserProvider>();
  locator.unregister<LocalLanguageProvider>();
  locator.unregister<AuthRepository>();
  locator.unregister<FileRepository>();
  locator.unregister<LanguageRepository>();
  locator.unregister<UserRepository>();

  /* -----------------------------> DEPENDENCIES <--------------------------- */
  locator.unregister<DotEnv>();
  locator.unregister<FlutterSecureStorage>();
  locator.unregister<FirebaseAuth>();
  locator.unregister<FirebaseFunctions>();
  locator.unregister<FirebaseStorage>();
  locator.unregister<GoogleSignIn>();
  locator.unregister<ImageCropper>();
  locator.unregister<ImagePicker>();
  locator.unregister<InternetConnectionChecker>();
  locator.unregister<OneSignal>();
  locator.unregister<WidgetsBinding>();

  /* --------------------------------> LOGIC <------------------------------- */
  locator.unregister<FileBloc>();
  locator.unregister<LanguageBloc>();
  locator.unregister<SignInBloc>();
  locator.unregister<SignUpBloc>();
  locator.unregister<SignUpFormBloc>();
  locator.unregister<AccountCubit>();
  locator.unregister<RouteCubit>();
  locator.unregister<SignOutCubit>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
