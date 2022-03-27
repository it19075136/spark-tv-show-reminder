// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// // import 'package:spark_tv_shows/pages/addTvShow1.dart';
// import 'package:spark_tv_shows/pages/editTvShow2.dart';
// import 'package:spark_tv_shows/pages/tvShow/addTvShow.dart';

// class TvShow extends StatefulWidget {
//   const TvShow({Key? key}) : super(key: key);

//   @override
//   State<TvShow> createState() => _TvShowState();
// }

// class _TvShowState extends State<TvShow> {
//   final Stream<QuerySnapshot> _userStream =
//       FirebaseFirestore.instance.collection('shows').snapshots();
//       var db = FirebaseFirestore;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => AddTvShow()));
//         },
//         child: const Icon(
//           Icons.add,
//         ),
//       ),
//       appBar: AppBar(
//         title: const Text('Tv Shows'),
//       ),
//       body: StreamBuilder(
//           stream: _userStream,
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return const Text("Something is wrong");
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (_, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => EditTvShow(
//                                   docid: snapshot.data!.docs[index],
//                                 )));
//                   },
//                   // padding: const EdgeInsets.all(8),
//                   child: Column(
//                     children: [
//                       Padding(padding: const EdgeInsets.all(32.0) ),
//                       Card(
//                         child: ListTile(
//                             title: Text(snapshot
//                                 .data!.docChanges[index].doc['tvShowName']),
//                             subtitle: Text(snapshot
//                                 .data!.docChanges[index].doc['description']),
//                             leading: const CircleAvatar(
//                                 backgroundImage: NetworkImage(
//                                     "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
//                             trailing: IconButton(
//                                 onPressed: () {
                                  
                                  
//                                 },
//                                 icon: const Icon(Icons.notifications))),
//                       ),
//                       // Card(
//                       //     child: ListTile(
//                       //         title: Text("Anchor"),
//                       //         subtitle: Text("Lower the anchor."),
//                       //         leading: CircleAvatar(
//                       //             backgroundImage: NetworkImage(
//                       //                 "https://miro.medium.com/fit/c/64/64/1*WSdkXxKtD8m54-1xp75cqQ.jpeg")),
//                       //         trailing: Icon(Icons.star))),
//                       // Card(
//                       //     child: ListTile(
//                       //         title: Text("Alarm"),
//                       //         subtitle: Text("This is the time."),
//                       //         leading: CircleAvatar(
//                       //             backgroundImage: NetworkImage(
//                       //                 "https://miro.medium.com/fit/c/64/64/1*WSdkXxKtD8m54-1xp75cqQ.jpeg")),
//                       //         trailing: Icon(Icons.star))),
//                       // Card(
//                       //     child: ListTile(
//                       //         title: Text("Ballot"),
//                       //         subtitle: Text("Cast your vote."),
//                       //         leading: CircleAvatar(
//                       //             backgroundImage: NetworkImage(
//                       //                 "https://miro.medium.com/fit/c/64/64/1*WSdkXxKtD8m54-1xp75cqQ.jpeg")),
//                       //         trailing: Icon(Icons.star)))
//                     ],
//                   ),
//                 );
//               },
//             );
//             // return Container(
//             //   decoration: BoxDecoration(
//             //     borderRadius: BorderRadius.circular(12),
//             //   ),
//             //   child: ListView.builder(
//             //       itemCount: snapshot.data!.docs.length,
//             //       itemBuilder: (_, index) {
//             //         return GestureDetector(
//             //             onTap: () {
//             //               Navigator.push(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                       builder: (_) => EditTvShow(
//             //                             docid: snapshot.data!.docs[index],
//             //                           )));
//             //             },
//             //             child: Column(
//             //               children: [
//             //                 const SizedBox(
//             //                   height: 4,
//             //                 ),
//             //                 Padding(
//             //                   padding: const EdgeInsets.only(
//             //                     left: 3,
//             //                     right: 3,
//             //                   ),
//             //                   child: ListTile(
//             //                     shape: RoundedRectangleBorder(
//             //                       borderRadius: BorderRadius.circular(10),
//             //                       side: const BorderSide(color: Colors.black),
//             //                     ),
//             //                     title: Text(
//             //                       snapshot.data!.docChanges[index]
//             //                           .doc['tvShowName'],
//             //                       style: const TextStyle(
//             //                         fontSize: 20,
//             //                       ),
//             //                     ),
//             //                     subtitle: Text(
//             //                       snapshot.data!.docChanges[index]
//             //                           .doc['description'],
//             //                       style: const TextStyle(
//             //                         fontSize: 20,
//             //                       ),
//             //                     ),
//             //                     contentPadding: const EdgeInsets.symmetric(
//             //                       vertical: 12,
//             //                       horizontal: 16,
//             //                     ),
//             //                   ),
//             //                 ),
//             //               ],
//             //             ));
//             //       }),
//             // );
//           }),
//     );
//   }
// }
