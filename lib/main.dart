import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/OTP.dart';
import 'package:flutter_application_1/Bottom.dart';
import 'package:flutter_application_1/splash.dart';

import 'local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

String? FCMToken;

Future<void> backgroundHandler(RemoteMessage message) async {
  Debugs(message.data.toString());
  Debugs(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  FCMToken = await FirebaseMessaging.instance.getToken();
  //await FirebaseMessaging.instance.requestPermission();

  runApp(const MyApp());
  Debugs('FCM Token: $FCMToken');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      title: 'lookranks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        //dialogTheme: customDialogTheme,
      ),
      home: SplashScreen(),
    );
  }
}

final DialogTheme customDialogTheme = DialogTheme(
  // Customize the dialog background color
  backgroundColor: Colors.white,

  // Customize the shape of the dialog
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),

  // Customize the elevation of the dialog
  elevation: 1,

  // Customize the text style of the dialog title
  titleTextStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),

  // Customize the text style of the dialog content
  contentTextStyle: TextStyle(
    fontSize: 16,
    color: Colors.black87,
  ),
);
