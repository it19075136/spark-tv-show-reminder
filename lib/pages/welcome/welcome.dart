import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final FirebaseAuthentication _auth = FirebaseAuthentication();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
                    .catchError((err) => {
                          Fluttertoast.showToast(
                              msg: "Logout failed!",
                              backgroundColor: Colors.redAccent,
                              textColor: kPrimaryLightColor,
                              gravity: ToastGravity.BOTTOM_RIGHT,
                              webBgColor: "#d8392b",
                              timeInSecForIosWeb: 2,
                              toastLength: Toast.LENGTH_LONG)
                        });
              },
              icon: const Icon(Icons.login)),
        ],
      ),
      body: const Center(child: Body()),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Text(
                'SPARK TV SHOWS',
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              title: const Text('My Reminders'),
              onTap: () {
                Navigator.pushNamed(context, "/welcome");
              },
            ),
            ListTile(
              title: const Text('Subscribed Tv Shows'),
              onTap: () {
                Navigator.pushNamed(context, "/myShows");
              },
            ),
            ListTile(
              title: const Text('Subscribed Channels'),
              onTap: () {
                Navigator.pushNamed(context, "/myChannels");
              },
            )
          ],
        ),
      ),
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
                        return 'Name is required!';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: kPrimaryColor)),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
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
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      dynamic result = await UserServices().updateUser(
                          userId, _nameController.text, _phoneController.text);
                      if(result == "error"){
                        Fluttertoast.showToast(
                            msg: "Profile update failed!",
                            backgroundColor: Colors.redAccent,
                            textColor: kPrimaryLightColor,
                            gravity: ToastGravity.BOTTOM_RIGHT,
                            webBgColor: "#d8392b",
                            timeInSecForIosWeb: 2,
                            toastLength: Toast.LENGTH_LONG
                        );
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "Update Successful!",
                            backgroundColor: Colors.greenAccent,
                            textColor: kPrimaryLightColor,
                            gravity: ToastGravity.BOTTOM_RIGHT,
                            webBgColor: "#00cc00",
                            timeInSecForIosWeb: 2,
                            toastLength: Toast.LENGTH_LONG
                        );
                        await fetchUserData();
                      }
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
