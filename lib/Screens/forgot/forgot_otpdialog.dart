import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_textfield.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:provider/provider.dart';

class OtpDialog extends StatefulWidget {
  final String email;
  final String password;

  const OtpDialog({super.key, required this.email, required this.password});

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  late OtpViewmodel viewModel;
  String otp = '';
  int remainingSeconds = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<OtpViewmodel>(context, listen: false);
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    remainingSeconds = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(StringConstant.verificationCode,
                      style: AppTextStyles.otpDetailHeadingStyle,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Text(StringConstant.otpSubTitle,
                      style: AppTextStyles.otpSubHeadingStyle,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(widget.email,
                      style: AppTextStyles.otpEmailStyle,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  OtpInputField(
                    onChanged: (value) => setState(() => otp = value),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: otp.length == 4
                          ? () async {
                              // await viewModel.validOtp(widget.email, otp);
                              Fluttertoast.showToast(
                                  msg: viewModel.message,
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white);
                              if (viewModel.isOtpSuccess) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, StringsRoute.templeScreen, (route) => false);
                              }
                              setState(() {
                                viewModel.message = '';
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            otp.length == 4 ? const Color(0xffF38739) : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(StringConstant.verify,
                          style: AppTextStyles.buttonTextStyle),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: remainingSeconds == 0
                            ? () async {
                                startTimer();
                                await viewModel.resendOtp(widget.email, widget.password);
                                Fluttertoast.showToast(msg: viewModel.message);
                                setState(() {
                                  viewModel.message = '';
                                });
                              }
                            : null,
                        child: Text(
                          StringConstant.resend,
                          style: remainingSeconds == 0
                              ? AppTextStyles.resendEnableCodeStyle
                              : AppTextStyles.resendCodeStyle,
                        ),
                      ),
                      Text("00:${remainingSeconds.toString().padLeft(2, '0')}",
                          style: AppTextStyles.otpEmailStyle),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // Close button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
