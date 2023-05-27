/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();

    MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
    when(platformDispatcher.platformBrightness).thenReturn(Brightness.light);
    when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
  });

  tearDown(() => unregisterLocator());

  Finder findEditButton() => find.byKey(const Key("profile_card_edit_button"));

  User user = User(
    id: "123",
    avatar: const URLImage(
      small: "small.png",
      medium: "medium.png",
      large: "large.png",
      original: "original.png",
    ),
    activity: UserActivity(
      online: true,
      lastSeen: DateTime.tryParse("2023-02-11T14:12:06.182067"),
    ),
    dateOfBirth: DateTime.tryParse("2023-02-11T14:12:06.182067"),
    gender: Gender.male,
    language: const ["id", "en"],
    name: "Firgia",
    info: UserInfo(
      dateJoined: DateTime.tryParse("2023-02-11T14:12:06.182067"),
      listOfCallYears: const ["2022", "2023"],
      totalCalls: 12,
      totalFriends: 13,
      totalVisitors: 14,
    ),
    type: UserType.volunteer,
  );

  group("Edit Button", () {
    testWidgets("Should show edit button when onTapEdit is not null",
        (tester) async {
      await tester.runAsync(() async {
        bool tapped = false;
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileCard(
              user: user,
              onTapEdit: () {
                tapped = true;
              },
            ),
          ),
        );

        expect(findEditButton(), findsOneWidget);

        await tester.tap(findEditButton());
        await tester.pumpAndSettle();

        expect(tapped, true);
      });
    });

    testWidgets("Should hide edit button when onTapEdit is null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileCard(
              user: user,
            ),
          ),
        );

        expect(findEditButton(), findsNothing);
      });
    });
  });

  group("Image", () {
    testWidgets("Should show [ProfileImage]", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileCard(
              user: user,
            ),
          ),
        );

        expect(find.byType(ProfileImage), findsOneWidget);
      });
    });
  });

  group("Loading", () {
    testWidgets("Should show [CustomShimmer] & [ProfileImage.loading]",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: ProfileCard.loading(),
          ),
        );

        expect(find.byType(CustomShimmer), findsWidgets);
        expect(find.byType(ProfileImage), findsOneWidget);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show name text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileCard(
              user: user,
            ),
          ),
        );

        expect(find.text(user.name!), findsOneWidget);
      });
    });

    testWidgets("Should show user type text with [UserTypeChip]",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileCard(
              user: user,
            ),
          ),
        );

        expect(
            find.text(user.type == UserType.blind
                ? LocaleKeys.blind.tr()
                : LocaleKeys.volunteer.tr()),
            findsOneWidget);

        expect(find.byType(UserTypeChip), findsOneWidget);
      });
    });

    testWidgets("Should show age text with [GenderAgeChip]", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileCard(
              user: user,
            ),
          ),
        );

        expect(find.byType(GenderAgeChip), findsOneWidget);
      });
    });
  });
}
