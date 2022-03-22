import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/services/auth/firebaseAuth.dart';
import 'package:spark_tv_shows/pages/signUp/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();

  final FirebaseAuthentication _auth = FirebaseAuthentication();

  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kPrimaryLightColor,
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                TextButton(
                    child: Text('Not registerd? Sign up'),
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => Register(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                        primary: kPrimaryColor,
                        textStyle: const TextStyle(
                            fontStyle: FontStyle.italic,
                            decoration:   TextDecoration.underline
                        )
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _emailContoller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: kPrimaryColor)),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: kPrimaryColor)),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: Text('Login'),
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                login();
                              }
                            },
                            style: TextButton.styleFrom(
                                primary: kPrimaryLightColor,
                                backgroundColor: kPrimaryColor
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    dynamic result = await _auth.login(_emailContoller.text, _passwordController.text);
    if(result == null){
      print("Failed to login");
    }
    else {
      print(result.toString());
      _emailContoller.clear();
      _passwordController.clear();
      Navigator.pushNamed(context, '/welcome');
    }
  }
}
