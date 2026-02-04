import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nammadaiva_dashboard/Screens/dashboard/dashboard_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/local_provider.dart';
import 'package:nammadaiva_dashboard/Utills/notification_service.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? token;
  String? role;
  String? userName;
  late DashboardViewmodel dashboardViewmodel;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _requestNotificationPermission();
    _getFcmToken();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initPushNotifications();
    // });
  }

  // Future<void> _initPushNotifications() async {
  //   final settings = await FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized ||
  //       settings.authorizationStatus == AuthorizationStatus.provisional) {
  //     try {
  //       var token = await FirebaseMessaging.instance.getAPNSToken();
  //       print("token: $token");
  //       var token1 = await FirebaseMessaging.instance.getToken();

  //       print("token1111$token1");
  //     } catch (e) {
  //       print(">>>>>>>>>>>>>>>>1111${e}");
  //     }
  //   } else {
  //     print("❌ Notification permission denied");
  //   }
  // }

  Future<void> _requestNotificationPermission() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    NotificationSettings settings = await FirebaseMessaging.instance
        .getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      _getFcmTokenAndSend();
    }
  }

  String _getDeviceType() {
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    return "unknown";
  }

  Future<void> _getFcmTokenAndSend() async {
    String? fcmToken = await _getFcmToken();
    ;

    if (fcmToken != null) {
      final deviceType = _getDeviceType();

      print("🔥 FCM TOKEN: $fcmToken");
      print("📱 DEVICE TYPE: $deviceType");

      await dashboardViewmodel.postFcmToken(fcmToken, deviceType);
    }
  }

  Future<String> _getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 FCM TOKEN: $token");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token ?? "");
    return token ?? "";
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('authToken');
      role = prefs.getString('userRole');
      userName = prefs.getString('UserName');
    });
  }

  Future<void> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? fcmToken = prefs.getString('fcm_token');

      if (fcmToken != null && fcmToken.isNotEmpty) {
        await dashboardViewmodel.logout(fcmToken);
      }

      await FirebaseMessaging.instance.deleteToken();

      await prefs.remove('fcm_token');
      await prefs.remove('authToken');
      await prefs.remove('userRole');

      print("✅ Logout + FCM token deleted");
    } catch (e, stack) {
      print("❌ Error during logout: $e");
      print(stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    dashboardViewmodel = Provider.of<DashboardViewmodel>(
      context,
      listen: false,
    );

    AppLocalizations.of(context)!.nammDaivaTitleText;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaAppBar(),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8F0), Color(0xFFFFF8F0)],
          ),
        ),
        child: Stack(
          children: [
            rightImage(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _languageButton('EN', 'en'),
                      const Text('|'),
                      _languageButton('KN', 'kn'),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.black87.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                    child: Column(
                      children: [
                        welcomeText(),
                        const SizedBox(height: 15),

                        if (token != null && role != null) ...[
                          Text(
                            userName ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontFamily: font,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        /// 🔹 Dashboard Grid
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            containerWidget(
                              ImageStrings.templeImage,
                              AppLocalizations.of(context)!.templeDetailText,
                              () => Navigator.pushNamed(
                                context,
                                StringsRoute.templeScreen,
                              ),
                            ),
                            containerWidget(
                              ImageStrings.sevaimg,
                              AppLocalizations.of(context)!.sevaText,
                              () => Navigator.pushNamed(
                                context,
                                StringsRoute.pujaList,
                              ),
                            ),

                            if (role == "Super Admin" || role == "Admin")
                              containerWidget(
                                ImageStrings.onlineseva,
                                AppLocalizations.of(context)!.userDetails,
                                () => Navigator.pushNamed(
                                  context,
                                  StringsRoute.userDetails,
                                ),
                              ),

                            // containerWidget(
                            //   ImageStrings.ritual,
                            //   AppLocalizations.of(context)!.updateRequests,
                            //   () => Navigator.pushNamed(
                            //     context,
                            //     StringsRoute.updateRequestsUrl,
                            //   ),
                            // ),
                            containerWidget(
                              ImageStrings.wowtracker,
                              AppLocalizations.of(context)!.events,
                              () => Navigator.pushNamed(
                                context,
                                StringsRoute.eventListScreen,
                              ),
                            ),

                            containerWidget(
                              ImageStrings.wowtracker,
                              AppLocalizations.of(context)!.bookings,
                              () => Navigator.pushNamed(
                                context,
                                StringsRoute.bookings,
                              ),
                            ),

                            containerWidget(
                              ImageStrings.ritual,
                              AppLocalizations.of(context)!.contacts,
                              () => Navigator.pushNamed(
                                context,
                                StringsRoute.contactUs,
                              ),
                            ),

                            if (role == "Super Admin")
                              containerWidget(
                                ImageStrings.sevaimg,
                                AppLocalizations.of(context)!.masterTemples,
                                () => Navigator.pushNamed(
                                  context,
                                  StringsRoute.master_temple_list,
                                ),
                              ),

                            if (role == "Super Admin")
                              containerWidget(
                                ImageStrings.sevaimg,
                                AppLocalizations.of(context)!.mantra,
                                () => Navigator.pushNamed(
                                  context,
                                  StringsRoute.mantraList,
                                ),
                              ),

                            if (role == "Super Admin")
                              containerWidget(
                                ImageStrings.ritual,
                                AppLocalizations.of(context)!.festivals,
                                () => Navigator.pushNamed(
                                  context,
                                  StringsRoute.festivalList,
                                ),
                              ),

                            if (role == "Super Admin")
                              containerWidget(
                                ImageStrings.ritual,
                                AppLocalizations.of(context)!.addHighlights,
                                () => Navigator.pushNamed(
                                  context,
                                  StringsRoute.highlightUpload,
                                ),
                              ),

                            if (role == "Super Admin")
                              containerWidget(
                                ImageStrings.sevaimg,
                                AppLocalizations.of(context)!.blogs,
                                () => Navigator.pushNamed(
                                  context,
                                  StringsRoute.blog_list,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nammaDaivaAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 24, width: 24),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.nammaDaivaSmall ??
              AppLocalizations.of(context)!.nammaDaivaSmall,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        IconButton(
          padding: EdgeInsets.all(0),
          icon: Image.asset(ImageStrings.logout),
          onPressed: () async {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  Widget _languageButton(String label, String code) {
    return TextButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();

        Provider.of<LocaleProvider>(
          context,
          listen: false,
        ).setLocale(Locale(code));

        await prefs.setString('language', code);
      },
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontFamily: font,
          fontWeight:
              context.watch<LocaleProvider>().locale.languageCode == code
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }

  Widget rightImage() {
    return Align(
      alignment: AlignmentGeometry.topRight,
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(0, 270, 0, 0),
        child: Image.asset(
          ImageStrings.rightimage,
          color: Colors.amber.withOpacity(0.6),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout", style: TextStyle(fontFamily: font)),
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontFamily: font),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(fontFamily: font)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
              ),
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringsRoute.login,
                  (route) => false,
                );
                await deleteToken();
              },

              child: Text(
                "Logout",
                style: TextStyle(fontFamily: font, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget welcomeText() {
    return Text(
      AppLocalizations.of(context)!.welcomeBack,
      style: AppTextStyles.welcomeStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget containerWidget(String image, String title, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 156,
        width: 165,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, height: 60, width: 60),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  style: AppTextStyles.templeNameStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
