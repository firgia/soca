/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockFileRepository fileRepository;

  setUp(() {
    registerLocator();
    fileRepository = getMockFileRepository();
  });

  tearDown(() => unregisterLocator());

  group(".add()", () {
    File file = File("assets/images/raster/avatar.png");

    group("FileProfileImagePicked()", () {
      blocTest<FileBloc, FileState>(
        'Should emits [FileLoading, FilePicked] when file is selected',
        build: () => FileBloc(),
        act: (bloc) =>
            bloc.add(const FileProfileImagePicked(ImageSource.camera)),
        setUp: () {
          when(fileRepository.getProfileImage(ImageSource.camera))
              .thenAnswer((_) => Future.value(file));
        },
        expect: () => <FileState>[
          const FileLoading(),
          FilePicked(file),
        ],
      );

      blocTest<FileBloc, FileState>(
        'Should emits [FileLoading, FileEmpty] when file is not selected',
        build: () => FileBloc(),
        act: (bloc) =>
            bloc.add(const FileProfileImagePicked(ImageSource.camera)),
        setUp: () {
          when(fileRepository.getProfileImage(ImageSource.camera))
              .thenAnswer((_) => Future.value(null));
        },
        expect: () => const <FileState>[
          FileLoading(),
          FileEmpty(),
        ],
      );

      blocTest<FileBloc, FileState>(
        'Should emits [FileLoading, FileError] when error to pick profile image',
        build: () => FileBloc(),
        act: (bloc) =>
            bloc.add(const FileProfileImagePicked(ImageSource.camera)),
        setUp: () {
          when(fileRepository.getProfileImage(ImageSource.camera))
              .thenThrow(Exception());
        },
        expect: () => const <FileState>[
          FileLoading(),
          FileError(),
        ],
      );
    });
  });
}
