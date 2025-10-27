import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDatePicked;
  final String title;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDatePicked,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) onDatePicked(picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? title
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: TextStyle(
                        fontFamily: font,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Image.asset(ImageStrings.calendar, height: 22),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
