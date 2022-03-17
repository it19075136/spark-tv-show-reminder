import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/tv_show.dart';

class AddTvShow extends StatelessWidget {
  TextEditingController tvShowName  = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController time        = TextEditingController();
  TextEditingController date        = TextEditingController();
  TextEditingController channel     = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('shows');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        MaterialButton(onPressed: (){
          ref.add({
            'tvShowName': tvShowName.text,
            'description': description.text,
            // 'time': time.text,
            // 'date': date.text,
            // 'channel': channel.text,
          }).whenComplete(() {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TvShow()));
          });
        },
        child: Text(
          "save",
        ),
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