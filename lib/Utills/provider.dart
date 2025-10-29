import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_screen.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/puja_list.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/puja_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_screen.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_listscreen.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_screen.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nammadaiva_dashboard/Screens/createuser/create_user_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_screen.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/resetpassword/reset_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/dashboard/dashboard_screen.dart';
import 'package:nammadaiva_dashboard/Screens/dashboard/dashboard_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/temple_details/temple_detail_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listviewModel.dart';
import 'package:nammadaiva_dashboard/Utills/router.dart';

class ProviderWidget extends StatelessWidget {
  const ProviderWidget({super.key});

  Future<bool> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final role = prefs.getString('userRole');
    print(">>>>>>>>>>$token");
    print(">>>>>>>>>>>$role");
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => TempleDetailViewmodel()),
        ChangeNotifierProvider(create: (context) => OtpViewmodel()),
        ChangeNotifierProvider(create: (context) => CreateUserViewmodel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => ForgotViewmodel()),
        ChangeNotifierProvider(create: (context) => ResetViewmodel()),
        ChangeNotifierProvider(create: (context) => TempleViewModel()),
        ChangeNotifierProvider(create: (context) => DashboardViewmodel()),
        ChangeNotifierProvider(create: (context) => AddTempleViewmodel()),
        ChangeNotifierProvider(create: (context) => UpdateTempleViewmodel()),
        ChangeNotifierProvider(create: (context) => CreatePujaViewmodel()),
        ChangeNotifierProvider(create: (context) => PujaListViewmodel()),
      ],
      child: FutureBuilder<bool>(
        future: _checkToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          final hasToken = snapshot.data ?? false;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(textTheme: const TextTheme()),
            initialRoute: hasToken ? StringsRoute.dashboard : '/login',
            onGenerateRoute: router.route,
            home: hasToken ? const PujaList() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
