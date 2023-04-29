/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Apr 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'assistant_command_bloc.dart';

abstract class AssistantCommandEvent extends Equatable {
  const AssistantCommandEvent();

  @override
  List<Object> get props => [];
}

class AssistantCommandEventAdded extends AssistantCommandEvent {
  final AssistantCommandType data;
  const AssistantCommandEventAdded(this.data);

  @override
  List<Object> get props => [data];
}

class AssistantCommandEventRemoved extends AssistantCommandEvent {
  const AssistantCommandEventRemoved();
}

class AssistantCommandFetched extends AssistantCommandEvent {
  const AssistantCommandFetched();
}
