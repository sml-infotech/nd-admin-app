import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_textfield.dart';
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
  late ForgotViewmodel viewModel;
  int remainingSeconds = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ForgotViewmodel>(context, listen: false);
    startTimer();
  }

  /// =======================
  /// Timer logic
  /// =======================
  void startTimer() {
    timer?.cancel();
    remainingSeconds = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// =======================
  /// OTP verification logic
  /// =======================
  Future<void> verifyOtp() async {
    viewModel.isVerifyLoading = true;
    await viewModel.validOtp(widget.email);

    Fluttertoast.showToast(
      msg: viewModel.message,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );

    if (viewModel.isOtpSuccess) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, StringsRoute.resetPassword);
      viewModel.isOtpSuccess = false;
    }

    setState(() {
      viewModel.message = '';
    });
  }

  /// =======================
  /// Resend OTP logic
  /// =======================
  Future<void> resendOtp() async {
    startTimer();
    await viewModel.forgotPasswordApi();
    Fluttertoast.showToast(msg: viewModel.message);
    setState(() => viewModel.message = '');
  }

  /// =======================
  /// OTP Input Field Widget
  /// =======================
  Widget buildOtpInputField() {
    return OtpInputField(
      onChanged: (value) => setState(() => viewModel.otp = value),
    );
  }

  /// =======================
  /// Verify Button Widget
  /// =======================
  Widget buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: viewModel.otp.length == 4 ? verifyOtp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: viewModel.otp.length == 4
              ? ColorConstant.buttonColor
              : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          StringConstant.verify,
          style: AppTextStyles.buttonTextStyle,
        ),
      ),
    );
  }

  /// =======================
  /// Resend Row Widget
  /// =======================
  Widget buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: remainingSeconds == 0 ? resendOtp : null,
          child: Text(
            StringConstant.resend,
            style: remainingSeconds == 0
                ? AppTextStyles.resendEnableCodeStyle
                : AppTextStyles.resendCodeStyle,
          ),
        ),
        Text(
          "00:${remainingSeconds.toString().padLeft(2, '0')}",
          style: AppTextStyles.otpEmailStyle,
        ),
      ],
    );
  }

  /// =======================
  /// Loading Overlay
  /// =======================
  Widget buildLoadingOverlay() {
    if (!viewModel.isVerifyLoading) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: CircularProgressIndicator(color: ColorConstant.buttonColor),
        ),
      ),
    );
  }

  /// =======================
  /// Main Dialog Content
  /// =======================
  Widget buildDialogContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              StringConstant.verificationCode,
              style: AppTextStyles.otpDetailHeadingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              StringConstant.otpSubTitle,
              style: AppTextStyles.otpSubHeadingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              widget.email,
              style: AppTextStyles.otpEmailStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            buildOtpInputField(),
            const SizedBox(height: 30),
            buildVerifyButton(),
            const SizedBox(height: 20),
            buildResendRow(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          buildDialogContent(),

          // Close Button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Loading Overlay
          buildLoadingOverlay(),
        ],
      ),
    );
  }
}
