import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

part 'auth_event.dart';
part 'auth_state.dart';

String urlName = "127.0.0.1:8080";

class AuthBloc extends Bloc<AuthEvent, AuthState>
{
  AuthBloc(): super(AuthInitState()){
    on<AuthEnterEvent>(onAuthEnterEvent);

    }

  FutureOr<void> onAuthEnterEvent(AuthEnterEvent event, Emitter<AuthState> emit)
  async {
        var url = Uri.https(urlName, '/login');
        var response = await http.post(url, body: {'login':'hui', 'password':'1234'});
        print('${response.statusCode}');
  }
}
