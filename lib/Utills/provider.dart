import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nammadaiva_dashboard/Common/splash_screen.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/bookings/bookings_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/contact_us/contact_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/create_event/create_event_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/festivals/create_festival_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/event_list_screen/event_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/highlight_upload_screen/highlight_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/mantra/create_mantra_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/mantra/mantra_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/master_temple/master_temple_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/puja_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/update_requests/update_request_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/local_provider.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
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
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
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
        ChangeNotifierProvider(create: (context) => UpdateRequestViewModel()),
        ChangeNotifierProvider(create: (context) => CreateEventViewmodel()),
        ChangeNotifierProvider(create: (context) => EventListViewmodel()),
        ChangeNotifierProvider(create: (context) => BookingsViewmodel()),
        ChangeNotifierProvider(create: (context) => ContactViewModel()),
        ChangeNotifierProvider(create: (context) => CreateMantraViewmodel()),
        ChangeNotifierProvider(create: (context) => MantraListViewmodel()),
        ChangeNotifierProvider(create: (context) => CreateFestivalViewmodel()),
        ChangeNotifierProvider(
          create: (context) => MasterTempleListViewmodel(),
        ),
        ChangeNotifierProvider(create: (context) => HighlightViewmodel()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('kn')],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(textTheme: const TextTheme()),
            home: FutureBuilder<bool>(
              future: _checkToken(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final hasToken = snapshot.data ?? false;

                return SplashScreen();
                //  hasToken ? const DashboardScreen() : const LoginScreen();
              },
            ),
            onGenerateRoute: router.route,
          );
        },
      ),
    );
  }
}
