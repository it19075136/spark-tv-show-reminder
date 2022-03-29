import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/tvShow/addTvShow.dart';
import 'package:spark_tv_shows/services/user/userServices.dart';
import '../editTvShow2.dart';

class TvShowList extends StatefulWidget {
  TvShowList({Key? key}) : super(key: key);

  @override
  State<TvShowList> createState() => _TvShowListState();
}

class _TvShowListState extends State<TvShowList> {
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('user');
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('shows').snapshots();
  bool _subscribed = false;

  //Get Logged in User
  String userId = "";
  TextEditingController _userType = TextEditingController();
  TextEditingController _userName = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userId = getUser!.uid;
    LinkedHashMap<String, dynamic> user =
        await UserServices().getLoggedInUser(userId);
    _userType.value = TextEditingValue(text: user["type"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _getFAB(),
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
                    if (_userType.text == "admin") {
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
                            leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                            trailing: IconButton(
                              icon: Icon(Icons.notifications,
                                  color: _subscribed == true
                                      ? Colors.red
                                      : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _subscribed = !_subscribed;
                                  addTvToUser(
                                      userId, snapshot.data!.docs[index]);
                                });
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

  Widget _getFAB() {
    if ( _userType.text ==  "admin") {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AddTvShow()));
        },
        child: const Icon(
          Icons.add,
        ),
      );
    } else {
      return Container();
    }
  }

  Future addTvToUser(String uid, dynamic tvShowId) async {
    try {
      return await userRef.doc(uid).update({"tvShows": tvShowId});
    } catch (error) {
      print(error.toString());
    }
  }
}