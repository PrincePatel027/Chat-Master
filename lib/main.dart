import 'dart:developer';

import 'package:bubbly_chatting/helper/l_notification_helper.dart';
import 'package:bubbly_chatting/views/components/my_light_theme.dart';
import 'package:bubbly_chatting/views/pages/chat_page.dart';
import 'package:bubbly_chatting/views/pages/login_page.dart';
import 'package:bubbly_chatting/views/pages/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'views/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  log("=======================================================");
  log("Title: ${remoteMessage.notification!.title!}");
  log("Title: ${remoteMessage.notification!.body!}");
  log("=======================================================");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // firebase messege
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // log('Title: ${message.notification!.title!}');
      // log('Body: ${message.notification!.body!}');
      // log('Message data: ${message.data}');
      LNotificationHelper.lNotificationHelper.showLocalNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
      );
    }
  });

  // background notification

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyLightTheme.lightTheme,
      initialRoute: "splash",
      routes: {
        '/': (_) => const HomePage(),
        'login': (_) => const LoginPage(),
        'chat': (_) => const ChatPage(),
        'splash': (_) => const Splash(),
      },
    ),
  );
}

// keytool -list -v -alias androiddebugkey -keystore C:\\Users\\princ\\.android\\debug.keystore