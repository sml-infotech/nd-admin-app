import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
class OtpInputField extends StatefulWidget {
  final Function(String) onChanged; // <-- changed

  const OtpInputField({super.key, required this.onChanged});

  void clearOtp(GlobalKey<OtpInputFieldState> key) {
    key.currentState?.clearFields();
  }

  @override
  State<OtpInputField> createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField> {
  final int length = 4;

  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

void clearFields() {
  for (var c in _controllers) {
    c.clear();
  }
  _focusNodes[0].requestFocus();
  widget.onChanged(""); // reset parent value
}

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(length, (_) => FocusNode());
    _controllers = List.generate(length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Combine all OTP boxes to a single string
    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged(otp); // <-- call every time
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15,
        children: List.generate(length, (index) {
          return SizedBox(
            width: 50,
            height: 50,
            child: TextField(
              cursorColor: ColorConstant.buttonColor,
              cursorHeight: 25,
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: AppTextStyles.otpEmailStyle,
              decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorConstant.buttonColor),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => _onChanged(value, index),
            ),
          );
        }),
      ),
    );
  }
}
