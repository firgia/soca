/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  SignOutBloc() : super(SignOutInitial()) {
    on<SignOutEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
