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
  late MockPlatformDispatcher platformDispatcher;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
    platformDispatcher = MockPlatformDispatcher();
  });

  tearDown(() => unregisterLocator());

  Finder findCameraText() => find.text(LocaleKeys.camera.tr());
  Finder findChooseAnImageText() => find.text(LocaleKeys.choose_an_image.tr());
  Finder findGalleryText() => find.text(LocaleKeys.gallery.tr());
  Finder findPickImageCameraIcon() =>
      find.byKey(const Key("dialog_pick_image_camera_icon_button"));
  Finder findPickImageGalleryIcon() =>
      find.byKey(const Key("dialog_pick_image_gallery_icon_button"));
  Finder findAdaptiveLoading() => find.byType(AdaptiveLoading);

  group(".pickImage()", () {
    setUp(() {
      when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
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
          findChooseAnImageText(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show the camera icons and camera text", (tester) async {
      await tester.runAsync(() async {
        await showPickImage(tester);

        expect(
          findCameraText(),
          findsOneWidget,
        );

        expect(
          findPickImageCameraIcon(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show the gallery icons and gallery text",
        (tester) async {
      await tester.runAsync(() async {
        await showPickImage(tester);

        expect(
          findGalleryText(),
          findsOneWidget,
        );

        expect(
          findPickImageGalleryIcon(),
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

        await tester.tap(findPickImageCameraIcon());
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

        await tester.tap(findPickImageGalleryIcon());
        await tester.pumpAndSettle();

        expect(isCameraTapped, false);
        expect(isGaleryTapped, true);
      });
    });
  });

  group(".show()", () {
    testWidgets("Should show the child", (tester) async {
      when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);

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
      when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);

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
      when(platformDispatcher.platformBrightness).thenReturn(Brightness.light);
      when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);

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

  group(".showLoadingPanel()", () {
    setUp(() {
      when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
    });

    Future showLoadingPanel(WidgetTester tester) async {
      await tester.pumpApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AppDialog dialog = AppDialog(context);
                  dialog.showLoadingPanel();
                },
                child: const Text("show dialog"),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text("show dialog"));
      await tester.pump();
    }

    testWidgets("Should show [AdaptiveLoading]", (tester) async {
      await tester.runAsync(() async {
        await showLoadingPanel(tester);

        expect(
          findAdaptiveLoading(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should still show when screen is tapped", (tester) async {
      await tester.runAsync(() async {
        await showLoadingPanel(tester);

        expect(
          findAdaptiveLoading(),
          findsOneWidget,
        );

        await tester.tapAt(const Offset(10, 10));
        await tester.pump();

        expect(
          findAdaptiveLoading(),
          findsOneWidget,
        );

        await tester.tapAt(const Offset(30, 30));
        await tester.pump();

        expect(
          findAdaptiveLoading(),
          findsOneWidget,
        );
      });
    });
  });
}
