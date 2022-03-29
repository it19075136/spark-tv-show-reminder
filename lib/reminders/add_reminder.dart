import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Reminders",
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Stream<QuerySnapshot> _reminderStream = FirebaseFirestore.instance.collection('reminders').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
          ),
      ),
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: StreamBuilder(
        stream: _reminderStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("Something is wrong");
          }
        }
      ),
    );
  }
}

