import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        // actions: [
        //   MaterialButton(onPressed: (){
        //     widget.docid.reference.update({
        //       "name":name.text,
        //       "description":description.text
        //     }).whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Channels())));
        //   },
        //   child: Text("Edit"),)
        //
        // ],
      ),
      body:Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                child: Image.asset("images/channel.jpg"),
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
                            MaterialButton(onPressed: (){
                              widget.docid.reference.update({
                                "name":name.text,
                                "description":description.text
                              }).whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Channels())));
                            },
                                child: Text("Edit"),
                                color: Colors.blue
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.blue),
                              child: IconButton(
                                onPressed: (){
                                  widget.docid.reference.delete().whenComplete(() {
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (_) => const Channels()));
                                  });
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,

                              ),
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
