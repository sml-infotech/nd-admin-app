import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('authToken');
      role = prefs.getString('userRole');
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaAppBar(),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
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
                          "Role: $role",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
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
                            StringConstant.templeDetailText,
                            () => Navigator.pushNamed(
                              context,
                              StringsRoute.templeScreen,
                            ),
                          ),
                          containerWidget(
                            ImageStrings.sevaimg,
                            StringConstant.sevaText,
                            () => Navigator.pushNamed(
                              context,
                              StringsRoute.pujaList,
                            ),
                          ),
                          if (role == "Super Admin" || role == "Admin")
                            containerWidget(
                              ImageStrings.onlineseva,
                              StringConstant.userDetails,
                              () => Navigator.pushNamed(
                                context,
                                StringsRoute.userDetails,
                              ),
                            ),
                          containerWidget(
                            ImageStrings.ritual,
                            StringConstant.updateRequests,
                            () => Navigator.pushNamed(
                              context,
                              StringsRoute.updateRequestsUrl,
                            ),
                          ),
                          containerWidget(
                            ImageStrings.wowtracker,
                            StringConstant.events,
                            () => Navigator.pushNamed(
                              context,
                              StringsRoute.eventListScreen,
                            ),
                          ),
                          containerWidget(
                            ImageStrings.wowtracker,
                            StringConstant.bookings,
                            () => Navigator.pushNamed(
                              context,
                              StringsRoute.bookings,
                            ),
                          ),

                          containerWidget(
                            ImageStrings.ritual,
                            StringConstant.contacts,
                            () => Navigator.pushNamed(
                              context,
                              StringsRoute.contactUs,
                            ),
                          ),
                          if (role == "Super Admin")
                            containerWidget(
                              ImageStrings.sevaimg,
                              StringConstant.masterTemples,
                              () => Navigator.pushNamed(
                                context,
                                StringsRoute.master_temple_list,
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
          StringConstant.nammaDaivaSmall,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        IconButton(
          padding: EdgeInsets.all(0),
          icon: Image.asset(ImageStrings.logout),
          onPressed: () async {
            await deleteToken();
            Navigator.pushReplacementNamed(context, StringsRoute.login);
          },
        ),
      ],
    );
  }

  Widget welcomeText() {
    return Text(
      StringConstant.welcomeBack,
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
