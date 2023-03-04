/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'route_cubit.dart';

abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object> get props => [];
}

class RouteInitial extends RouteState {
  const RouteInitial();
}

class RouteLoading extends RouteState {
  const RouteLoading();
}

class RouteTarget extends RouteState {
  final String name;

  const RouteTarget(this.name);
}

class RouteError extends RouteState {
  final Exception? failure;

  const RouteError([this.failure]);
}
