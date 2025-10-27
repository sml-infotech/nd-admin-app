import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class TimePickerRow extends StatelessWidget {
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final ValueChanged<TimeOfDay> onFromPicked;
  final ValueChanged<TimeOfDay> onToPicked;
  final DateTime? fromDate;
  final DateTime? toDate;

  const TimePickerRow({
    super.key,
    required this.fromTime,
    required this.toTime,
    required this.onFromPicked,
    required this.onToPicked,
    required this.fromDate,
    required this.toDate,
  });

  bool get _datesSelected => fromDate != null && toDate != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildPicker(
              context,
              label: StringConstant.fromTime,
              time: fromTime,
              onPick: onFromPicked,
              isFromTime: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPicker(
              context,
              label: StringConstant.toTime,
              time: toTime,
              onPick: onToPicked,
              isFromTime: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(
    BuildContext context, {
    required String label,
    required TimeOfDay? time,
    required ValueChanged<TimeOfDay> onPick,
    required bool isFromTime,
  }) {
    final isEnabled = _datesSelected;

    return GestureDetector(
      onTap: isEnabled
          ? () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time ?? TimeOfDay.now(),
              );

              if (picked != null) {
                // Validate only if this is the "to" picker and same-day
                if (!isFromTime && fromTime != null && fromDate != null && toDate != null) {
                  final sameDay = fromDate!.year == toDate!.year &&
                      fromDate!.month == toDate!.month &&
                      fromDate!.day == toDate!.day;

                  final fromMinutes = fromTime!.hour * 60 + fromTime!.minute;
                  final toMinutes = picked.hour * 60 + picked.minute;

                  if (sameDay && toMinutes <= fromMinutes) {
                    Fluttertoast.showToast(
                      msg: "End time must be later than start time on the same day",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }
                }

                onPick(picked);
              }
            }
          : () {
              Fluttertoast.showToast(
                msg: "Please select From Date and To Date first",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5, // visual feedback for disabled
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
            color: isEnabled ? Colors.white : Colors.grey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time == null ? label : time.format(context),
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 15,
                  color: isEnabled
                      ? (time == null ? Colors.grey : Colors.black)
                      : Colors.grey,
                ),
              ),
              const Icon(Icons.access_time, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
