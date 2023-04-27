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

MockCallKit getMockCallKit() {
  MockCallKit mock = MockCallKit();
  _removeRegistrationIfExists<CallKit>();
  locator.registerSingleton<CallKit>(mock);

  return mock;
}

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

MockDeviceSettings getMockDeviceSettings() {
  MockDeviceSettings mock = MockDeviceSettings();
  _removeRegistrationIfExists<DeviceSettings>();
  locator.registerSingleton<DeviceSettings>(mock);

  return mock;
}

/* ----------------------------------> DATA <-------------------------------- */
MockAuthProvider getMockAuthProvider() {
  MockAuthProvider mock = MockAuthProvider();
  _removeRegistrationIfExists<AuthProvider>();
  locator.registerSingleton<AuthProvider>(mock);

  return mock;
}

MockCallingProvider getMockCallingProvider() {
  MockCallingProvider mock = MockCallingProvider();
  _removeRegistrationIfExists<CallingProvider>();
  locator.registerSingleton<CallingProvider>(mock);

  return mock;
}

MockDatabaseProvider getMockDatabaseProvider() {
  MockDatabaseProvider mock = MockDatabaseProvider();
  _removeRegistrationIfExists<DatabaseProvider>();
  locator.registerSingleton<DatabaseProvider>(mock);

  return mock;
}

MockDeviceProvider getMockDeviceProvider() {
  MockDeviceProvider mock = MockDeviceProvider();
  _removeRegistrationIfExists<DeviceProvider>();
  locator.registerSingleton<DeviceProvider>(mock);

  return mock;
}

MockFunctionsProvider getMockFunctionsProvider() {
  MockFunctionsProvider mock = MockFunctionsProvider();
  _removeRegistrationIfExists<FunctionsProvider>();
  locator.registerSingleton<FunctionsProvider>(mock);

  return mock;
}

MockLocalLanguageProvider getMockLocalLanguageProvider() {
  MockLocalLanguageProvider mock = MockLocalLanguageProvider();
  _removeRegistrationIfExists<LocalLanguageProvider>();
  locator.registerSingleton<LocalLanguageProvider>(mock);

  return mock;
}

