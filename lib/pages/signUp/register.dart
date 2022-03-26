import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/pages/login/login.dart';
import 'package:spark_tv_shows/services/auth/firebaseAuth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

    final _key = GlobalKey<FormState>();

    final FirebaseAuthentication _auth = FirebaseAuthentication();

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailContoller = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();

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
                  const Text(
                    'Register',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                      child: const Text('Have an account? Sign in'),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const Login(),
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
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                color: kPrimaryColor,
                              )),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _emailContoller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: kPrimaryColor)),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: kPrimaryColor)),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(color: kPrimaryColor)),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: const Text('Sign Up'),
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  insertUser();
                                }
                              },
                              style: TextButton.styleFrom(
                                  primary: kPrimaryLightColor,
                                  backgroundColor: kPrimaryColor
                              ),
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                               },
                              style: TextButton.styleFrom(
                                  primary: kPrimaryLightColor,
                                  backgroundColor: kPrimaryColor
                              ),
                            )
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

  void insertUser() async {
      dynamic result = await _auth.insertUser(_nameController.text, _emailContoller.text, _passwordController.text, _phoneController.text, 'user');
      if(result == null) {
        print("Invalid credentials");
      }
      else {
        print(result.toString());
        _nameController.clear();
        _passwordController.clear();
        _emailContoller.clear();
        Navigator.pop(context);
      }
  }

}


