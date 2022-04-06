import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/services/channels/channelServices.dart';

import '../../services/user/userServices.dart';
import '../tvShow/tvShowList.dart';

class MyChannelsList extends StatefulWidget {
  const MyChannelsList({Key? key}) : super(key: key);

  @override
  _MyChannelsListState createState() => _MyChannelsListState();
}

class _MyChannelsListState extends State<MyChannelsList> {
  List channels = [];
  List channelDataList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchChannelData();
  }

  fetchChannelData() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    String userId = getUser!.uid;
    dynamic result;
    try {
      LinkedHashMap<String, dynamic> user =
      await UserServices().getLoggedInUser(userId);
    if (user["channels"] != null) {
      channels = user["channels"];
    }
    }
    catch (err) {
      print(err);
      setState(() {
        loading = false;
      });
    }
    List channelData = [];
    for (var element in channels) {
      try {
        result =
        await ChannelServices().getChannelById(element.toString().trim());
        channelData.add(result);
      }
      catch (err) {
        print(err);
        setState(() {
          loading = false;
        });
      }
    }
    setState(() {
      channelDataList = channelData;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Subscribed Channels'),
            backgroundColor: kPrimaryColor),
        body: Container(
            child: channelDataList.isNotEmpty && !loading ?
                  ListView.builder(
                      itemCount: channelDataList.length,
                      itemBuilder: (context, index) {
                        if (channelDataList[index] != null) {
                          return Card(
                              child: ListTile(
                                  title: Text(channelDataList[index]["name"]),
                                  subtitle: Text(
                                      channelDataList[index]["description"]),
                                  leading: Image.network(
                                    channelDataList[index]["image"],
                                    width: 50,
                                    height: 50,)));
                        }
                        else {
                          return const Card();
                        }
                      }
                  ):const Center(child:CircularProgressIndicator())
            )
        );
  }
}
