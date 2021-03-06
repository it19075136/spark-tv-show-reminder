import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spark_tv_shows/pages/channels/channels.dart';
import 'package:spark_tv_shows/constants.dart';
import 'package:spark_tv_shows/pages/login/login.dart';
import 'package:spark_tv_shows/pages/signUp/register.dart';
import 'package:spark_tv_shows/pages/userScreens/myChannels.dart';
import 'package:spark_tv_shows/pages/userScreens/myReminders.dart';
import 'package:spark_tv_shows/pages/userScreens/myShowsList.dart';
import 'package:spark_tv_shows/pages/welcome/welcome.dart';
import 'config/firebase_config.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
  FlutterLocalNotificationsPlugin();
 
Future<void> main() async {
  //Initialized firebase to the project
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  runApp(const MyApp());

  var initializationSettingsAndroid = AndroidInitializationSettings('codex_logo');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission :true,
    // onDidReceiveLocalNotification:(int id) async {};
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
        , iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {
        if(payload != null){
          debugPrint('notification payload: ' + payload);
        }
      },
    );

  // await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  // await Firebase.initializeApp();
  
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
        '/channels': (context) => const Channels(),
        '/myShows': (context) => const MyShowsList(),
        '/myChannels': (context) => const MyChannelsList(),
        '/reminders': (context) => const MyRemindersList()
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
