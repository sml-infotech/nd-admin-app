import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDatePicked;
  final String title;
  final DateTime? fromDate; // For end-date validation (start date)

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDatePicked,
    required this.title,
    this.fromDate,
  });

  bool get _isEndDate => fromDate != null; // Helps us know if this is "To Date" field

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
                final now = DateTime.now();

                // Determine valid range
                final DateTime firstDate = _isEndDate
                    ? fromDate!.add(const Duration(days: 0)) // End date must be >= start date
                    : now;

                final DateTime initialDate =
                    selectedDate != null && selectedDate!.isAfter(firstDate)
                        ? selectedDate!
                        : firstDate;

                final picked = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: DateTime(2030),
                );

                if (picked != null) {
                  // If this is End Date picker, ensure picked date >= fromDate
                  if (_isEndDate && picked.isBefore(fromDate!)) {
                    Fluttertoast.showToast(
                      msg: "End date must be after start date",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }

                  onDatePicked(picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                        color: selectedDate == null ? Colors.grey : Colors.black,
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
