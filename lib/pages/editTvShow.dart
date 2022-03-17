import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/main.dart';
import 'package:spark_tv_shows/pages/tv_show.dart';

class EditTvShow extends StatefulWidget {
  DocumentSnapshot docid;
  EditTvShow({required this.docid});
  @override
  State<EditTvShow> createState() => _EditTvShowState();
}

class _EditTvShowState extends State<EditTvShow> {
  TextEditingController tvShowName  = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController time        = TextEditingController();
  TextEditingController date        = TextEditingController();
  TextEditingController channel     = TextEditingController();

@override
void initialState() {
  tvShowName  = TextEditingController(text: widget.docid.get('tvShowName'));
  description = TextEditingController(text: widget.docid.get('description'));
  time        = TextEditingController(text: widget.docid.get('time'));
  date        = TextEditingController(text: widget.docid.get('date'));
  channel     = TextEditingController(text: widget.docid.get('channel'));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
        MaterialButton(
          onPressed: () {
            widget.docid.reference.update({
              'tvShowName': tvShowName.text,
              'description': description.text,
              'time': time.text,
              'date': date.text,
              'channel': channel.text,
            }).whenComplete(() {
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => TvShow()));
            });
        },
        child: Text("Save"),
        ),
        MaterialButton(
          onPressed: (){
            widget.docid.reference.delete().whenComplete(() {
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => TvShow()));
            });
          },
          child: Text("delete"),
          )
      ]),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller:  tvShowName,
                decoration: InputDecoration(
                  hintText: 'TV Show Name',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller:  description,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
              ),
            ),
            )
          ],
        )
      ),
    );
  }
}