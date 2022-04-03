import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/tvShow/tvShowList.dart';
import 'package:spark_tv_shows/services/reminders/reminderService.dart';
import '../services/channels/channelServices.dart';
import '../services/user/userServices.dart';

class AddReminder extends StatefulWidget {

DocumentSnapshot docid;
AddReminder({Key? key, required this.docid}) : super(key: key);
  
  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {

    String userId = "";
    String type ="";
    List reminderList =[];
    List showIds = [];

    CollectionReference reminders = FirebaseFirestore.instance.collection('reminders');
    CollectionReference shows = FirebaseFirestore.instance.collection('shows');

    TextEditingController tvShowName  = TextEditingController();
    TextEditingController showTime  = TextEditingController();

    late Text dateTime;
    dynamic channelTest;

    bool isReminderExist = false;
    dynamic existReminderId;



    

@override
void initState(){

  print("isReminderExist before");
 print(isReminderExist);

  tvShowName  = TextEditingController(text: widget.docid.get('tvShowName'));
  showTime = TextEditingController(text: widget.docid.get('showDate').toString());

  dateTime = Text(DateTime.parse( widget.docid.get('showDate').toDate().toString()).toString());
  // print(dateTime);
  super.initState();
  fetchChannelId();
  fetchUserData();
  fetchShowId();
}

fetchShowId() async {

  QuerySnapshot querySnapshot = await reminders.get();

  final allData = querySnapshot.docs;

  allData.forEach((element) => {
    showIds.add(element["showId"])
    // print(element["showId"])
  });
}

  fetchUserData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userId = getUser!.uid;
    LinkedHashMap<String, dynamic> user = await UserServices().getLoggedInUser(userId);
    // print("user type");
    // print(user['image']);
    // _typeController.value = TextEditingValue(text: user["type"]);
    setState(() {
      type = user["type"];

    });
    setState(() {
      reminderList = user["reminders"];
    });

    // print("reminderList.length");
    // print(reminderList.length);

    reminderList.forEach((element) {
      reminders.get().then((value) => {
            if (value != null)
              {
                value.docs.forEach((e) {
                  if (element == e.id && e.get("showId") == widget.docid.id) {
                    setState(() {
                      isReminderExist = true;
                      existReminderId = e.id;
                      print("existReminderId");                
                      print(existReminderId);

                    });
                  }
                })
              }
          });
    });

  }

fetchChannelId() async {
  dynamic channel = await reminderService().getChannelById(widget.docid.get('channel'));
  // print(channel["description"]);
  
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
                onPressed: () async {  
                  isReminderExist ? 
             
                    // print("remove from array method");
                     await FirebaseFirestore.instance.collection("user").doc(userId).update({"reminders":FieldValue.arrayRemove([existReminderId])}).then((value) => reminderList.remove(existReminderId))
                     .then((value) => {
                       Navigator.pop(context)
                     })
                  
                  :                
                  reminders.add({
                    'tvShowName': tvShowName.text,
                    'reminderDate': DateTime.parse(
                            widget.docid.get('showDate').toDate().toString())
                        .toString(),
                      'showId': widget.docid.id,
                      'userId' : userId  
                  }).then((value) {
                      FirebaseFirestore.instance.collection("user").doc(userId).update({"reminders": FieldValue.arrayUnion([value.id])});
                  });
                  // .whenComplete(() {
                  //   Navigator.pushReplacement(context,
                  //       MaterialPageRoute(builder: (_) => TvShowList(channelDoc);
                  // })
                //   .whenComplete(() {
                //     ()async{
                //       reminderList.contains(snapshot.data!.docs[index].id) ? 
                //       (await FirebaseFirestore.instance.collection("user").doc(userId).update({"reminders":FieldValue.arrayRemove([snapshot.data!.docs[index].id])}).then((value) => reminderList.remove(snapshot.data!.docs[index].id)))
                //       :(await FirebaseFirestore.instance.collection("user").doc(userId).update({"reminders": FieldValue.arrayUnion([snapshot.data!.docs[index].id])}).then((value) =>  reminderList.add(snapshot.data!.docs[index].id)));
                //   })
                },
            child: isReminderExist ? const Text('Remove Reminder') : const Text('Add Reminder'),
          )
        ],
      ),
    ),
  ),
    );
  }
}