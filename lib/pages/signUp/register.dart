import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _showPass = false;

  @override
  void initState() {
    _showPass = false;
    super.initState();
  }

  final FirebaseAuthentication _auth = FirebaseAuthentication();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: kPrimaryLightColor,
        child: Center(
          child: Form(
            key: _key,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
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
                                  decoration: TextDecoration.underline))),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Name is required!';
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
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
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
                                  labelStyle:
                                      const TextStyle(color: kPrimaryColor),
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
                                )),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _phoneController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone is required!';
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
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                      backgroundColor: kPrimaryColor),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                      primary: kPrimaryLightColor,
                                      backgroundColor: kPrimaryColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  void insertUser() async {
    dynamic result = await _auth.insertUser(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _phoneController.text,
        'user');
    if (result == null) {
      Fluttertoast.showToast(
          msg: "Error registering user!",
          backgroundColor: Colors.redAccent,
          textColor: kPrimaryLightColor,
          gravity: ToastGravity.BOTTOM_RIGHT,
          webBgColor: "#d8392b",
          timeInSecForIosWeb: 2,
          toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(
          msg: "Registration Successful!",
          backgroundColor: Colors.greenAccent,
          textColor: kPrimaryLightColor,
          gravity: ToastGravity.BOTTOM_RIGHT,
          webBgColor: "#00cc00",
          timeInSecForIosWeb: 2,
          toastLength: Toast.LENGTH_LONG);
      _nameController.clear();
      _passwordController.clear();
      _emailController.clear();
      Navigator.pop(context);
    }
  }
}
