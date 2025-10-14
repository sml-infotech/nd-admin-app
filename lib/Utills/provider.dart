import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_screen.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_screen.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_screen.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/temple_details/temple_detail_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/router.dart';
import 'package:provider/provider.dart';


class ProviderWidget extends StatelessWidget {
  ProviderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();
    String initialRoute = '/';
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
      ChangeNotifierProvider(
          create: (context) => TempleViewmodel(),
        ),
      ChangeNotifierProvider(
          create: (context) => TempleDetailViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => OtpViewmodel(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(
            textTheme: TextTheme(
              // bodyLarge: TextStyle(fontFamily: font),
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          home: LoginScreen(),
          onGenerateRoute: router.route),
    );
  }
}
