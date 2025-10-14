
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_textfield.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart' show ImageStrings;
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          const SizedBox(height: 100),
          otpTitle(),
          const SizedBox(height: 20),
         otpImage(),
          const SizedBox(height: 20),
          otpSubTitle(),
          const SizedBox(height: 10),
          userEmailText(),
          const SizedBox(height: 30),
         OtpInputField(
         onCompleted: (otp) {
         print("Entered OTP: $otp");
  },
),

        ]),
      
      ),
    );
  }

  Widget otpTitle() {
    return Text(
      StringConstant.verificationCode,
      style:AppTextStyles.otpDetailHeadingStyle ,
    );
  }

  Widget otpImage() {
    return Image.asset(
   ImageStrings.otpImage,
      height: 150,
      width: 150,
    );
  }

  Widget otpSubTitle() {
    return Text(
      StringConstant.otpSubTitle,
      style:AppTextStyles.otpSubHeadingStyle ,
    );
  }

  Widget userEmailText() {
    return Text("abc@gmail.com", style:AppTextStyles.otpEmailStyle ,
      );
}


}



