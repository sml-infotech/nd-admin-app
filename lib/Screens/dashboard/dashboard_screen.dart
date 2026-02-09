import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/dashboard/dashboard_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/local_provider.dart';
import 'package:nammadaiva_dashboard/Utills/notification_service.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/statictics_model/dashboard-statistics.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:shimmer/shimmer.dart';

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
      Navigator.pushNamedAndRemoveUntil(
        context,
        StringsRoute.login,
        (route) => false,
      );
      print("✅ Logout + FCM token deleted");
    } catch (e, stack) {
      print("❌ Error during logout: $e");
      print(stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    dashboardViewmodel = Provider.of<DashboardViewmodel>(context);

    AppLocalizations.of(context)!.nammDaivaTitleText;

    return FocusDetector(
      onFocusGained: () async {
        await dashboardViewmodel.getDashboardData();
      },

      child: Scaffold(
        backgroundColor: ColorConstant.buttonColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: dashboardHeader(),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                      child: Column(
                        children: [
                          if (dashboardViewmodel.isLoading)
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: List.generate(
                                6,
                                (_) => gridItemShimmer(),
                              ),
                            )
                          else if (dashboardViewmodel.dashboardStats != null)
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: [
                                if (role == "Super Admin" ||
                                    role == "Admin") ...[
                                  if (dashboardViewmodel.dashboardStats != null)
                                    dashboardStatsCard(
                                      stats: dashboardViewmodel.dashboardStats!,
                                    ),
                                ],
                                containerWidget(
                                  ImageStrings.templeImage,
                                  AppLocalizations.of(
                                    context,
                                  )!.templeDetailText,
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
      ),
    );
  }

  Widget dashboardHeader() {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 50),
      child: Container(
        color: ColorConstant.buttonColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              roundedBackground(userName),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcome,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontFamily: font,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          userName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: font,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              StringsRoute.notification_screen,
                            );
                          },
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _showLogoutDialog(context),
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _languageButton('EN', 'en'),
                        const SizedBox(width: 6),
                        Text('|', style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 6),
                        _languageButton('KN', 'kn'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roundedBackground(String? name) {
    String initial = "";
    if (name != null && name.isNotEmpty) {
      initial = name[0].toUpperCase();
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: Color(0xffE6F4EC),
      child: Text(initial),
    );
  }

  Widget _languageButton(String label, String code) {
    return GestureDetector(
      onTap: () async {
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
          color: Colors.white,
          fontFamily: font,
          fontSize: 14,
          fontWeight:
              context.watch<LocaleProvider>().locale.languageCode == code
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }

  Widget dashboardStatsCard({required DashboardStats stats}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _gridItem(
                  title: AppLocalizations.of(context)!.totalTemples,
                  count: stats.totalTemples.toString(),
                  image: ImageStrings.templeImage,
                ),
                _verticalDivider(),
                _gridItem(
                  title: AppLocalizations.of(context)!.totalTransactions,
                  count: stats.totalTransactionAmount.toString(),
                  image: ImageStrings.sevaimg,
                ),
              ],
            ),

            _horizontalDivider(),

            Row(
              children: [
                _gridItem(
                  title: AppLocalizations.of(context)!.totalBookings,
                  count: stats.totalBookings.toString(),
                  image: ImageStrings.wowtracker,
                ),
                _verticalDivider(),
                _gridItem(
                  title: AppLocalizations.of(context)!.totalUsers,
                  count: stats.totalUsers.toString(),
                  image: ImageStrings.transaction,
                ),
              ],
            ),
          ],
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

  Widget _gridItem({
    required String title,
    required String count,
    required String image,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Image.asset(image, height: 36, width: 36),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontFamily: font,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: font,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _horizontalDivider() {
    return Divider(
      indent: 16,
      thickness: 1,
      color: Colors.grey[400],
      endIndent: 16,
    );
  }

  Widget _verticalDivider() {
    return Container(height: 90, width: 1.2, color: Colors.grey[400]);
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
                setState(() {
                  dashboardViewmodel.isLoading = true;
                });
                Navigator.of(context).pop();

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

Widget gridItemShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Container(
        height: 156,
        width: 165,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
