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
