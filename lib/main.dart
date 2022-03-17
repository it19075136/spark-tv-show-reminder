import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/tv_show.dart';

Future<void> main() async {
  //Initialized firebase to the project
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "",
      appId: "1:555956113257:android:a080ac6b8b26042d3977f8",
      messagingSenderId: "555956113257",
      projectId: "555956113257",
    ),
  );
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
