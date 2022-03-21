import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/channels.dart';
import 'package:spark_tv_shows/pages/tv_show.dart';

import 'config/firebase_config.dart';

Future<void> main() async {
  //Initialized firebase to the project
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spark TV Shows',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TvShow(),
    );
  }
}
