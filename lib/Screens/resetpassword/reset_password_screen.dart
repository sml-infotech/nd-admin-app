import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/resetpassword/reset_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<ResetViewmodel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _buildAppBar(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: screenHeight - kToolbarHeight,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _resetImage(),
                    const SizedBox(height: 20),
                    _resetSubText(),
                    const SizedBox(height: 28),
                    CommonTextField(
                      hintText: StringConstant.password,
                      labelText: StringConstant.enterPassword,
                      isFromPassword: true,
                      controller: viewmodel.password,
                    ),
                    const SizedBox(height: 18),
                    CommonTextField(
                      hintText: StringConstant.password,
                      labelText: StringConstant.enterConfirmPassword,
                      isFromPassword: true,
                      controller: viewmodel.confirmPassword,
                    ),
                    const SizedBox(height: 30),
                    _resetButton(viewmodel),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),

          if (viewmodel.isLoading)
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
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(
          StringConstant.resetPassword,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _resetImage() {
    return Image.asset(
      ImageStrings.loginImage,
      height: 70,
      width: 70,
      fit: BoxFit.contain,
    );
  }

  Widget _resetSubText() {
    return Text(
      StringConstant.resetSubText,
      style: AppTextStyles.otpSubHeadingStyle.copyWith(
        fontSize: 16,
        color: Colors.black54,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _resetButton(ResetViewmodel viewmodel) {
    final isButtonEnabled = viewmodel.validatePasswords();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 0),
        child: ElevatedButton(
          onPressed: isButtonEnabled
              ? () async {
                  await viewmodel.resetPassword();
                  Fluttertoast.showToast(msg: viewmodel.message);
                  if (viewmodel.isPasswordUpdated) {
                    Navigator.pushReplacementNamed(context, StringsRoute.login);
                  }
                  setState(() {
                    viewmodel.message = "";
                  });
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
            StringConstant.reset,
            style: AppTextStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}
