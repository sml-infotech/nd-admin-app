
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_textfield.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart' show ImageStrings;
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/otp_arguments.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
    final int seconds;
    final OtpArguments arguments;

  const OtpScreen({super.key, this.seconds = 10,required this.arguments});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
     OtpViewmodel viewModel=OtpViewmodel();
    late int remainingSeconds;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.seconds;
    startTimer();
  }

  void startTimer() {
   viewModel. timer?.cancel();
   viewModel.  timer = Timer.periodic(const Duration(seconds: 1), (t) {
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
        viewModel = Provider.of<OtpViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
 Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
          const SizedBox(height: 50),
          otpTitle(),
          const SizedBox(height: 20),
          otpImage(),
          const SizedBox(height: 20),
          otpSubTitle(),
          const SizedBox(height: 10),
          userEmailText(widget.arguments.email),
          const SizedBox(height: 30),
         OtpInputField(
         onChanged: (otp) {
          setState(() {
          viewModel.  otp = otp;
          });
          },
        ),
          const SizedBox(height: 30),
          verifyButton(viewModel. otp),
          const SizedBox(height: 20),
          Row(children: [
            const SizedBox(width: 20),
            resendCodeText(widget.arguments.email, widget.arguments.password),
          Spacer(),
          timerTextWidget(timerText),
          const SizedBox(width: 20),
            ],)
            ]),
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
      ],)
      
     
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

  Widget userEmailText(String email) {
    return Text(email, style:AppTextStyles.otpEmailStyle ,
      );
}

Widget timerTextWidget(String timerText) {
    return Text(
      timerText,
      style:AppTextStyles.otpEmailStyle ,
    );
  }

Widget verifyButton(String _otp,) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child:ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorConstant.buttonColor, 
      disabledBackgroundColor: Colors.grey,   
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    onPressed: _otp.length == 4
        ? () async {
     await  viewModel.validOtp(widget.arguments.email);
     Fluttertoast.showToast(msg: viewModel.message,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
   if(viewModel.isOtpSuccess){
Navigator.pushNamedAndRemoveUntil(
  context, 
  StringsRoute.dashboard, 
  (Route<dynamic> route) => false, 
);
   }
    setState(() {
      viewModel.message = '';
    });
          }
        : null, 
    child: Text(
     StringConstant.verify ,
      style: AppTextStyles.buttonTextStyle,
    ),
  ),
          ),
        );
  }

Widget resendCodeText(String email,String password) {
    return  GestureDetector(
      onTap: remainingSeconds == 0 ? () async {
        setState(()  {
          remainingSeconds = widget.seconds;
        });
        startTimer();
                await  viewModel.resendOtp(email, password);
      Fluttertoast.showToast(msg: viewModel.message,);
        setState(() {
          viewModel.message = '';
        });

      } : null,
      child:
    Text(
     StringConstant.resend ,
      style:remainingSeconds==0?AppTextStyles.resendEnableCodeStyle:  AppTextStyles.resendCodeStyle,
    ));
  }

}



