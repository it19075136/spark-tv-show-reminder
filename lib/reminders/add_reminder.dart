import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/tvShow/tvShowList.dart';
import 'package:spark_tv_shows/services/reminders/reminderService.dart';

import '../services/channels/channelServices.dart';

class AddReminder extends StatefulWidget {

 DocumentSnapshot docid;
AddReminder({Key? key, required this.docid}) : super(key: key);
  
  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {

    CollectionReference ref = FirebaseFirestore.instance.collection('reminders');


    TextEditingController tvShowName  = TextEditingController();
    TextEditingController showTime  = TextEditingController();

    late Text dateTime;
    dynamic channelTest;
    

@override
void initState(){
  print(widget.docid.id);

  tvShowName  = TextEditingController(text: widget.docid.get('tvShowName'));
  showTime = TextEditingController(text: widget.docid.get('showDate').toString());

  // print(widget.docid.get('channel')); //start from here
  // print(tvShowName.text);
  dateTime = Text(DateTime.parse( widget.docid.get('showDate').toDate().toString()).toString());
  print(dateTime);
  super.initState();
  fetchChannelId();
}

fetchChannelId() async {
  dynamic channel = await reminderService().getChannelById(widget.docid.get('channel'));
  print(channel["description"]);
  
setState(() {
  channelTest = channel;
});

} 

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {},
      //     child: Icon(
      //       Icons.add,
      //     ),
      // ),
    //  resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Reminders'),
      ),
      body: SizedBox(
    height: 250,
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'TV Show Name '+'- '+tvShowName.text,
              style: TextStyle(fontWeight: FontWeight.w500)
              ),
            // const Text(
            //   '1625 Main Street',
            //   style: TextStyle(fontWeight: FontWeight.w500),
            // ),
            subtitle: const Text('This will add a reminder for the TV Show'),
            leading: Icon(
              Icons.restaurant_menu,
              color: Colors.blue[500],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Test Text',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: const Text('This text is also for testing'),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 10)),
                onPressed: () {
                  ref.add({
                    'tvShowName': tvShowName.text,
                    'reminderDate': DateTime.parse(
                            widget.docid.get('showDate').toDate().toString())
                        .toString(),
                      'showId': widget.docid.id  
                  });
                  // .whenComplete(() {
                  //   Navigator.pushReplacement(context,
                  //       MaterialPageRoute(builder: (_) => TvShowList(channelDoc);
                  // });
                },
            child: const Text('Enabe Reminder'),
          )
        ],
      ),
    ),
  ),
    );
  }
}