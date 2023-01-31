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

MockPlatformInfo getMockPlatformInfo() {
  MockPlatformInfo platformInfo = MockPlatformInfo();
  _removeRegistrationIfExists<PlatformInfo>();
  locator.registerSingleton<PlatformInfo>(platformInfo);

  return platformInfo;
}

void registerLocator() {
  getMockPlatformInfo();
}

void unregisterLocator() {
  locator.unregister<PlatformInfo>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
