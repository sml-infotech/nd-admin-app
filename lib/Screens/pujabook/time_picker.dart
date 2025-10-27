

import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class TimePickerRow extends StatelessWidget {
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final ValueChanged<TimeOfDay> onFromPicked;
  final ValueChanged<TimeOfDay> onToPicked;

  const TimePickerRow({
    super.key,
    required this.fromTime,
    required this.toTime,
    required this.onFromPicked,
    required this.onToPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildPicker(
              context,
              StringConstant.fromTime,
              fromTime,
              onFromPicked,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPicker(
              context,
              StringConstant.toTime,
              toTime,
              onToPicked,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(
    BuildContext context,
    String label,
    TimeOfDay? time,
    ValueChanged<TimeOfDay> onPick,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time == null ? label : time.format(context),
              style: TextStyle(
                fontFamily: font,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}