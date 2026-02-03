import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Common/terms_and_condition.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/local_provider.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/otp_arguments.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginViewModel viewModel;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndShowLanguageDialog();
    });
  }

  Future<void> _checkAndShowLanguageDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final String? language = prefs.getString('language');

    if (language == null || language.isEmpty) {
      showLanguageDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF8F0),
                Color(
                  0xFFFFF8F0,
                ), // same color, can replace with a second for a real gradient
              ],
            ),
          ),
          child: Stack(
            children: [
              leftImage(),
              rightImage(),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child:
                      //  IntrinsicHeight(
                      //   child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          loginImage(),
                          const SizedBox(height: 25),
                          // loginText(),
                          const SizedBox(height: 0),
                          dashBoardText(),
                          const SizedBox(height: 25),
                          CommonTextField(
                            hintText: AppLocalizations.of(
                              context,
                            )!.enterUserName,
                            labelText: AppLocalizations.of(context)!.userName,
                            isFromPassword: false,
                            controller: viewModel.emailController,
                          ),
                          const SizedBox(height: 25),
                          CommonTextField(
                            hintText: AppLocalizations.of(
                              context,
                            )!.enterPassword,
                            labelText: AppLocalizations.of(context)!.password,
                            isFromPassword: true,
                            controller: viewModel.passwordController,
                          ),
                          termAndConditionText(viewModel),
                          const SizedBox(height: 25),
                          loginButton(viewModel),
                          const SizedBox(height: 15),
                          forgotPasswordText(),
                          const SizedBox(height: 15),
                        ],
                      ),
                ),
                // ),
              ),
              if (viewModel.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorConstant.buttonColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffFFF8F0), Color(0xffFFF3E0)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 42, color: Colors.deepOrange),
                const SizedBox(height: 12),

                Text(
                  "Set your primary language",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: font,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                Text(
                  "ನಿಮ್ಮ ಮುಖ್ಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: font,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                _languageCard(
                  title: "English",
                  subtitle: "Continue in English",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    Provider.of<LocaleProvider>(
                      context,
                      listen: false,
                    ).setLocale(const Locale('en'));
                    prefs.setString('language', 'en');

                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 12),

                _languageCard(
                  title: "ಕನ್ನಡ",
                  subtitle: "ಕನ್ನಡದಲ್ಲಿ ಮುಂದುವರಿಯಿರಿ",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    Provider.of<LocaleProvider>(
                      context,
                      listen: false,
                    ).setLocale(const Locale('kn'));
                    prefs.setString('language', 'kn');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.deepOrange),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: font,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontFamily: font,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget loginButton(LoginViewModel viewModel) {
    final isButtonEnabled = viewModel.validateLogin();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isButtonEnabled
              ? () async {
                  FocusScope.of(context).unfocus();
                  await viewModel.login();
                  Fluttertoast.showToast(
                    msg: viewModel.message,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                  if (viewModel.isLoginSuccess) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      StringsRoute.dashboard,
                      (Route<dynamic> route) => false,
                    );
                    viewModel.reset();
                  }

                  viewModel.message = '';
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled
                ? ColorConstant.buttonColor
                : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.login,
            style: AppTextStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordText() {
    return GestureDetector(
      onTap: () {
        viewModel.reset();
        Navigator.pushNamed(context, StringsRoute.forgotPassword);
      },
      child: Text(
        AppLocalizations.of(context)!.forgotPassword,
        style: TextStyle(fontFamily: font, fontSize: 12, color: Colors.black),
      ),
    );
  }

  Widget loginImage() {
    return Center(child: Image.asset(ImageStrings.logo));
  }

  Widget leftImage() {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(0, 60, 0, 0),
      child: Image.asset(
        ImageStrings.leftImage,
        color: Colors.amber.withOpacity(0.6),
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

  Widget loginText() {
    return Text(
      AppLocalizations.of(context)!.nammDaivaTitleText,
      style: AppTextStyles.loginTitleStyle,
    );
  }

  Widget dashBoardText() {
    return Text(
      AppLocalizations.of(context)!.dashboard,
      style: AppTextStyles.loginSubTitleStyle,
    );
  }

  Widget termAndConditionText(LoginViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            activeColor: ColorConstant.buttonColor,
            value: viewModel.isChecked,
            onChanged: (value) {
              viewModel.toggleCheckbox(value);
            },
          ),
          TermsAndConditionText(font: font),
        ],
      ),
    );
  }
}
