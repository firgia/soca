/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late MockDotEnv dotEnv;

  setUp(() {
    dotEnv = MockDotEnv();
    Environtment.test(dotEnv);
  });

  group("Fields", () {
    group("current", () {
      test("Should set environment to development as a default", () {
        expect(Environtment.current, EnvirontmentType.development);
      });
    });

    group("onesignalAppID", () {
      test("Should return ONESIGNAL_APP_ID based on .env file", () {
        when(dotEnv.env).thenReturn({"ONESIGNAL_APP_ID": "12345"});
        expect(Environtment.onesignalAppID, "12345");
        verify(dotEnv.env).called(1);
      });

      test(
          "Should return empty string when ONESIGNAL_APP_ID is not available on .env file",
          () {
        when(dotEnv.env).thenReturn({"test": "12345"});
        expect(Environtment.onesignalAppID, "");
        verify(dotEnv.env).called(1);
      });
    });

    group("agoraAppID", () {
      test("Should return AGORA_APP_ID based on .env file", () {
        when(dotEnv.env).thenReturn({"AGORA_APP_ID": "123"});
        expect(Environtment.agoraAppID, "123");
        verify(dotEnv.env).called(1);
      });

      test(
          "Should return empty string when AGORA_APP_ID is not available on .env file",
          () {
        when(dotEnv.env).thenReturn({"test": "123"});
        expect(Environtment.agoraAppID, "");
        verify(dotEnv.env).called(1);
      });
    });
  });

  group("Functions", () {
    group("setCurrentEnvirontment", () {
      test(
          "Should change the current environtment to staging when call setCurrentEnvirontment with staging parameter",
          () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.staging);
        expect(Environtment.current, EnvirontmentType.staging);
      });

      test(
          "Should change the current environtment to production when call setCurrentEnvirontment with production parameter",
          () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.production);
        expect(Environtment.current, EnvirontmentType.production);
      });

      test(
          "Should change the current environtment to development when call setCurrentEnvirontment with development parameter",
          () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.development);
        expect(Environtment.current, EnvirontmentType.development);
      });
    });

    group("isProduction", () {
      test("Should return true if current environtment is production", () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.production);
        expect(Environtment.isProduction(), true);
      });

      test("Should return false if current environtment is not production", () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.development);
        expect(Environtment.isProduction(), false);
      });
    });

    group("isStaging", () {
      test("Should return true if current environtment is staging", () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.staging);
        expect(Environtment.isStaging(), true);
      });

      test("Should return false if current environtment is not staging", () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.production);
        expect(Environtment.isStaging(), false);
      });
    });

    group("isDevelopment", () {
      test("Should return true if current environtment is development", () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.development);
        expect(Environtment.isDevelopment(), true);
      });

      test("Should return false if current environtment is not development",
          () {
        Environtment.setCurrentEnvirontment(EnvirontmentType.production);
        expect(Environtment.isDevelopment(), false);
      });
    });
  });
}
