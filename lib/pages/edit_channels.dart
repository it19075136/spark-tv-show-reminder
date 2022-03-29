import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark_tv_shows/pages/channels.dart';

class EditChannel extends StatefulWidget {
  DocumentSnapshot docid;
  EditChannel({required this.docid});

  @override
  State<EditChannel> createState() => _EditChannelState();
}

class _EditChannelState extends State<EditChannel> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  File? image;
  String? url;
  bool imageSet = false;
  @override
  void initState() {
    // TODO: implement initState
    name = TextEditingController(text: widget.docid.get("name"));
    description = TextEditingController(text:widget.docid.get("description") );
    url = widget.docid.get("image");
    print("doc id");
    print(widget.docid);
    // image = File("$url");
  }


  Future pickImage() async{
    final image= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this.image =imageTemporary;
      this.imageSet = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Edit Channel"),
        ),
      ),
      body:Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                child: Image.asset("assets/images/channel.jpg"),
              )
          ),
          Positioned(
            top: 200,
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
                            child: image == null && url==null  ? CircleAvatar(
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

                              child: image == null ? Image(image: NetworkImage(url!),width: 160,height: 150,fit: BoxFit.cover,) :Image.file(image!,width: 160,height: 150,fit: BoxFit.cover,),
                            ) ,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(onPressed: ()async{
                              if(imageSet == true){
                                if(url != null){
                                  // print("delete image 1");
                                  final storageRef = await FirebaseStorage.instance.refFromURL(url!);
                                  // print("delete image 2");
                                  await  storageRef.delete();
                                  // print("delete image");
                                }


                                final imageref = FirebaseStorage.instance.ref().child("channelsImages").child(name.text+'.jpg');
                                print("imageref1");
                                await imageref.putFile(image!);
                                print("imageref2");

                                url = await imageref.getDownloadURL();
                                print("imageref");
                              }
                              widget.docid.reference.update({
                                "name":name.text,
                                "description":description.text,
                                "image": url,
                              }).whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Channels())));
                            },
                                child: Row(
                                  children: [
                                    Text("Edit"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.edit)
                                  ],
                                  mainAxisSize: MainAxisSize.min,
                                ),
                                color: Colors.blue
                            ),
                            Container(
                                child: MaterialButton(onPressed: ()async {
                                  final storageRef = await FirebaseStorage.instance.refFromURL(url!);
                                  await  storageRef.delete();
                                  widget.docid.reference.delete().whenComplete(() {
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (_) => const Channels()));
                                  });
                                },
                                  child: Row(
                                    children: [
                                      Text("Delete"),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.delete_outline)
                                    ],
                                    mainAxisSize: MainAxisSize.min,
                                  ),
                                    color: Colors.red
                                )
                              // decoration: BoxDecoration(color: Colors.blue),
                              // child: IconButton(
                              //   onPressed: (){
                              //     widget.docid.reference.delete().whenComplete(() {
                              //       Navigator.pushReplacement(
                              //           context, MaterialPageRoute(builder: (_) => const Channels()));
                              //     });
                              //   },
                              //   icon: Icon(Icons.delete),
                              //   color: Colors.red,
                              //
                              // ),
                            )
                          ],
                        )

                        // MaterialButton(onPressed: (){
                        //   widget.docid.reference.update({
                        //     "name":name.text,
                        //     "description":description.text
                        //   }).whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Channels())));
                        // },
                        //
                        //     child: Text("Delete"),
                        //     color: Colors.red
                        // ),



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
