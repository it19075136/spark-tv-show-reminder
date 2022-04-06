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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchReminderData();
  }

  fetchReminderData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    String userId = getUser!.uid;
    dynamic result;
    try {
      LinkedHashMap<String, dynamic> user =
          await UserServices().getLoggedInUser(userId);
      if (user["reminders"] != null) {
        reminders = user["reminders"];
      }
    } catch (err) {
      print(err);
      setState(() {
        loading = false;
      });
    }
    List reminderData = [];
    for (var element in reminders) {
      try {
        result =
            await ReminderServices().getReminderById(element.toString().trim());
        reminderData.add(result);
      } catch (err) {
        print(err);
        setState(() {
          loading = false;
        });
      }
    }
    setState(() {
      reminderDataList = reminderData;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Reminders'), backgroundColor: kPrimaryColor),
      body: reminderDataList.isNotEmpty && !loading
          ? ListView.builder(
              itemCount: reminderDataList.length,
              itemBuilder: (context, index) {
                if (reminderDataList[index] != null ||
                    reminderDataList.isNotEmpty) {
                  return Card(
                    child: ListTile(
                      title: Text(reminderDataList[index]["tvShowName"]),
                      trailing: Text(reminderDataList[index]["reminderDate"]),
                    ),
                  );
                } else {
                  return const Text("No Reminders",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center);
                }
              })
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
