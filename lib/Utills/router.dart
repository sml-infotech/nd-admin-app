import 'package:flutter/cupertino.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_screen.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_screen.dart';
import 'package:nammadaiva_dashboard/Screens/temple_details/temple_details_screen.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';


class AppRouter {
  Route<dynamic>? route(RouteSettings settings) {
    switch (settings.name) {
      case StringsRoute.login:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => LoginScreen(),
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

