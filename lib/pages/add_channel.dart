import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/channels.dart';

class AddChannel extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController description  = TextEditingController();
  // const AddChannel({Key? key}) : super(key: key);

  CollectionReference ref = FirebaseFirestore.instance.collection("channels");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add Channels")),
        actions: [
          MaterialButton(onPressed: (){
            ref.add({
              "name":name,
              "description":description
            }).whenComplete(() => {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Channels()))
            });
          },
          child: Text("Save"),),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                hintText: "Channel Name"
              ),

            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: description,
              decoration: InputDecoration(
                hintText: "description"
              ),
            )
          ],
        ),
      ),
    );
  }
}
