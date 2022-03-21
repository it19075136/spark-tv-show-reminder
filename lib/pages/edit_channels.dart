import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/channels.dart';

class EditChannel extends StatefulWidget {
  DocumentSnapshot docid;
  EditChannel({required this.docid});

  @override
  State<EditChannel> createState() => _EditChannelState();
}

class _EditChannelState extends State<EditChannel> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    name = TextEditingController(text: widget.docid.get("name"));
    description = TextEditingController(text:widget.docid.get("description") );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Edit Channel"),
        ),
        actions: [
          MaterialButton(onPressed: (){
            widget.docid.reference.update({
              "name":name.text,
              "description":description.text
            }).whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Channels())));
          },
          child: Text("Edit"),)
        
        ],
      ),
      body:Container(
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
              controller:description ,
              decoration: InputDecoration(
                hintText: "description"
              ),
            )
          
          ],
        ),
      ) ,
    );
  }
}
