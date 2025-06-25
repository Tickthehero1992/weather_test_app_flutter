import 'dart:convert';
import 'dart:io';

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
    on<AuthForgotEvent>(onAuthForgotEvent);
    on<AuthRegisterEvent>(onAuthRegisterEvent);
    on<AuthInitEvent>(onAuthInitEvent);
  }

  FutureOr<void> onAuthEnterEvent(AuthEnterEvent event, Emitter<AuthState> emit)
  async {
        var url = Uri.http(urlName, '/login');
        Map data = {
          'login':event.login,
          'password':event.password
        };
        //String bodyOut = json.encode(data);
        try{

          final req = http.Request("POST", url);
          req.body = jsonEncode(data);
          req.headers.addAll({"Content-Type":"application/json"});
          var response = await req.send();

          //var response = await http.post(url, headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: data);
          switch(response.statusCode){
            case 200:
              emit(AuthSuccessState());
              break;
            case 401:
              emit(AuthFailedState());
              break;
            case 403:
              emit(AuthBlocState());
              break;
          }
        }
        catch(e){
          print(e);
        }
        finally{

        }
  }

  FutureOr<void> onAuthForgotEvent(AuthEvent event, Emitter<AuthState> emit)
  async {
    emit(AuthForgotState());
  }

  FutureOr<void> onAuthRegisterEvent(AuthEvent event, Emitter<AuthState> emit)
  async{
    emit(AuthRegisterState());
  }


  FutureOr<void> onAuthInitEvent(AuthEvent event, Emitter<AuthState> emit)
  async{
    emit(AuthInitState());
  }


}
