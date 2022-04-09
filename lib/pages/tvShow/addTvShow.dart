import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark_tv_shows/pages/channels.dart';

import '../../constants.dart';

class AddTvShow extends StatefulWidget {
  String channelId;

  AddTvShow({Key? key, required this.channelId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _AddTvShowState();
}

class _AddTvShowState extends State<AddTvShow> {
  final firstDate = DateTime(2021, 1);
  final lastDate = DateTime(2022, 12);

  TextEditingController _tvShowName = TextEditingController();
  TextEditingController _description = TextEditingController();
  DateTime _showDate = DateTime.now();
  TimeOfDay _showTime = TimeOfDay.now();

  //Reference to the 'shows' collection
  CollectionReference ref = FirebaseFirestore.instance.collection('shows');

  File? image;
  String? url;

  //Handle Image
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this.image = imageTemporary;
    });
  }

  //Convert date and time into DateTime Format
  DateTime setDateTime(DateTime showDate, TimeOfDay showTime) {
    return DateTime(showDate.year, showDate.month, showDate.day, showTime.hour,
        showTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tv Show'),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (image != null &&
                  _tvShowName.text != "" &&
                  _description.text != "" &&
                  widget.channelId != "") {
                final imageRef = FirebaseStorage.instance
                    .ref()
                    .child("tvshowImages")
                    .child(_tvShowName.text + '.jpg');

                await imageRef.putFile(image!);
                url = await imageRef.getDownloadURL();
                ref.add({
                  'tvShowName': _tvShowName.text,
                  'description': _description.text,
                  'showDate': setDateTime(_showDate, _showTime),
                  'channel': widget.channelId,
                  'image': url
                }).whenComplete(() {
                  Fluttertoast.showToast(
                      msg: "Tv Show Successfully Added!",
                      backgroundColor: Colors.green,
                      textColor: kPrimaryLightColor,
                      gravity: ToastGravity.BOTTOM_RIGHT,
                      webBgColor: "#25eb1e",
                      timeInSecForIosWeb: 2,
                      toastLength: Toast.LENGTH_LONG);
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const Channels()));
              } else {
                Fluttertoast.showToast(
                    msg: "Tv Show Unsuccessful!",
                    backgroundColor: Colors.red,
                    textColor: kPrimaryLightColor,
                    gravity: ToastGravity.BOTTOM_RIGHT,
                    webBgColor: "#d8392b",
                    timeInSecForIosWeb: 2,
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            child: const Text(
              "save",
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 30),
                        child: InkWell(
                          onTap: () => pickImage(),
                          child: image == null
                              ? const CircleAvatar(
                                  radius: 71,
                                )
                              : ClipOval(
                                  child: Image.file(
                                    image!,
                                    width: 160,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: TextField(
                        controller: _tvShowName,
                        decoration: const InputDecoration(
                            hintText: 'TV Show Name',
                            label: Text('Tv Show Name')),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextField(
                          controller: _description,
                          decoration: const InputDecoration(
                              hintText: 'Description',
                              label: Text('Description')),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Pick Show Date',
                          style: TextStyle(fontSize: 20)),
                      Text(
                        '$_showDate'.split(' ')[0],
                        style: const TextStyle(fontSize: 25),
                      ),
                      // const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.lock_clock),
                        label: const Text('Pick Show Date'),
                        onPressed: () => _openDatePicker(context),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const Text('Pick Show Time',
                          style: TextStyle(fontSize: 20)),
                      Text(
                        '${_showTime.hour}:${_showTime.minute}',
                        style: const TextStyle(fontSize: 25),
                      ),
                      ElevatedButton(
                          onPressed: () => _setTimeForShow(context),
                          child: const Text('Pick Show Time')),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//Date Picker
  _openDatePicker(BuildContext context) async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _showDate,
        firstDate: firstDate,
        lastDate: lastDate);

    if (date == null) {
      print("No Date Selected");
    } else {
      print(date);
      setState(() {
        _showDate = date;
      });
    }
  }

//Time Picker
  _setTimeForShow(BuildContext context) async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: _showTime);
    if (time == null) {
      print("No Time Selected");
    } else {
      print(_showTime);
      setState(() {
        _showTime = time;
      });
    }
  }
}
