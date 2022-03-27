import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/add_channel.dart';
import 'package:spark_tv_shows/pages/edit_channels.dart';
import 'package:spark_tv_shows/pages/tv_show.dart';
import 'package:spark_tv_shows/services/user/userServices.dart';

class Channels extends StatefulWidget {
  const Channels({Key? key}) : super(key: key);

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  String userId = "";
  String type ="";
  // TextEditingController _typeController = TextEditingController();
  final Stream<QuerySnapshot> _chaneelStream = FirebaseFirestore.instance.collection("channels").snapshots();


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  fetchUserData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userId = getUser!.uid;
    LinkedHashMap<String, dynamic> user = await UserServices().getLoggedInUser(userId);
    // _typeController.value = TextEditingValue(text: user["type"]);
    setState(() {
      type = user["type"];

    });
    // _phoneController.value = TextEditingValue(text: user["phone"]);
    ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      floatingActionButton: type == 'admin' ? FloatingActionButton(onPressed: (){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> AddChannel()));
      },
       child: Icon(
         Icons.add
       ),
      ):null,
      appBar: AppBar(
        title: Center(child: Text("Channels"),
        ),
      ),
      body: StreamBuilder(
        stream: _chaneelStream,
        builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text("Something Went Wrong")
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_,index){
            return GestureDetector(
              onTap:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TvShow(
                          // docid: snapshot.data!.docs[index],
                        )));
              } ,

              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(Icons.subscript),
                    // Image.asset("name"),
                    Icon(Icons.subscript),
                    SizedBox(
                      height: 10,
                    ),
                    // Padding(padding: EdgeInsets.only(left: 3,right: 3),
                    // child:
                    // ListTile(
                    //   // shape: RoundedRectangleBorder(
                    //   //   borderRadius: BorderRadius.circular(10),
                    //   //   side: BorderSide(color: Colors.black)
                    //   // ),
                    //
                    //   title: Text(
                    //     snapshot.data!.docChanges[index].doc["name"],
                    //     style: TextStyle(
                    //         fontSize: 20
                    //     ),
                    //   ),
                    //   subtitle: Text(
                    //     snapshot.data!.docChanges[index].doc["description"],
                    //     style: TextStyle(
                    //         fontSize: 20
                    //     ),
                    //   ),
                    //   contentPadding: EdgeInsets.symmetric(
                    //     vertical: 12,
                    //     horizontal: 16
                    //   ),
                    // )
                    //   ),
                    Text(
                        snapshot.data!.docChanges[index].doc["name"],
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    Text(
                      snapshot.data!.docChanges[index].doc["description"],
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    // Text(
                    //   snapshot.data!.docChanges[index].doc["description"],
                    //   style: TextStyle(
                    //       fontSize: 20
                    //   ),
                    // ),
                    // if(){
                    //
                    // }
                    if (type == 'admin') MaterialButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> EditChannel(docid: snapshot.data!.docs[index],)));
                    },child:
                    Text("Edit"),
                        color: Colors.blue
                      // Image.asset("name")
                    ),
                  ],
                ),
              ),
            );
          });
        },

      ),
    );
  }
}
