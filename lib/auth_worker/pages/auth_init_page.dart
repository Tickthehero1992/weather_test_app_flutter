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
final AuthBloc authBloc = AuthBloc();
int numTapBreak = 0;
late Timer timer;
Object pervState = AuthInitState;

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
                          authBloc.add(AuthEnterEvent(login: _login.text, password: _password.text));
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

  if((numTapBreak >= 2) || (pervState is AuthInitState))
  {
    // if(Platform.isAndroid)
    //   {
    //     exit(0);
    //   }
  }
  return true; // Prevent default behavior
}
}