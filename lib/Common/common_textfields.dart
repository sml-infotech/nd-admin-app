import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class CommonTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final bool isFromPassword;
  final TextEditingController controller;
  final bool? isFromPhone;
  final bool? isFromDescription; // new flag for multi-line text

  const CommonTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.isFromPassword,
    required this.controller,
    this.isFromPhone,
    this.isFromDescription,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isFromDescription == true ? 150 : 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          keyboardType: widget.isFromDescription == true
              ? TextInputType.multiline
              : (widget.isFromPhone ?? false ? TextInputType.phone : TextInputType.text),
          maxLines: widget.isFromDescription == true ? 5 : 1, 
          inputFormatters: widget.isFromPhone == true
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
          controller: widget.controller,
          style: TextStyle(fontFamily: font),
          obscureText: widget.isFromPassword ? _obscureText : false,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            labelStyle: TextStyle(fontFamily: font, color: Colors.grey),
            hintStyle: TextStyle(fontFamily: font, color: Colors.black),
            suffixIcon: widget.isFromPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: ColorConstant.eyeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