MockOneSignalProvider getMockOneSignalProvider() {
  MockOneSignalProvider mock = MockOneSignalProvider();
  _removeRegistrationIfExists<OneSignalProvider>();
  locator.registerSingleton<OneSignalProvider>(mock);

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

MockCallingRepository getMockCallingRepository() {
  MockCallingRepository mock = MockCallingRepository();
  _removeRegistrationIfExists<CallingRepository>();
  locator.registerSingleton<CallingRepository>(mock);

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
MockCompleter getMockCompleter() {
  MockCompleter mock = MockCompleter();
  _removeRegistrationIfExists<Completer>();
  locator.registerSingleton<Completer>(mock);

  return mock;
}

FakeDefaultCacheManager getFakeDefaultCacheManager() {
  FakeDefaultCacheManager mock = FakeDefaultCacheManager();
  _removeRegistrationIfExists<DefaultCacheManager>();
  locator.registerSingleton<DefaultCacheManager>(mock);

  return mock;
}

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

MockFirebaseDatabase getMockFirebaseDatabase() {
  MockFirebaseDatabase mock = MockFirebaseDatabase();
  _removeRegistrationIfExists<FirebaseDatabase>();
  locator.registerSingleton<FirebaseDatabase>(mock);

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

MockRtcEngine getMockRtcEngine() {
  MockRtcEngine mock = MockRtcEngine();
  _removeRegistrationIfExists<agora.RtcEngine>();
  locator.registerSingleton<agora.RtcEngine>(mock);

  return mock;
}

MockWidgetsBinding getMockWidgetsBinding() {
  MockWidgetsBinding mock = MockWidgetsBinding();
  _removeRegistrationIfExists<WidgetsBinding>();
  locator.registerSingleton<WidgetsBinding>(mock);

  return mock;
}

/* ---------------------------------> LOGIC <-------------------------------- */

MockCallActionBloc getMockCallActionBloc() {
  MockCallActionBloc mock = MockCallActionBloc();
  _removeRegistrationIfExists<CallActionBloc>();
  locator.registerSingleton<CallActionBloc>(mock);

  return mock;
}

MockCallStatisticBloc getMockCallStatisticBloc() {
  MockCallStatisticBloc mock = MockCallStatisticBloc();
  _removeRegistrationIfExists<CallStatisticBloc>();
  locator.registerSingleton<CallStatisticBloc>(mock);

  return mock;
}

MockFileBloc getMockFileBloc() {
  MockFileBloc mock = MockFileBloc();
  _removeRegistrationIfExists<FileBloc>();
  locator.registerSingleton<FileBloc>(mock);

  return mock;
}

MockIncomingCallBloc getMockIncomingCallBloc() {
  MockIncomingCallBloc mock = MockIncomingCallBloc();
  _removeRegistrationIfExists<IncomingCallBloc>();
  locator.registerSingleton<IncomingCallBloc>(mock);

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

MockUserBloc getMockUserBloc() {
  MockUserBloc mock = MockUserBloc();
  _removeRegistrationIfExists<UserBloc>();
  locator.registerSingleton<UserBloc>(mock);

  return mock;
}

MockVideoCallBloc getMockVideoCallBloc() {
  MockVideoCallBloc mock = MockVideoCallBloc();
  _removeRegistrationIfExists<VideoCallBloc>();
  locator.registerSingleton<VideoCallBloc>(mock);

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
  getMockCallKit();
  getMockDeviceFeedback();
  getMockDeviceInfo();
  getMockDeviceSettings();

  /* ---------------------------------> DATA <------------------------------- */
  getMockAuthProvider();
  getMockCallingProvider();
  getMockDatabaseProvider();
  getMockDeviceProvider();
  getMockFunctionsProvider();
  getMockLocalLanguageProvider();
  getMockOneSignalProvider();
  getMockUserProvider();
  getMockAuthRepository();
  getMockCallingRepository();
  getMockFileRepository();
  getMockLanguageRepository();
  getMockUserRepository();

  /* ------------------------------> DEPENDENCIES <-------------------------- */
  getMockCompleter();
  getFakeDefaultCacheManager();
  getMockDotEnv();
  getMockFlutterSecureStorage();
  getMockFirebaseAuth();
  getMockFirebaseDatabase();
  getMockFirebaseFunctions();
  getMockFirebaseStorage();
  getMockGoogleSignIn();
  getMockImageCropper();
  getMockImagePicker();
  getMockInternetConnectionChecker();
  getMockOneSignal();
  getMockRtcEngine();
  getMockWidgetsBinding();

  /* --------------------------------> LOGIC <------------------------------- */
  getMockCallActionBloc();
  getMockCallStatisticBloc();
  getMockFileBloc();
  getMockIncomingCallBloc();
  getMockLanguageBloc();
  getMockSignInBloc();
  getMockSignUpBloc();
  getMockSignUpFormBloc();
  getMockUserBloc();
  getMockVideoCallBloc();
  getMockAccountCubit();
  getMockRouteCubit();
  getMockSignOutCubit();
}

void unregisterLocator() {
  /* --------------------------------> CONFIG <------------------------------ */
  locator.unregister<AppNavigator>();

  /* ---------------------------------> CORE <------------------------------- */
  locator.unregister<CallKit>();
  locator.unregister<DeviceFeedback>();
  locator.unregister<DeviceInfo>();
  locator.unregister<DeviceSettings>();

  /* ---------------------------------> DATA <------------------------------- */
  locator.unregister<AuthProvider>();
  locator.unregister<CallingProvider>();
  locator.unregister<DatabaseProvider>();
  locator.unregister<DeviceProvider>();
  locator.unregister<FunctionsProvider>();
  locator.unregister<LocalLanguageProvider>();
  locator.unregister<OneSignalProvider>();
  locator.unregister<UserProvider>();
  locator.unregister<AuthRepository>();
  locator.unregister<CallingRepository>();
  locator.unregister<FileRepository>();
  locator.unregister<LanguageRepository>();
  locator.unregister<UserRepository>();

  /* -----------------------------> DEPENDENCIES <--------------------------- */
  locator.unregister<Completer>();
  locator.unregister<DefaultCacheManager>();
  locator.unregister<DotEnv>();
  locator.unregister<FlutterSecureStorage>();
  locator.unregister<FirebaseAuth>();
  locator.unregister<FirebaseDatabase>();
  locator.unregister<FirebaseFunctions>();
  locator.unregister<FirebaseStorage>();
  locator.unregister<GoogleSignIn>();
  locator.unregister<ImageCropper>();
  locator.unregister<ImagePicker>();
  locator.unregister<InternetConnectionChecker>();
  locator.unregister<OneSignal>();
  locator.unregister<agora.RtcEngine>();
  locator.unregister<WidgetsBinding>();

  /* --------------------------------> LOGIC <------------------------------- */
  locator.unregister<CallActionBloc>();
  locator.unregister<CallStatisticBloc>();
  locator.unregister<FileBloc>();
  locator.unregister<IncomingCallBloc>();
  locator.unregister<LanguageBloc>();
  locator.unregister<SignInBloc>();
  locator.unregister<SignUpBloc>();
  locator.unregister<SignUpFormBloc>();
  locator.unregister<UserBloc>();
  locator.unregister<VideoCallBloc>();
  locator.unregister<AccountCubit>();
  locator.unregister<RouteCubit>();
  locator.unregister<SignOutCubit>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
