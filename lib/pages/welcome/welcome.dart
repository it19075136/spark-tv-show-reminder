import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/pages/services/auth/firebaseAuth.dart';
import 'package:spark_tv_shows/pages/services/user/userServices.dart';
import 'package:spark_tv_shows/pages/welcome/components/body.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

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
    dynamic user = await UserServices().getLoggedInUser(userId);
    print(user.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: (){
                openDialogBox(context);
              },
              icon: const Icon(
                  Icons.account_circle
              )
          ),
          IconButton(
              onPressed: () async {
                await _auth.logout().then((value) =>
                  Navigator.of(context).pop(true)
                ).catchError((err) => print(err));
              },
              icon: const Icon(
                Icons.login
              )
          ),
        ],
      ),
      body: Body(),
      backgroundColor: Colors.black,
    );
  }

  openDialogBox(BuildContext context) {
    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: const Text('User Profile'),
          content:  Container(
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(hintText: 'Phone'),
                )
              ],
            ),
          ),
          actions: [
          IconButton(onPressed: () async {
            await UserServices().updateUser(userId, _nameController.text, _phoneController.text);
            Navigator.pop(context);
            }, icon: const Icon(Icons.done)),
          IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.clear))
      ],
      );
    });
  }

}
  
