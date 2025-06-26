import 'dart:async';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble_worker/ble_worker_page.dart';
import '../auth_bloc.dart';
import 'auth_forgot_pass.dart';
import 'auth_register_page.dart';

class LoginEnterPage extends StatefulWidget
{
  const LoginEnterPage({super.key});

  @override
  _LoginEnterPageState createState()=>_LoginEnterPageState();
}

class _LoginEnterPageState extends State<LoginEnterPage>
{
final _login = TextEditingController();
final _password = TextEditingController();

int numTapBreak = 0;
late Timer timer;
Object pervState = AuthInitState;
List <Object> statesToGoInit = [AuthRegisterErrorState,AuthRegisterSuccessState,AuthForgotErrorState, AuthForgotSuccessState, AuthFailedState];

@override
void dispose() {
  _login.dispose();
  _password.dispose();
  }

void clearTap()
{
  numTapBreak = 0;
}

  @override
  Widget build(BuildContext context) {
    BackButtonInterceptor.add(myInterceptor);
    timer = Timer.periodic(const Duration(seconds: 5), (_) => clearTap());
    return Scaffold(
      body: Center(
        child: BlocConsumer(
          bloc: authBloc,
          listener: (context, state){
            if(state is AuthSuccessState)
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=> BleWorkerPage()));
              }
            if(state is AuthForgotState)
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=> AuthForgotPage()));
              }
            if(state is AuthRegisterState)
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=> RegisterPage()));
              }
            if(state is AuthInitState)
            {
              Navigator.of(context).push(MaterialPageRoute(builder: (c)=> LoginEnterPage()));
            }
            if((state is AuthRegisterErrorState) || (state is AuthRegisterSuccessState) || (state is AuthForgotErrorState)
            || (state is AuthForgotSuccessState) || (state is AuthFailedState))
              {
                Navigator.of(context).pop();
              }
            pervState = state!;
          },
          builder: (context, state){
            switch (state.runtimeType){
              case AuthInitState:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Connecting App"),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _login,
                      decoration: InputDecoration(
                        labelText: "Enter Login",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height:16),
                    TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: "Enter Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          if(_login.text.isEmpty)
                            {
                              authBloc.add(AuthFailedEvent(error: "Enter login"));
                            }
                          else if (_password.text.isEmpty)
                            {
                              authBloc.add(AuthFailedEvent(error: "Enter password"));
                            }
                          else
                            {
                              authBloc.add(AuthEnterEvent(login: _login.text, password: _password.text));
                            }
                        },
                        child: Text(
                            "Login"
                        ),
                      ),
                    ),
                    SizedBox(height: 26),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: "Forgot password?",
                              recognizer: TapGestureRecognizer()..onTap = (){
                                authBloc.add(AuthForgotEvent());
                              }
                          )
                      ),
                    ),
                    SizedBox(height: 26),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: "Register Account",
                              recognizer: TapGestureRecognizer()..onTap = (){
                                authBloc.add(AuthRegisterEvent());
                              }
                          )
                      ),
                    ),
                  ],
                );
              case AuthFailedState:
                String err = (state as AuthFailedState).error;
                return Scaffold(
                  body: AlertDialog(
                    title: Text('Incorrect data User'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('$err'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          authBloc.add(AuthInitEvent());
                        },
                      ),
                    ],
                  ),
                );
              case AuthBlocState:
                return Scaffold(
                  body: AlertDialog(
                    title: const Text('Blocked User'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('This user is blocked'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          authBloc.add(AuthInitEvent());
                        },
                      ),
                    ],
                  ),
                );
              case AuthRegisterSuccessState:
                return Scaffold(
                  body: AlertDialog(
                    title: const Text('User Create!'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[

                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          authBloc.add(AuthInitEvent());
                        },
                      ),
                    ],
                  ),
                );
              case AuthRegisterErrorState:
                String err = (state as AuthRegisterErrorState).error;

                return Scaffold(
                  body: AlertDialog(
                    title:  Text('Error create user'),
                    content:  SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("$err"),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          authBloc.add(AuthRegisterEvent());
                        },
                      ),
                    ],
                  ),
                );
              case AuthRegisterSuccessState:
                return Scaffold(
                  body: AlertDialog(
                    title:  Text('Register success'),
                    content:  SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("Check your email to confirm"),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          authBloc.add(AuthInitEvent());
                        },
                      ),
                    ],
                  ),
                );
              case AuthForgotErrorState:
                String err = (state as AuthForgotErrorState).error;

                return Scaffold(
                  body: AlertDialog(
                    title:  Text('Error send email'),
                    content:  SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("$err"),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          authBloc.add(AuthForgotEvent());
                        },
                      ),
                    ],
                  ),
                );
              case AuthForgotSuccessState:
                return Scaffold(
                  body: AlertDialog(
                    title:  Text('Check email'),
                    content:  SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("Login pass send to email"),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          authBloc.add(AuthInitEvent());
                        },
                      ),
                    ],
                  ),
                );
              default:
                return Container();
            }
          }
        )

      )
    );
  }
bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  // Your logic here
  if (stopDefaultButtonEvent) {
    // Handle the back button event
  }
  numTapBreak++;
  authBloc.add(AuthInitEvent());

  if((numTapBreak >= 2))
  {
    // if(Platform.isAndroid)
    //   {
    //     exit(0);
    //   }
  }
  return true; // Prevent default behavior
}
  }

