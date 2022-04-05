import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spark_tv_shows/pages/tvShow/tvShowList.dart';
import '../../constants.dart';

class EditTvShow extends StatefulWidget {
  DocumentSnapshot docid;
  EditTvShow({Key? key, required this.docid}) : super(key: key);

  @override
  State<EditTvShow> createState() => _EditTvShoState();
}

class _EditTvShoState extends State<EditTvShow> {
  final firstDate = DateTime(2021, 1);
  final lastDate = DateTime(2022, 12);
  TextEditingController _tvShowName = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _channelID = TextEditingController();
  //Set Date and Time to now Date and Time
  DateTime _showDate = DateTime.now();
  TimeOfDay _showTime = TimeOfDay.now();

  @override
  void initState() {
    //set all fields values according to the channel ID
    _tvShowName = TextEditingController(text: widget.docid.get('tvShowName'));
    _description = TextEditingController(text: widget.docid.get('description'));
    _channelID = TextEditingController(text: widget.docid.get('channel'));
    Timestamp showTimestamp = widget.docid.get('showDate');
    _showDate = DateTime.parse(showTimestamp.toDate().toString());
    _showTime = TimeOfDay.fromDateTime(
        DateTime.parse(showTimestamp.toDate().toString()));
    super.initState();
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
        actions: [
          MaterialButton(
            onPressed: () {
              widget.docid.reference.update({
                'tvShowName': _tvShowName.text,
                'description': _description.text,
                'showDate': setDateTime(_showDate, _showTime),
              }).whenComplete(() {
                Fluttertoast.showToast(
                    msg: "Successfully Updated!",
                    backgroundColor: Colors.green,
                    textColor: kPrimaryLightColor,
                    gravity: ToastGravity.BOTTOM_RIGHT,
                    webBgColor: "#25eb1e",
                    timeInSecForIosWeb: 2,
                    toastLength: Toast.LENGTH_LONG);
              });
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              _confirmDelete();
            },
            child: const Text("delete"),
          )
        ],
        title: const Text("Edit Tv Show"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextField(
                          controller: _tvShowName,
                          decoration: const InputDecoration(
                              hintText: 'TV Show Name',
                              label: Text('Tv Show Name')),
                        ),
                      ),
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
                      //Show Date
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
                        label: const Text('Show Date'),
                        onPressed: () => _openDatePicker(context),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      //Show Time
                      const Text('Pick Show Time',
                          style: TextStyle(fontSize: 20)),
                      Text(
                        '${_showTime.hour}:${_showTime.minute}',
                        style: const TextStyle(fontSize: 25),
                      ),
                      ElevatedButton(
                          onPressed: () => _setTimeForShow(context),
                          child: const Text('Show Date')),
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

  //Delete Confirm Dialog Box
  Future<void> _confirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('You will not be able to revert this!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes, delete it!'),
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () {
                widget.docid.reference.delete().whenComplete(() {
                  Fluttertoast.showToast(
                      msg: "Successfully Deleted!",
                      backgroundColor: Colors.green,
                      textColor: kPrimaryLightColor,
                      gravity: ToastGravity.BOTTOM_RIGHT,
                      webBgColor: "#25eb1e",
                      timeInSecForIosWeb: 2,
                      toastLength: Toast.LENGTH_LONG);
                });
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
