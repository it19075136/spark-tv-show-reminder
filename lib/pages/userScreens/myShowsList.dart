import 'dart:collection';
import 'dart:ui';

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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTvShowData();
  }

  fetchTvShowData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    String userId = getUser!.uid;
    dynamic result;
    try {
      LinkedHashMap<String, dynamic> user =
          await UserServices().getLoggedInUser(userId);
      if (user["shows"] != null) {
        tvShows = user["shows"];
        print(tvShows.toString());
      }
    } catch (err) {
      print(err);
      setState(() {
        loading = false;
      });
    }
    List showData = [];
    for (var element in tvShows) {
      try {
        result = await showServices().getShowById(element.toString().trim());
        print(result.toString());
        showData.add(result);
      } catch (err) {
        print(err);
        setState(() {
          loading = false;
        });
      }
    }
    setState(() {
      tvShowDataList = showData;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Subscribed Tv Shows'),
            backgroundColor: kPrimaryColor),
        body: Container(
          child: tvShowDataList.isNotEmpty && !loading
              ? ListView.builder(
                  itemCount: tvShowDataList.length,
                  itemBuilder: (context, index) {
                    if (tvShowDataList[index] != null) {
                      return Card(
                        child: ListTile(
                          title: Text(tvShowDataList[index]["tvShowName"]),
                          subtitle: Text(tvShowDataList[index]["description"]),
                          leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                          trailing: Text(DateTime.parse(tvShowDataList[index]
                                      ["showDate"]
                                  .toDate()
                                  .toString())
                              .toString()),
                        ),
                      );
                    } else {
                      return const Card();
                    }
                  })
              : const Center(child: CircularProgressIndicator()),
        ));
  }
}
