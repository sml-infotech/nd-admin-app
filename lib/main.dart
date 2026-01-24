import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/notification_service.dart';
import 'package:nammadaiva_dashboard/Utills/provider.dart';



RemoteMessage? initialMessage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FcmNotificationService.init();

  runApp(const ProviderWidget());

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
  });
}
