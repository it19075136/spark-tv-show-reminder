import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  bool _showPass = false;

  @override
  void initState() {
    _showPass = false;
    super.initState();
  }

  final FirebaseAuthentication _auth = FirebaseAuthentication();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  'Login',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                TextButton(
                    child: const Text('Not registered? Sign up'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                        primary: kPrimaryColor,
                        textStyle: const TextStyle(
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline))),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required!';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: kPrimaryColor)),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
                        obscureText: !_showPass,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required!';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: kPrimaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(_showPass
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showPass = !_showPass;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            child: const Text('Login'),
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                login();
                              }
                            },
                            style: TextButton.styleFrom(
                                primary: kPrimaryLightColor,
                                backgroundColor: kPrimaryColor),
                          ),
                          TextButton(
                              child: const Text('Forgot password? Reset now'),
                              onPressed: () {
                                openDialogBox(context);
                              },
                              style: TextButton.styleFrom(
                                  primary: kPrimaryColor,
                                  textStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline))),
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

  openDialogBox(BuildContext context) {
    final _dialogKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reset your password'),
            content: Form(
              key: _dialogKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required!';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: kPrimaryColor)),
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Reset Password"),
                onPressed: () async {
                  if (_dialogKey.currentState!.validate()) {
                    dynamic result =
                        await _auth.resetPassword(_emailController.text);
                    if (result == null) {
                      Fluttertoast.showToast(
                          msg: "Action failed, insert a correct email!",
                          backgroundColor: Colors.redAccent,
                          textColor: kPrimaryLightColor,
                          gravity: ToastGravity.BOTTOM_RIGHT,
                          webBgColor: "#d8392b",
                          timeInSecForIosWeb: 2,
                          toastLength: Toast.LENGTH_LONG);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Reset link sent! Check your mail",
                          backgroundColor: Colors.greenAccent,
                          textColor: kPrimaryLightColor,
                          gravity: ToastGravity.BOTTOM_RIGHT,
                          webBgColor: "#00cc00",
                          timeInSecForIosWeb: 2,
                          toastLength: Toast.LENGTH_LONG);
                    }
                    Navigator.pop(context);
                  }
                },
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear))
            ],
          );
        });
  }

  void login() async {
    dynamic result =
        await _auth.login(_emailController.text, _passwordController.text);
    if (result == null) {
      Fluttertoast.showToast(
          msg: "Login failed!",
          backgroundColor: Colors.redAccent,
          textColor: kPrimaryLightColor,
          gravity: ToastGravity.BOTTOM_RIGHT,
          webBgColor: "#d8392b",
          timeInSecForIosWeb: 2,
          toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(
          msg: "Login Successful!",
          backgroundColor: Colors.green,
          textColor: kPrimaryLightColor,
          gravity: ToastGravity.BOTTOM_RIGHT,
          webBgColor: "#00cc00",
          timeInSecForIosWeb: 2,
          toastLength: Toast.LENGTH_LONG);
      _emailController.clear();
      _passwordController.clear();
      Navigator.pushNamed(context, '/welcome');
    }
  }
}
