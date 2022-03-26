import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/services/auth/firebaseAuth.dart';
import 'package:spark_tv_shows/services/user/userServices.dart';
import 'package:spark_tv_shows/pages/welcome/components/body.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _key = GlobalKey<FormState>();

  String userId = "";
  FirebaseAuthentication _auth = FirebaseAuthentication();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userId = getUser!.uid;
    LinkedHashMap<String, dynamic> user =
        await UserServices().getLoggedInUser(userId);
    _nameController.value = TextEditingValue(text: user["name"]);
    _phoneController.value = TextEditingValue(text: user["phone"]);
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                openDialogBox(context);
              },
              icon: const Icon(Icons.account_circle)),
          IconButton(
              onPressed: () async {
                await _auth
                    .logout()
                    .then((value) => Navigator.of(context).pop(true))
                    .catchError((err) => print(err));
              },
              icon: const Icon(Icons.login)),
        ],
      ),
      body: Body(),
      backgroundColor: Colors.black,
    );
  }

  openDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('User Profile'),
            content: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name cannot be empty';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: kPrimaryColor)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone cannot be empty';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: kPrimaryColor)),
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      await UserServices().updateUser(
                          userId, _nameController.text, _phoneController.text);
                      await fetchUserData();
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.done)),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear))
            ],
          );
        });
  }
}
