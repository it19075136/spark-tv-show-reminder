import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spark_tv_shows/pages/channels.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/pages/login/login.dart';
import 'package:spark_tv_shows/pages/signUp/register.dart';
import 'package:spark_tv_shows/pages/tvShow/tvShowList.dart';
import 'package:spark_tv_shows/pages/userScreens/myChannels.dart';
import 'package:spark_tv_shows/pages/userScreens/myShowsList.dart';
import 'package:spark_tv_shows/pages/welcome/welcome.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/welcome': (context) => const Welcome(),
        '/tvShows': (context) =>  TvShowList(),
        '/channels': (context) => const Channels(),
        '/myShows': (context) => const MyShowsList(),
        '/myChannels': (context) => const MyChannelsList()
      },
      title: 'Spark TV Shows',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white
      )
    );
  }
}
