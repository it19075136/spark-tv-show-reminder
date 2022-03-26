// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark_tv_shows/pages/channels.dart';

class AddChannel extends StatefulWidget {

  AddChannel({Key? key}) : super(key: key);

  @override
  State<AddChannel> createState() => _AddChannelState();
}

class _AddChannelState extends State<AddChannel> {
  TextEditingController name = TextEditingController();

  TextEditingController description  = TextEditingController();

  // const
  CollectionReference ref = FirebaseFirestore.instance.collection("channels");

  final _formKey = GlobalKey<FormState>();

  File? image;

  Future pickImage() async{
   final image= await ImagePicker().pickImage(source: ImageSource.gallery);
  if(image == null) return;
  final imageTemporary = File(image.path);
  setState(() {
    this.image =imageTemporary;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add Channels")),
        // actions: [
        //   MaterialButton(onPressed: (){
        //     ref.add({
        //       "name":name,
        //       "description":description
        //     }).whenComplete(() => {
        //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Channels()))
        //     });
        //   },
        //   child: Text("Save"),),
        // ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 380,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                child: Image.asset("images/channel.jpg"),
              )
          ),
          Positioned(
            top: 0,
            right: 10,
            left: 10,
            child: Container(
              // height: 00,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5
                )
                ]
              ),
              child: Column(
                children: [

                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
                          child: InkWell(
                            onTap: () => pickImage(),
                            child: image == null ?CircleAvatar(
                              radius: 71,
                              // backgroundImage:
                              // backgroundColor: ,
                              // CircleAvatar(
                              //   radius: 63,
                              //   child:MaterialButton(
                              //     onPressed:(){
                              //
                              //     } ,
                              //     child: Icon(Icons.add_a_photo,),
                              //
                              //   ) ,
                              // ),
                            ): ClipOval(

                          child: Image.file(image!,width: 160,height: 150,fit: BoxFit.cover,),
              ) ,
                          ),
                        ),
                        // Positioned(
                        //   top:90,
                        //     left: 150,
                        //     child: MaterialButton(
                        //       onPressed:(){
                        //
                        //       } ,
                        //      child: Icon(Icons.add_a_photo),
                        //     )
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                                labelText: "Channel Name",
                                hintText: "Channel Name",
                              icon: Icon(Icons.connected_tv),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: description,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                                hintText: "Description",
                              labelText: "Description",
                              icon: Icon(Icons.description)

                            ),
                          ),
                        ),
                        MaterialButton(onPressed: (){
                          ref.add({
                            "name":name.text,
                            "description":description.text,
                            // "image":image
                          }).whenComplete(() => {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const Channels()))
                          });
                        },
                          child: Text("Save"),
                        color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

          );
  }
}
