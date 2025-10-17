import 'package:flutter/cupertino.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_screen.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_screen.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_screen.dart';
import 'package:nammadaiva_dashboard/Screens/temple_details/temple_details_screen.dart';
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
     case StringsRoute.templeScreen:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => TempleScreen(),
        );
         case StringsRoute.templeDetail:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => TempleDetailsScreen(),
        );
      default:
        throw Exception('Route ${settings.name} not implemented');
    }
  }
}

