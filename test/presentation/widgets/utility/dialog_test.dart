/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;
  late MockSingletonFlutterWindow window;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
    window = MockSingletonFlutterWindow();
  });

  tearDown(() => unregisterLocator());

  group(".pickImage()", () {
    setUp(() {
      when(window.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.window).thenReturn(window);
    });

    Future showPickImage(
      WidgetTester tester, {
      VoidCallback? onTapCamera,
      VoidCallback? onTapGallery,
    }) async {
      await tester.pumpApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AppDialog dialog = AppDialog(context);
                  dialog.pickImage(
                    onTapCamera: onTapCamera,
                    onTapGallery: onTapGallery,
                  );
                },
                child: const Text("show dialog"),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text("show dialog"));
      await tester.pumpAndSettle();
    }

    testWidgets("Should show the title text", (tester) async {
      await tester.runAsync(() async {
        await showPickImage(tester);

        expect(
          find.text(LocaleKeys.choose_an_image.tr()),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show the camera icons and camera text", (tester) async {
      await tester.runAsync(() async {
        await showPickImage(tester);

        expect(
          find.text(LocaleKeys.camera.tr()),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("dialog_pick_image_camera_icon_button")),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show the gallery icons and gallery text",
        (tester) async {
      await tester.runAsync(() async {
        await showPickImage(tester);

        expect(
          find.text(LocaleKeys.gallery.tr()),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("dialog_pick_image_gallery_icon_button")),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should execute onTapCamera when camera icon button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        bool isCameraTapped = false;
        bool isGaleryTapped = false;

        await showPickImage(
          tester,
          onTapCamera: () => isCameraTapped = true,
          onTapGallery: () => isGaleryTapped = true,
        );

        Finder cameraButton =
            find.byKey(const Key("dialog_pick_image_camera_icon_button"));
        await tester.tap(cameraButton);
        await tester.pumpAndSettle();

        expect(isCameraTapped, true);
        expect(isGaleryTapped, false);
      });
    });

    testWidgets(
        "Should execute onTapGallery when gallery icon button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        bool isCameraTapped = false;
        bool isGaleryTapped = false;

        await showPickImage(
          tester,
          onTapCamera: () => isCameraTapped = true,
          onTapGallery: () => isGaleryTapped = true,
        );

        Finder cameraButton =
            find.byKey(const Key("dialog_pick_image_gallery_icon_button"));
        await tester.tap(cameraButton);
        await tester.pumpAndSettle();

        expect(isCameraTapped, false);
        expect(isGaleryTapped, true);
      });
    });
  });

  group(".show()", () {
    testWidgets("Should show the child", (tester) async {
      when(window.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.window).thenReturn(window);

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppDialog dialog = AppDialog(context);

                    dialog.show(
                      childBuilder: (context, brightness) {
                        return const SizedBox(
                          key: Key("test_child"),
                        );
                      },
                    );
                  },
                  child: const Text("show dialog"),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text("show dialog"));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key("test_child")),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show the child based on brightness dark",
        (tester) async {
      when(window.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.window).thenReturn(window);

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppDialog dialog = AppDialog(context);

                    dialog.show(
                      childBuilder: (context, brightness) {
                        if (brightness == Brightness.dark) {
                          return const SizedBox(
                            key: Key("test_child_dark"),
                          );
                        } else {
                          return const SizedBox(
                            key: Key("test_child_light"),
                          );
                        }
                      },
                    );
                  },
                  child: const Text("show dialog"),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text("show dialog"));
        await tester.pumpAndSettle();

        Dialog dialog = find.byType(Dialog).getWidget() as Dialog;

        expect(dialog.backgroundColor, AppColors.cardDark);

        expect(
          find.byKey(const Key("test_child_dark")),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("test_child_light")),
          findsNothing,
        );
      });
    });

    testWidgets("Should show the child based on brightness light",
        (tester) async {
      when(window.platformBrightness).thenReturn(Brightness.light);
      when(widgetBinding.window).thenReturn(window);

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppDialog dialog = AppDialog(context);

                    dialog.show(
                      childBuilder: (context, brightness) {
                        if (brightness == Brightness.dark) {
                          return const SizedBox(
                            key: Key("test_child_dark"),
                          );
                        } else {
                          return const SizedBox(
                            key: Key("test_child_light"),
                          );
                        }
                      },
                    );
                  },
                  child: const Text("show dialog"),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text("show dialog"));
        await tester.pumpAndSettle();

        Dialog dialog = find.byType(Dialog).getWidget() as Dialog;

        expect(dialog.backgroundColor, AppColors.cardLight);

        expect(
          find.byKey(const Key("test_child_light")),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("test_child_dark")),
          findsNothing,
        );
      });
    });
  });
}
