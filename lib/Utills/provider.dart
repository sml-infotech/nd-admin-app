import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/create_user_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/create_userscreen.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_password.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_screen.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_screen.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/resetpassword/reset_password_screen.dart';
import 'package:nammadaiva_dashboard/Screens/resetpassword/reset_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/dashboard/dashboard_screen.dart';
import 'package:nammadaiva_dashboard/Screens/dashboard/dashboard_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_listscreen.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_viewmodel.dart' show TempleViewModel;
import 'package:nammadaiva_dashboard/Screens/temple_details/temple_detail_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listscreen.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listviewModel.dart';
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
          create: (context) => TempleDetailViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => OtpViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CreateUserViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
         ChangeNotifierProvider(
          create: (context) => ForgotViewmodel(),
        ),
           ChangeNotifierProvider(
          create: (context) => ResetViewmodel(),
        ),
          ChangeNotifierProvider(
          create: (context) => TempleViewModel(),
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
          home:TempleScreen(),
          onGenerateRoute: router.route));
    
  }
}
