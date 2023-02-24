/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("FileProfileImagePicked", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        FileProfileImagePicked fileProfileImagePicked =
            const FileProfileImagePicked(ImageSource.camera);

        expect(fileProfileImagePicked.source, ImageSource.camera);
      });
    });
  });
}
