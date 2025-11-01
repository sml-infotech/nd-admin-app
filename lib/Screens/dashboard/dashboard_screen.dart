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
    _loadUserData(); // ✅ Fetch SharedPreferences data when screen loads
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('authToken');
    final storedRole = prefs.getString('userRole');

    setState(() {
      token = storedToken;
      role = storedRole;
    });
  }

    Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.remove('authToken');
    final storedRole = prefs.remove('userRole');

    
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaAppBar(),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),

          // ✅ Expanded section
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      welcomeText(),
                      const SizedBox(height: 15),
                      templeNameText(),
                      const SizedBox(height: 10),

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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          
                          contaierWidgets(
                            ImageStrings.templeImage,
                            StringConstant.templeDetailText,
                            () {
                              Navigator.pushNamed(
                                  context, StringsRoute.templeScreen);
                            },
                          ),
                      SizedBox(width: 5),
                          contaierWidgets(
                            ImageStrings.sevaimg,
                            StringConstant.sevaText,
                            () {
                              Navigator.pushNamed(
                                  context, StringsRoute.pujaList);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if(role=="Super Admin"||role =="Admin")
                          contaierWidgets(
                            ImageStrings.onlineseva,
                            StringConstant.createUser,
                            () {
                              Navigator.pushNamed(context,StringsRoute.userDetails );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
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

  // 🔹 AppBar
  Widget nammaDaivaAppBar() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          StringConstant.nammaDaivaSmall,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        IconButton(
          icon: Image.asset(ImageStrings.logout),
          onPressed: () async {
        await   deleteToken();
            Navigator.pushReplacementNamed(context, StringsRoute.login);

          },
        ),
      ],
    );
  }

  // 🔹 Text Widgets
  Widget welcomeText() {
    return Text(
      StringConstant.welcomeBack,
      style: AppTextStyles.welcomeStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget templeNameText() {
    return Text(
      "Arulmigu Arunachaleswarar Temple",
      style: AppTextStyles.templeNameStyle,
      textAlign: TextAlign.center,
    );
  }

  // 🔹 Container Widget
  Widget contaierWidgets(String image, String title, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 156,
        width: 170,
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
                padding: const EdgeInsets.symmetric(horizontal: 14),
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
