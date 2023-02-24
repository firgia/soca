/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileRepository _fileRepository = sl<FileRepository>();
  final Logger _logger = Logger("File Bloc");

  FileBloc() : super(const FileEmpty()) {
    on<FileProfileImagePicked>(_onProfileImagePicked);
  }

  Future<void> _onProfileImagePicked(
    FileProfileImagePicked event,
    Emitter<FileState> emit,
  ) async {
    _logger.info("Pick profile image...");
    emit(const FileLoading());

    try {
      File? profileImage = await _fileRepository.getProfileImage(event.source);

      if (profileImage == null) {
        _logger.fine("Empty profile image");
        emit(const FileEmpty());
      } else {
        _logger.fine("Successfully to pick profile image");
        emit(FilePicked(profileImage));
      }
    } on FileFailure catch (e) {
      _logger.shout("Error to pick profile image");
      emit(FileError(e));
    } catch (e) {
      _logger.shout("Error to pick profile image");
      emit(const FileError());
    }
  }
}
