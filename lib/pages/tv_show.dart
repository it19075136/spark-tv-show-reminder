import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/addTvShow.dart';
import 'package:spark_tv_shows/pages/editTvShow.dart';

class TvShow extends StatefulWidget {
  const TvShow({Key? key}) : super(key: key);

  @override
  State<TvShow> createState() => _TvShowState();
}

class _TvShowState extends State<TvShow> {
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('shows').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AddTvShow()));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
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
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditTvShow(
                                        docid: snapshot.data!.docs[index],
                                      )));
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 3,
                                right: 3,
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.black),
                                ),
                                title: Text(
                                  snapshot.data!.docChanges[index]
                                      .doc['tvShowName'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                  snapshot.data!.docChanges[index]
                                      .doc['description'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ],
                        ));
                  }),
            );
          }),
    );
  }
}
