/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'call_statistic_bloc.dart';

class CallStatisticState extends Equatable {
  final String? selectedYear;
  final UserType? userType;
  final List<String> listOfYear;
  final List<CallDataMounthly> calls;
  final int? totalCall;
  final int? totalDayJoined;

  const CallStatisticState({
    required this.selectedYear,
    required this.userType,
    required this.listOfYear,
    required this.calls,
    required this.totalCall,
    required this.totalDayJoined,
  });

  @override
  List<Object?> get props => [
        selectedYear,
        userType,
        listOfYear,
        calls,
        totalCall,
        totalDayJoined,
      ];

  CallStatisticState copyWith({
    String? selectedYear,
    UserType? userType,
    List<String>? listOfYear,
    List<CallDataMounthly>? calls,
    int? totalCall,
    int? totalDayJoined,
  }) {
    return CallStatisticState(
      calls: calls ?? this.calls,
      listOfYear: listOfYear ?? this.listOfYear,
      selectedYear: selectedYear ?? this.selectedYear,
      totalCall: totalCall ?? this.totalCall,
      totalDayJoined: totalDayJoined ?? this.totalDayJoined,
      userType: userType ?? this.userType,
    );
  }
}

class CallStatisticLoading extends CallStatisticState {
  const CallStatisticLoading({
    required super.selectedYear,
    required super.userType,
    required super.listOfYear,
    required super.calls,
    required super.totalCall,
    required super.totalDayJoined,
  });

  factory CallStatisticLoading.fromState(CallStatisticState state) =>
      CallStatisticLoading(
        calls: state.calls,
        listOfYear: state.listOfYear,
        selectedYear: state.selectedYear,
        totalCall: state.totalCall,
        totalDayJoined: state.totalDayJoined,
        userType: state.userType,
      );
}

class CallStatisticError extends CallStatisticState {
  final UserFailure? userFailure;
  final CallingFailure? callingFailure;

  const CallStatisticError({
    required super.selectedYear,
    required super.userType,
    required super.listOfYear,
    required super.calls,
    required super.totalCall,
    required super.totalDayJoined,
    this.userFailure,
    this.callingFailure,
  });

  factory CallStatisticError.fromState(
    CallStatisticState state, {
    UserFailure? userFailure,
    CallingFailure? callingFailure,
  }) =>
      CallStatisticError(
        calls: state.calls,
        listOfYear: state.listOfYear,
        selectedYear: state.selectedYear,
        totalCall: state.totalCall,
        totalDayJoined: state.totalDayJoined,
        userType: state.userType,
        callingFailure: callingFailure,
        userFailure: userFailure,
      );

  @override
  List<Object?> get props =>
      super.props +
      [
        userFailure,
        callingFailure,
      ];
}
