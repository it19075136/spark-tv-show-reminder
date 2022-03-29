import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelServices {

  final CollectionReference channelRef = FirebaseFirestore.instance.collection('channels');

  Future getChannelById(String id) async {
    try {
      DocumentSnapshot<Object?> snapshot = await channelRef.doc(id).get();
      return snapshot.data();
    }
    catch(err) {
      print(err.toString());
    }
  }

  Future getAllChannels() async {

    List channelList = [];
    try {
      await channelRef.get().then((value) => {
        value.docs.forEach((element) {
          channelList.add(element.data());
        })
      });
      return channelList;
    }
    catch(err) {
      print(err.toString());
      return null;
    }
  }

}