import 'package:flutter/cupertino.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/create_userscreen.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_password.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_screen.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_screen.dart';
import 'package:nammadaiva_dashboard/Screens/resetpassword/reset_password_screen.dart';
import 'package:nammadaiva_dashboard/Screens/dashboard/dashboard_screen.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_listscreen.dart';
import 'package:nammadaiva_dashboard/Screens/temple_details/temple_details_screen.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listscreen.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/arguments/otp_arguments.dart';


class AppRouter {
  Route<dynamic>? route(RouteSettings settings) {
    switch (settings.name) {
      case StringsRoute.login:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => LoginScreen(),
        );
          case StringsRoute.otpScreen:
          OtpArguments args = settings.arguments as OtpArguments; 
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OtpScreen(arguments: args),
        );
     case StringsRoute.dashboard:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => DashboardScreen(),
        );
         case StringsRoute.templeDetail:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => TempleDetailsScreen(),
        );

         case StringsRoute.createUser:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateUserScreen(),
        );
         case StringsRoute.forgotPassword:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ForgotPasswordScreen(),
        );
         case StringsRoute.resetPassword:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ResetPasswordScreen(),
        );

         case StringsRoute.userDetails:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserListScreen(),
        );
          case StringsRoute.templeScreen:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => TempleScreen(),
        );
      default:
        throw Exception('Route ${settings.name} not implemented');
    }
  }
}

