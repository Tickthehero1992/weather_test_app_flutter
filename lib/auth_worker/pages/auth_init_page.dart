import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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

@override
void dispose() {
  _login.dispose();
  _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
                  onPressed: () {},
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

                 }
               )
              ),
            ),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "Register Account",
                      recognizer: TapGestureRecognizer()..onTap = (){

                      }
                  )
              ),
            ),


          ],
        )
      )
    );

  }
}