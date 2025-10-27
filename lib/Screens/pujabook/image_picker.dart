
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class UploadImageBox extends StatelessWidget {
  final VoidCallback onTap;

  const UploadImageBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringConstant.uploadText,
            style: AppTextStyles.editTempleTitleStyle,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Image.asset(ImageStrings.uploadImg),
                  const SizedBox(height: 8),
                  Text(
                    StringConstant.uploadImageSeva,
                    style: TextStyle(fontFamily: font, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}