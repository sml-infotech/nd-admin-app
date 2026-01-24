import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/local_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _getFcmToken();
    _loadUserData();
  }

  Future<void> _requestNotificationPermission() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    NotificationSettings settings = await FirebaseMessaging.instance
        .getNotificationSettings();

    print("Notifyyyyyyyyyy${settings.authorizationStatus}");
  }

  Future<void> _getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 FCM TOKEN: $token");
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userRole');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    AppLocalizations.of(context)!.nammDaivaTitleText;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaAppBar(),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  Provider.of<LocaleProvider>(
                    context,
                    listen: false,
                  ).setLocale(const Locale('en'));
                  prefs.setString('language', 'en');
                },
                child: Text(
                  'EN',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: font,
                    fontWeight:
                        context.watch<LocaleProvider>().locale.languageCode ==
                            'en'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              const Text('|'),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  Provider.of<LocaleProvider>(
                    context,
                    listen: false,
                  ).setLocale(const Locale('kn'));
                  prefs.setString('language', 'kn');
                },
                child: Text(
                  'KN',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: font,
                    fontWeight:
                        context.watch<LocaleProvider>().locale.languageCode ==
                            'kn'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                          containerWidget(
                            ImageStrings.ritual,
                            AppLocalizations.of(context)!.updateRequests,
                            () => Navigator.pushNamed(
                              context,
                              StringsRoute.updateRequestsUrl,
                            ),
                          ),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
                await deleteToken();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, StringsRoute.login);
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
