import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderServices {

  final CollectionReference reminderRef = FirebaseFirestore.instance.collection('reminders');

  Future getReminderById(String id) async {
    try {
      DocumentSnapshot<Object?> snapshot = await reminderRef.doc(id).get();
      return snapshot.data();
    }
    catch(err) {
      print(err.toString());
    }
  }

  Future getAllReminders() async {

    List remindersList = [];
    try {
      await reminderRef.get().then((value) => {
        value.docs.forEach((element) {
          remindersList.add(element.data());
        })
      });
      return remindersList;
    }
    catch(err) {
      print(err.toString());
      return null;
    }
  }

}