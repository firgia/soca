/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class FileProfileImagePicked extends FileEvent {
  final ImageSource source;
  const FileProfileImagePicked(this.source);

  @override
  List<Object> get props => [source];
}
