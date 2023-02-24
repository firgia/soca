/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  const FileState();

  @override
  List<Object?> get props => [];
}

class FileEmpty extends FileState {
  const FileEmpty();
}

class FilePicked extends FileState {
  final File file;
  const FilePicked(this.file);

  @override
  List<Object?> get props => [file];
}

class FileLoading extends FileState {
  const FileLoading();
}

class FileError extends FileState {
  final FileFailure? failure;
  const FileError([this.failure]);

  @override
  List<Object?> get props => [failure];
}
