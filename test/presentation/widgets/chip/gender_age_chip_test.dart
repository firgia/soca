import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findAgeText() => find.byKey(const Key("gender_age_chip_age_text"));
  Finder findMaleIcon() => find.byKey(const Key("gender_age_chip_male_icon"));
  Finder findFemaleIcon() =>
      find.byKey(const Key("gender_age_chip_female_icon"));
  Finder findContainer() => find.byType(Container);

  group("Color", () {
    Future<BoxDecoration> showGenderAgeChip(
        WidgetTester tester, Gender gender) async {
      await tester.pumpApp(
        child: Scaffold(
          body: GenderAgeChip(
            gender: gender,
          ),
        ),
      );

      Container container = findContainer().getWidget() as Container;
      return container.decoration! as BoxDecoration;
    }

    testWidgets("Should set color based on Gender", (tester) async {
      await tester.runAsync(() async {
        // MALE
        BoxDecoration maleDecoration =
            await showGenderAgeChip(tester, Gender.male);
        expect(
          maleDecoration.color,
          AppColors.genderMaleColor,
        );

        // FEMALE
        BoxDecoration femaleDecoration =
            await showGenderAgeChip(tester, Gender.female);
        expect(
          femaleDecoration.color,
          AppColors.genderFemaleColor,
        );
      });
    });
  });

  group("Icon", () {
    testWidgets("Should hide icon gender when gender is null", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: GenderAgeChip(),
          ),
        );

        expect(findMaleIcon(), findsNothing);
        expect(findFemaleIcon(), findsNothing);
      });
    });

    testWidgets("Should show male icon when gender is male", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: GenderAgeChip(
              gender: Gender.male,
            ),
          ),
        );

        expect(findMaleIcon(), findsOneWidget);
        expect(findFemaleIcon(), findsNothing);
      });
    });

    testWidgets("Should show female icon when gender is female",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: GenderAgeChip(
              gender: Gender.female,
            ),
          ),
        );

        expect(findMaleIcon(), findsNothing);
        expect(findFemaleIcon(), findsOneWidget);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show age text when age is not null", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: GenderAgeChip(
              age: 12,
            ),
          ),
        );

        expect(find.text("12"), findsOneWidget);
        expect(findAgeText(), findsOneWidget);
      });
    });

    testWidgets("Should hide age text when age is null", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: GenderAgeChip(),
          ),
        );

        expect(findAgeText(), findsNothing);
      });
    });
  });
}
