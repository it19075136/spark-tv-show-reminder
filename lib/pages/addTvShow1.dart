// import 'dart:ffi';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:spark_tv_shows/pages/tv_show1.dart';

// class AddTvShow extends StatelessWidget {
//   TextEditingController tvShowName  = TextEditingController();
//   TextEditingController description = TextEditingController();
//   TextEditingController time        = TextEditingController();
//   TextEditingController date        = TextEditingController();
//   TextEditingController channel     = TextEditingController();
//   bool subscribe = true;

//   CollectionReference ref = FirebaseFirestore.instance.collection('shows');

//   AddTvShow({Key? key}) : super(key: key);

//   final List<String> channels = ['Sirasa', 'Derana', 'ITN'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add tv show'),
//         actions: [
//         MaterialButton(onPressed: (){
//           ref.add({
//             'tvShowName': tvShowName.text,
//             'description': description.text,
//             // 'time': time.text,
//             // 'date': date.text,
//             // 'channel': channel.text,
//             'subscribe': subscribe,
//           }).whenComplete(() {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TvShow()));
//           });
//         },
//         child: const Text(
//           "save",
//         ),
//         )
//       ]),
//       body: Container(
//         child: Column(
//           children: [
//             // DropdownButtonFormField(
//             //   items: channels.map(
//             //     (channel) => DropdownMenuItem(
//             //       child: Text(channel)
//             //     )).toList(), 
//             //   onChanged: 
//             // ),
//             const SizedBox(
//               height: 10,
//             ),
//             Container(
//               // decoration: BoxDecoration(border: Border.all()),
//               child: TextField(
//                 controller:  tvShowName,
//                 decoration: const InputDecoration(
//                   hintText: 'TV Show Name',
//                   label: Text('Tv Show Name')
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Expanded(
//               child: Container(
//               // decoration: BoxDecoration(border: Border.all()),
//               child: TextField(
//                 controller:  description,
//                 expands: true,
//                 maxLines: null,
//                 decoration: const InputDecoration(
//                   hintText: 'Description',
//                 ),
//               ),
//             ),
//             )
//           ],
//         )
//       ),
//     );
//   }
// }