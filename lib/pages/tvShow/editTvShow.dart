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
  final firstDate = DateTime(2021, 1);
  final lastDate = DateTime(2022, 12);
  TextEditingController _tvShowName = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _channelID = TextEditingController();
  DateTime _showDate = DateTime.now();
  TimeOfDay _showTime = TimeOfDay.now();

  @override
  void initState() {
    _tvShowName = TextEditingController(text: widget.docid.get('tvShowName'));
    _description = TextEditingController(text: widget.docid.get('description'));
    _channelID =  TextEditingController(text: widget.docid.get('channelID'));
    _showDate    = widget.docid.get('showDate');
    super.initState();
  }

  DateTime setDateTime(DateTime showDate, TimeOfDay showTime) {
    return DateTime(showDate.year, showDate.month, showDate.day, showTime.hour,
        showTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        MaterialButton(
          onPressed: () {
            widget.docid.reference.update({
              'tvShowName': _tvShowName.text,
              'description': _description.text,
              'showDate': setDateTime(_showDate, _showTime),
              // 'time': time.text,
              // 'date': date.text,
              // 'channel': channel.text,
            }).whenComplete(() {
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (_) => TvShowList(
              //       channelID: widget.docid.get('channelID')
              //     )));
            });
          },
          child: const Text("Save"),
        ),
        MaterialButton(
          onPressed: () {
            widget.docid.reference.delete().whenComplete(() {
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (_) => TvShowList(
              //       channelID: widget.docid.get('channelID')
              //     )));
            });
          },
          child: const Text("delete"),
        )
      ]),
      body: Container(
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
                      icon: Icon(Icons.lock_clock),
                      label: Text('Show Date'),
                      onPressed: () => _openDatePicker(context),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
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
    );
  }

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
