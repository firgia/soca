/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late MockImageCropper imageCropper;
  late MockImagePicker imagePicker;
  late FileRepository fileRepository;

  setUp(() {
    registerLocator();
    imageCropper = getMockImageCropper();
    imagePicker = getMockImagePicker();
    fileRepository = FileRepository();
  });

  tearDown(() => unregisterLocator());

  File sampleFile = File("assets/images/raster/avatar.png");

  group(".getProfileImage()", () {
    test("Should return null when image is not picked", () async {
      when(imagePicker.pickImage(source: anyNamed("source")))
          .thenAnswer((_) => Future.value(null));

      File? image = await fileRepository.getProfileImage(ImageSource.camera);

      verify(imagePicker.pickImage(source: anyNamed("source")));
      expect(image, isNull);
    });

    test("Should crop the image when an image is picked", () async {
      when(imagePicker.pickImage(source: anyNamed("source")))
          .thenAnswer((_) => Future.value(XFile(sampleFile.path)));

      when(imageCropper.cropImage(
        sourcePath: anyNamed("sourcePath"),
        compressFormat: anyNamed("compressFormat"),
        uiSettings: anyNamed("uiSettings"),
        maxHeight: 512,
        maxWidth: 512,
        aspectRatio: anyNamed("aspectRatio"),
        cropStyle: CropStyle.circle,
      )).thenAnswer((_) => Future.value(CroppedFile(sampleFile.path)));

      File? image = await fileRepository.getProfileImage(ImageSource.camera);

      verify(imagePicker.pickImage(source: anyNamed("source")));
      verify(imageCropper.cropImage(
        sourcePath: anyNamed("sourcePath"),
        compressFormat: anyNamed("compressFormat"),
        uiSettings: anyNamed("uiSettings"),
        maxHeight: 512,
        maxWidth: 512,
        aspectRatio: anyNamed("aspectRatio"),
        cropStyle: CropStyle.circle,
      ));

      expect(image, isNotNull);
      expect(image!.path, sampleFile.path);
    });

    test("Should return null when failed to crop the image", () async {
      when(imagePicker.pickImage(source: anyNamed("source")))
          .thenAnswer((_) => Future.value(XFile(sampleFile.path)));

      when(imageCropper.cropImage(
        sourcePath: anyNamed("sourcePath"),
        compressFormat: anyNamed("compressFormat"),
        uiSettings: anyNamed("uiSettings"),
        maxHeight: 512,
        maxWidth: 512,
        aspectRatio: anyNamed("aspectRatio"),
        cropStyle: CropStyle.circle,
      )).thenAnswer((_) => Future.value(null));

      File? image = await fileRepository.getProfileImage(ImageSource.camera);

      verify(imagePicker.pickImage(source: anyNamed("source")));
      verify(imageCropper.cropImage(
        sourcePath: anyNamed("sourcePath"),
        compressFormat: anyNamed("compressFormat"),
        uiSettings: anyNamed("uiSettings"),
        maxHeight: 512,
        maxWidth: 512,
        aspectRatio: anyNamed("aspectRatio"),
        cropStyle: CropStyle.circle,
      ));

      expect(image, isNull);
    });

    test("Should throw [FileFailure] when error occurs", () async {
      when(imagePicker.pickImage(source: anyNamed("source")))
          .thenThrow(Exception());

      expect(
        () async => fileRepository.getProfileImage(ImageSource.camera),
        throwsA(isA<FileFailure>()),
      );
    });
  });
}
