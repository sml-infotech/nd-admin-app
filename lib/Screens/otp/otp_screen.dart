
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_textfield.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart' show ImageStrings;
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class OtpScreen extends StatefulWidget {
    final int seconds;

  const OtpScreen({super.key, this.seconds = 10});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = "";
  late int remainingSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.seconds;
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
      }
    });
  }

    String get timerText {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
          const SizedBox(height: 50),
          otpTitle(),
          const SizedBox(height: 20),
          otpImage(),
          const SizedBox(height: 20),
          otpSubTitle(),
          const SizedBox(height: 10),
          userEmailText(),
          const SizedBox(height: 30),
         OtpInputField(
         onChanged: (otp) {
         print("Entered OTP: $otp");
          setState(() {
            _otp = otp;
          });
          },
        ),
          const SizedBox(height: 30),
          verifyButton(_otp),
          const SizedBox(height: 20),
          Row(children: [
            const SizedBox(width: 20),
            resendCodeText(),
          Spacer(),
          timerTextWidget(timerText),
          const SizedBox(width: 20),
 ],)

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

Widget timerTextWidget(String timerText) {
    return Text(
      timerText,
      style:AppTextStyles.otpEmailStyle ,
    );
  }

Widget verifyButton(String _otp) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child:ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffF38739), 
      disabledBackgroundColor: Colors.grey,   
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    onPressed: _otp.length == 4
        ? () {
            print("OTP Verified: $_otp");
          }
        : null, 
    child: Text(
      'Verify',
      style: AppTextStyles.buttonTextStyle,
    ),
  ),
          ),
        );
  }

Widget resendCodeText() {
    return  GestureDetector(
      onTap: remainingSeconds == 0 ? () {
        setState(() {
          remainingSeconds = widget.seconds;
        });
        startTimer();
      } : null,
      child:
    Text(
     StringConstant.resend ,
      style:remainingSeconds==0?AppTextStyles.resendEnableCodeStyle:  AppTextStyles.resendCodeStyle,
    ));
  }

}



