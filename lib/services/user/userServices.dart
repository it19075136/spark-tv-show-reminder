import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {

  final CollectionReference userRef = FirebaseFirestore.instance.collection('user');

  Future<void> insertUser(String uid, String name, String email, String phone, String type) async {
    return await userRef.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'type': type
    });
  }

  Future getLoggedInUser(String uid) async {
    try {
      DocumentSnapshot<Object?> snapshot = await userRef.doc(uid).get();
      return snapshot.data();
    }
    catch(err) {
      print(err.toString());
    }
  }

  Future updateUser( String uid, String name, String phone) async {
    try {
      return await userRef.doc(uid).update({
        "name": name,
        "phone": phone
      });
    }
    catch (err) {
      print(err.toString());
      return "error";
    }
  }
}