import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_textfield.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart'
    show ImageStrings;
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/otp_arguments.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final int seconds;
  final OtpArguments arguments;

  const OtpScreen({super.key, this.seconds = 10, required this.arguments});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpViewmodel viewModel = OtpViewmodel();
  late int remainingSeconds;
  final GlobalKey<OtpInputFieldState> otpKey = GlobalKey<OtpInputFieldState>();

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.seconds;
    startTimer();
  }

  void startTimer() {
    viewModel.timer?.cancel();
    viewModel.timer = Timer.periodic(const Duration(seconds: 1), (t) {
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

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        backbutton(),
                        const SizedBox(height: 100),
                        otpTitle(),
                        const SizedBox(height: 20),
                        otpImage(),
                        const SizedBox(height: 20),
                        otpSubTitle(),
                        const SizedBox(height: 10),
                        userEmailText(widget.arguments.email),
                        const SizedBox(height: 30),
                        OtpInputField(
                          key: otpKey,
                          onChanged: (otp) {
                            setState(() {
                              viewModel.otp = otp;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        verifyButton(viewModel.otp),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            resendCodeText(
                              widget.arguments.email,
                              widget.arguments.password,
                            ),
                            Spacer(),
                            timerTextWidget(timerText),
                            const SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
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

  Widget otpTitle() {
    return Text(
      AppLocalizations.of(context)!.verificationCode,
      style: AppTextStyles.otpDetailHeadingStyle,
    );
  }

  Widget backbutton() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget otpImage() {
    return Image.asset(ImageStrings.otpImage, height: 150, width: 150);
  }

  Widget otpSubTitle() {
    return Text(
      AppLocalizations.of(context)!.otpSubTitle,
      style: AppTextStyles.otpSubHeadingStyle,
    );
  }

  Widget userEmailText(String email) {
    return Text(email, style: AppTextStyles.otpEmailStyle);
  }

  Widget timerTextWidget(String timerText) {
    return Text(timerText, style: AppTextStyles.otpEmailStyle);
  }

  Widget verifyButton(String _otp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstant.buttonColor,
            disabledBackgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: _otp.length == 4
              ? () async {
                  FocusScope.of(context).unfocus();
                  await viewModel.validOtp(widget.arguments.email);
                  Fluttertoast.showToast(
                    msg: viewModel.message,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                  if (viewModel.isOtpSuccess) {
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
            AppLocalizations.of(context)!.verify,
            style: AppTextStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }

  Widget resendCodeText(String email, String password) {
    return GestureDetector(
      onTap: remainingSeconds == 0
          ? () async {
              otpKey.currentState?.clearFields();

              setState(() {
                remainingSeconds = widget.seconds;
                viewModel.otp = "";
              });
              startTimer();
              await viewModel.resendOtp(email, password);
              Fluttertoast.showToast(msg: viewModel.message);
              setState(() {
                viewModel.message = '';
              });
            }
          : null,
      child: Text(
        AppLocalizations.of(context)!.resend,
        style: remainingSeconds == 0
            ? AppTextStyles.resendEnableCodeStyle
            : AppTextStyles.resendCodeStyle,
      ),
    );
  }
}
