import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/add_channel.dart';
import 'package:spark_tv_shows/pages/edit_channels.dart';

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

      floatingActionButton: FloatingActionButton(onPressed: (){
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
        stream: _chaneelStream,
        builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15)
            ),
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_,index){
              return GestureDetector(
                onTap:() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditChannel(
                            docid: snapshot.data!.docs[index],
                          )));
                } ,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(padding: EdgeInsets.only(left: 3,right: 3),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black)
                      ),
                      title: Text(
                        snapshot.data!.docChanges[index].doc["name"],
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data!.docChanges[index].doc["description"],
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16
                      ),
                    ) ,)
                  ],
                ),
              );
            }),
          );
        },

      ),
    );
  }
}
