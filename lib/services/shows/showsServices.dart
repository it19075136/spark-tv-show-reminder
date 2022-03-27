import 'package:cloud_firestore/cloud_firestore.dart';

class showServices {

  final CollectionReference showRef = FirebaseFirestore.instance.collection('shows');

  Future getShowById(String id) async {
    try {
      DocumentSnapshot<Object?> snapshot = await showRef.doc(id).get();
      return snapshot.data();
    }
    catch(err) {
      print(err.toString());
    }
  }

  Future getAllShows() async {

    List showsList = [];
    try {
      await showRef.get().then((value) => {
        value.docs.forEach((element) {
          showsList.add(element.data());
        })
      });
      return showsList;
    }
    catch(err) {
      print(err.toString());
      return null;
    }
  }

}