import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/services/reminders/reminderServices.dart';

import '../../services/user/userServices.dart';

class MyRemindersList extends StatefulWidget {
  const MyRemindersList({Key? key}) : super(key: key);

  @override
  _MyRemindersListState createState() => _MyRemindersListState();
}

class _MyRemindersListState extends State<MyRemindersList> {
  List reminders = [];
  List reminderDataList = [];

  @override
  void initState() {
    super.initState();
    fetchReminderData();
  }

  fetchReminderData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    String userId = getUser!.uid;
    dynamic result;
    LinkedHashMap<String, dynamic> user =
        await UserServices().getLoggedInUser(userId);
    if (user["reminders"] != null) {
      reminders = user["reminders"];
    }
    List reminderData = [];
    for (var element in reminders) {
      result =
          await ReminderServices().getReminderById(element.toString().trim());
      reminderData.add(result);
    }
    setState(() {
      reminderDataList = reminderData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Reminders'), backgroundColor: kPrimaryColor),
      body: ListView.builder(
          itemCount: reminderDataList.length,
          itemBuilder: (context, index) {
            if (reminderDataList[index] != null ||
                reminderDataList.isNotEmpty) {
              return Card(
                child: ListTile(
                  title: Text(reminderDataList[index]["name"]),
                  trailing: Text(DateTime.parse(
                          reminderDataList[index]["time"].toDate().toString())
                      .toString()),
                ),
              );
            } else {
              return const Text("No Reminders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center);
            }
          }),
    );
  }
}
