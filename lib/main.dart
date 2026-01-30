import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nammadaiva_dashboard/Utills/local_provider.dart';
import 'package:nammadaiva_dashboard/Utills/notification_service.dart';
import 'package:nammadaiva_dashboard/Utills/provider.dart';
import 'package:nammadaiva_dashboard/firebase_options.dart';
import 'package:provider/provider.dart';

RemoteMessage? initialMessage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FcmNotificationService.init();
  initialMessage = await FirebaseMessaging.instance.getInitialMessage();
   final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLanguage();
  runApp(ChangeNotifierProvider.value(
      value: localeProvider,
      child: const ProviderWidget(),
    ));
}
