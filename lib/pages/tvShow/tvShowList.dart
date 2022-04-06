import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spark_tv_shows/pages/tvShow/addTvShow.dart';
import 'package:spark_tv_shows/pages/tvShow/editTvShow.dart';
import 'package:spark_tv_shows/pages/tvShow/notificationHelper.dart';
import 'package:spark_tv_shows/services/user/userServices.dart';
import '../../main.dart';
import '../../reminders/add_reminder.dart';

class TvShowList extends StatefulWidget {
  DocumentSnapshot channelDoc;
  TvShowList({Key? key, required this.channelDoc}) : super(key: key);

  @override
  State<TvShowList> createState() => _TvShowListState();
}

class _TvShowListState extends State<TvShowList> {
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('user');

  CollectionReference reminders = FirebaseFirestore.instance.collection('reminders');

  NotificationHelper nhelp = new NotificationHelper();
  
  List reminderList = [];
  List reminderDateList = [];

  bool _subscribed = false;

  List showList = [];
  String userId = "";
  String type = "";
  TextEditingController _userType = TextEditingController();
  TextEditingController _userName = TextEditingController();

  Stream<QuerySnapshot> _userStream = new Stream.empty();

  @override
  void initState() {
    _userStream = FirebaseFirestore.instance
        .collection('shows')
        .where('channel', isEqualTo: widget.channelDoc.id)
        .snapshots();
    super.initState();
    getUserData();
    // scheduleReminder();

  }

   scheduleReminder( DateTime date, int id, String? showName) async {
     print("reminder id and the date is");
     print(date);
      print(id);
     
    var sceduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notify',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

        print("date.isBefore(DateTime.now())");
        print(date.isBefore(DateTime.now()));

    if (!date.isBefore(DateTime.now())) {
      await flutterLocalNotificationsPlugin.schedule(id, showName,
          "This is reminder for your show!", date, platformChannelSpecifics);
    }
 
  }

  
  getUserData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userId = getUser!.uid;
    LinkedHashMap<String, dynamic> user =
        await UserServices().getLoggedInUser(userId);
    setState(() {
      type = user["type"];
    });
    setState(() {
      showList = user["shows"];
    });
    setState(() {
      reminderList = user["reminders"];
    });

       reminderList.forEach((element) {
      reminders.get().then((value) => {
            if (value != null)
              {
                value.docs.asMap().forEach((index,e) {
                  if (element == e.id) {
                    reminderDateList.add(e["reminderDate"]);
                    scheduleReminder(DateTime.parse(e["reminderDate"]),index,e["tvShowName"]);
                    // print(e.get("reminderDate"));
                   
                  }
                })
              }
          });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: type == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            AddTvShow(channelId: widget.channelDoc.id)));
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : null,
      appBar: AppBar(
        title: const Text('Tv Shows'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _userStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something is wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  Timestamp showDate =
                      snapshot.data!.docChanges[index].doc['showDate'];
                  return GestureDetector(
                    onTap: () {
                      if (type == "admin") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditTvShow(
                                      docid: snapshot.data!.docs[index],
                                    )));
                      } else {
                        null;
                      }
                    },
                    child: Column(
                      children: [
                        Card(
                          child: ListTile(
                              title: Text(snapshot
                                      .data!.docChanges[index].doc['tvShowName'] +
                                  " - " +
                                  DateTime.parse(showDate.toDate().toString())
                                      .toString()
                                      .split(' ')[0]),
                              subtitle: Text(snapshot
                                  .data!.docChanges[index].doc['description']),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data!.docChanges[index].doc['image'])),
                              trailing: Wrap(
                                spacing: 12,
                                children: <Widget>[
                                IconButton(
                                icon: Icon(Icons.notifications,
                                    color: showList.contains(
                                            snapshot.data!.docs[index].id)
                                        ? Colors.red
                                        : Colors.grey),
                                onPressed: () async {
                                  if (showList
                                      .contains(snapshot.data!.docs[index].id)) {
                                    (await FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(userId)
                                        .update({
                                      "shows": FieldValue.arrayRemove(
                                          [snapshot.data!.docs[index].id])
                                    }).then((value) => showList.remove(
                                            snapshot.data!.docs[index].id)));
                                    setState(() {
                                      showList
                                          .remove(snapshot.data!.docs[index].id);
                                    });
                                  } else {
                                    setState(() {
                                      showList.add(snapshot.data!.docs[index].id);
                                    });
                                    await FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(userId)
                                        .update({
                                      "shows": FieldValue.arrayUnion(
                                          [snapshot.data!.docs[index].id])
                                    }).then((value) => showList
                                            .add(snapshot.data!.docs[index].id));
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add_alarm
                                // ,
                                    // color: _subscribed == true
                                    //     ? Colors.red
                                    //     : Colors.grey
                                        ),
                                onPressed: () {
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> AddReminder(
                                   docid: snapshot.data!.docs[index]
                                 )));
      
                                },
                              ),
                                ],
                              ) 
                              
                              ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
