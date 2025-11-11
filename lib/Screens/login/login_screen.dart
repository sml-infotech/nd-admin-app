import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Common/terms_and_condition.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/otp_arguments.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 75),
                      loginImage(),
                      const SizedBox(height: 25),
                      loginText(),
                      const SizedBox(height: 0),
                      dashBoardText(),
                      const SizedBox(height: 25),

                      CommonTextField(
                        hintText: StringConstant.enterUserName,
                        labelText: StringConstant.userName,
                        isFromPassword: false,
                        controller: viewModel.emailController,
                      ),
                      const SizedBox(height: 25),
                      CommonTextField(
                        hintText: StringConstant.enterPassword,
                        labelText: StringConstant.password,
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
              ),
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
                    Navigator.pushNamed(
                      context,
                      StringsRoute.otpScreen,
                      arguments: OtpArguments(
                        email: viewModel.emailController.text,
                        password: viewModel.passwordController.text,
                        isFromCreateUser: false,
                      ),
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
            StringConstant.login,
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
        StringConstant.forgotPassword,
        style: TextStyle(fontFamily: font, fontSize: 12, color: Colors.black),
      ),
    );
  }

  Widget loginImage() {
    return Center(child: Image.asset(ImageStrings.loginImage));
  }

  Widget loginText() {
    return Text(
      StringConstant.nammDaivaTitleText,
      style: AppTextStyles.loginTitleStyle,
    );
  }

  Widget dashBoardText() {
    return Text(
      StringConstant.dashboard,
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
            activeColor: Colors.grey,
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
