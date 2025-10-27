import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class CheckBoxRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CheckBoxRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: ColorConstant.buttonColor,
        ),
        Expanded(child: Text(label, style: AppTextStyles.templeContactStyle)),
      ],
    );
  }
}