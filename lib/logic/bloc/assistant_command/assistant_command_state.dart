/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Apr 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'assistant_command_bloc.dart';

abstract class AssistantCommandState extends Equatable {
  const AssistantCommandState();

  @override
  List<Object> get props => [];
}

class AssistantCommandInitial extends AssistantCommandState {}

class AssistantCommandCallVolunteerLoaded extends AssistantCommandState {
  final User data;
  const AssistantCommandCallVolunteerLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class AssistantCommandEmpty extends AssistantCommandState {
  const AssistantCommandEmpty();
}
