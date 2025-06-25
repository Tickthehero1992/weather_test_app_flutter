import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class AuthForgotPage extends StatefulWidget
{
  const AuthForgotPage({super.key});
  @override
  _AuthForgotPageState createState() => _AuthForgotPageState();

}

class _AuthForgotPageState extends State<AuthForgotPage>
{
  final _email = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: "Enter email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    if(EmailValidator.validate(_email.text) == true)
                      {
                        print('Good email');//add event
                      }
                    else
                      {
                        print('Bad email');
                        //add error event
                      }
                  },
                  child: Text(
                      "Get Pass Drop"
                  ),
                ),
              ),
            ],
          )
      )
    );
  }

}