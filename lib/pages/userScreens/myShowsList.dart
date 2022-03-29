import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/services/shows/showsServices.dart';

import '../../services/user/userServices.dart';

class MyShowsList extends StatefulWidget {
  const MyShowsList({Key? key}) : super(key: key);

  @override
  _MyShowsListState createState() => _MyShowsListState();
}

class _MyShowsListState extends State<MyShowsList> {

  List tvShows = [];
  List tvShowDataList = [];

  @override
  void initState() {
    super.initState();
    fetchTvShowData();
  }

  fetchTvShowData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    String userId = getUser!.uid;
    dynamic result;
    LinkedHashMap<String, dynamic> user =
        await UserServices().getLoggedInUser(userId);
    tvShows = user["shows"];
    List showData = [];
    for (var element in tvShows) {
      result = await showServices().getShowById(element.toString().trim());
      showData.add(result);
    }
    setState(() {
      tvShowDataList= showData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribed Tv Shows'),
        backgroundColor: kPrimaryColor
      ),
      body: ListView.builder(
          itemCount: tvShowDataList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(tvShowDataList[index]["tvShowName"]),
                subtitle: Text(tvShowDataList[index]["description"]),
                leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                trailing: Text(DateTime.parse(tvShowDataList[index]["showDate"].toDate().toString()).toString()),
              ),
            );
          }),
    );
  }
}
