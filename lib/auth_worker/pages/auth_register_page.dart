import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget
{
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage>
{
  final _email = TextEditingController();
  final _login = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Registration new user"),
            SizedBox(height: 5),
            TextField(
              controller: _email ,
              decoration: InputDecoration(
                labelText: "Enter Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _login,
              decoration: InputDecoration(
                labelText: "Enter Login",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
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
                  if(EmailValidator.validate(_email.text) == true)
                  {
                    print('Good email');//add event
                  }
                  else
                  {
                    print('Bad email');//add error event
                  }
                },
                child: Text(
                    "Register"
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}