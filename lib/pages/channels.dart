import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/add_channel.dart';

class Channels extends StatefulWidget {
  const Channels({Key? key}) : super(key: key);

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {

  final Stream<QuerySnapshot> _chaneelStream = FirebaseFirestore.instance.collection("channels").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: MaterialButton(onPressed: (){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> AddChannel()));
      },
       child: Icon(
         Icons.add
       ),),
      appBar: AppBar(
        title: Center(child: Text("Channels"),
        ),
      ),
      body: StreamBuilder(
        builder:  (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text("Something Went Wrong")
            );
          }
          return Container(
            child: ListView.builder(itemCount:snapshot.data!.docs.length,itemBuilder: (_,index){
              return GestureDetector(
                onTap:null ,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(padding: EdgeInsets.only(left: 3,right: 3),
                    child: ListTile(
                      title: Text(
                        snapshot.data!.docChanges[index].doc["name"]
                      ),
                      subtitle: Text(
                        snapshot.data!.docChanges[index].doc["description"]
                      ),
                    ) ,)
                  ],
                ),
              );
            }),
          );
        },
        stream: _chaneelStream,
      ),
    );
  }
}
