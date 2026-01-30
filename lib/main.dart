import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nammadaiva_dashboard/Utills/notification_service.dart';
import 'package:nammadaiva_dashboard/Utills/provider.dart';
import 'package:nammadaiva_dashboard/firebase_options.dart';

RemoteMessage? initialMessage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FcmNotificationService.init();

  initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  runApp(const ProviderWidget());
}
