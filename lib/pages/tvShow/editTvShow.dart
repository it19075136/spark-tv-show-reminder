import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/tvShow/tvShowList.dart';

class EditTvShow extends StatefulWidget {
  DocumentSnapshot docid;
  EditTvShow({Key? key, required this.docid}) : super(key: key);

  @override
  State<EditTvShow> createState() => _EditTvShoState();
}

class _EditTvShoState extends State<EditTvShow> {
  TextEditingController tvShowName = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    tvShowName = TextEditingController(text: widget.docid.get('tvShowName'));
    description = TextEditingController(text: widget.docid.get('description'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        MaterialButton(
          onPressed: () {
            widget.docid.reference.update({
              'tvShowName': tvShowName.text,
              'description': description.text,
              // 'time': time.text,
              // 'date': date.text,
              // 'channel': channel.text,
            }).whenComplete(() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => TvShowList()));
            });
          },
          child: const Text("Save"),
        ),
        MaterialButton(
          onPressed: () {
            widget.docid.reference.delete().whenComplete(() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => TvShowList()));
            });
          },
          child: const Text("delete"),
        )
      ]),
      body: Container(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: TextField(
              controller: tvShowName,
              decoration: const InputDecoration(
                hintText: 'TV Show Name',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: description,
                expands: true,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
