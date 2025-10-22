import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart'; 
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:provider/provider.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotViewmodel viewmodel ;
  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<ForgotViewmodel>(context);
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                forgotImage(),
                const SizedBox(height: 30),
                const SizedBox(height: 12),
                forgotSubText(),
                const SizedBox(height: 25),
                CommonTextField(hintText: StringConstant.email, labelText: StringConstant.enterUserName, isFromPassword: false, controller: viewmodel.emailController),
                const SizedBox(height: 25),
                resetButton(viewmodel)


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forgotImage() {
    return Image.asset(
      ImageStrings.loginImage,
      height: 70,
      width: 70,
      fit: BoxFit.contain,
    );
  }


  Widget forgotSubText() {
    return Text(
    StringConstant.fogotSubtext  ,
      style: AppTextStyles.otpSubHeadingStyle.copyWith(
        fontSize: 16,
        color: Colors.black54,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

   
}
Widget resetButton(ForgotViewmodel viewmodel) {
  final isButtonEnabled = viewmodel.validateEmail();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isButtonEnabled
            ? () async {
               

              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isButtonEnabled ? ColorConstant.buttonColor : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child:  Text(
                StringConstant.verify,
                style: AppTextStyles.buttonTextStyle,
              ),
      ),
    ),
  );
}