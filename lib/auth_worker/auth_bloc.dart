import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

part  'auth_event.dart';
part 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState>
{
  AuthBloc(): super(AuthInitState()){
    on<AuthEnterEvent>(onAuthEnterEvent);

    }

  FutureOr<void> onAuthEnterEvent(AuthEnterEvent event, Emitter<AuthState> emit)
  async {

  }
}
