/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/core.dart';
import '../../injection.dart';

abstract class FileRepository {
  /// Get profile image
  ///
  /// `Exception`
  ///
  /// A [FileFailure] maybe thrown when a failure occurs.
  Future<File?> getProfileImage(ImageSource source);
}

class FileRepositoryImpl implements FileRepository {
  final ImageCropper _imageCropper = sl<ImageCropper>();
  final ImagePicker _imagePicker = sl<ImagePicker>();

  @override
  Future<File?> getProfileImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        final image = await _imageCropper.cropImage(
          sourcePath: pickedFile.path,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
              hideBottomControls: true,
              statusBarColor: Colors.black,
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              backgroundColor: Colors.black,
            ),
          ],
          maxHeight: 512,
          maxWidth: 512,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          cropStyle: CropStyle.circle,
        );

        final path = image?.path;

        if (path != null) {
          return File(path);
        }
      }
      return null;
    } on Exception catch (e) {
      throw FileFailure.fromException(e);
    } catch (e) {
      throw const FileFailure();
    }
  }
}
