import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/tvShow/addTvShow.dart';
import 'package:spark_tv_shows/pages/tvShow/editTvShow.dart';
import 'package:spark_tv_shows/services/user/userServices.dart';

class TvShowList extends StatefulWidget {
  DocumentSnapshot channelDoc;
  TvShowList({Key? key, required this.channelDoc}) : super(key: key);

  @override
  State<TvShowList> createState() => _TvShowListState();
}

class _TvShowListState extends State<TvShowList> {
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('user');

  List showList = [];
  //Get Logged in User
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
      body: StreamBuilder(
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
                            trailing: IconButton(
                              icon: Icon(Icons.notifications,
                                  color: showList.contains(
                                          snapshot.data!.docs[index].id)
                                      ? Colors.red
                                      : Colors.grey),
                              onPressed: () async {
                                showList.contains(snapshot.data!.docs[index].id)
                                    ? (await FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(userId)
                                        .update({
                                        "shows": FieldValue.arrayRemove(
                                            [snapshot.data!.docs[index].id])
                                      }).then((value) => showList.remove(
                                            snapshot.data!.docs[index].id)))
                                    : (await FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(userId)
                                        .update({
                                        "shows": FieldValue.arrayUnion(
                                            [snapshot.data!.docs[index].id])
                                      }).then((value) => showList.add(
                                            snapshot.data!.docs[index].id)));
                              },
                            )),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
