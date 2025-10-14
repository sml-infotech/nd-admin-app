import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            loginImage(),
            const SizedBox(height: 25),
            loginText(),
            const SizedBox(height: 25),
            CommonTextField(
              hintText: StringConstant.enterUserName,
              labelText: StringConstant.userName,
              isFromPassword: false,
              controller:  viewModel.emailController,
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
            const SizedBox(height: 30),
          ],
        ),
      );
    
  }

  Widget loginButton(LoginViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
         viewModel.validateLogin();           
    Fluttertoast.showToast(               
      msg: viewModel.message,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstant.buttonColor,
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
    return Text(
      StringConstant.forgotPassword,
      style: TextStyle(
        fontFamily: font,
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }

  Widget loginImage() {
    return Center(
      child: Image.asset(ImageStrings.loginImage),
    );
  }

  Widget loginText() {
    return Text(
      StringConstant.nammDaivaTitleText,
      style: AppTextStyles.loginTitleStyle,
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
          Expanded(
            child: Text(
              StringConstant.termsAndCondition,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: font,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
 
}
