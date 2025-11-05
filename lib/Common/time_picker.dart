import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';

class SingleTimePicker extends StatefulWidget {
  final TimeSlot? initialValue;
  final Function(TimeSlot) onChanged;

  const SingleTimePicker({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<SingleTimePicker> createState() => _SingleTimePickerState();
}

class _SingleTimePickerState extends State<SingleTimePicker> {
  late String fromTime;
  late String toTime;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    fromTime = widget.initialValue?.fromTime ?? '';
    toTime = widget.initialValue?.toTime ?? '';

    // If start time is set but no end time, auto add +1 hour
    if (fromTime.isNotEmpty && toTime.isEmpty) {
      final start = _parseTime(fromTime);
      final oneHourLater = start.add(const Duration(hours: 1));
      toTime = DateFormat('hh:mm a').format(oneHourLater);
    }
  }

  @override
  void didUpdateWidget(covariant SingleTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null) {
      setState(() {
        fromTime = widget.initialValue!.fromTime;
        toTime = widget.initialValue!.toTime;
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formatted = _formatTime(picked);

      setState(() {
        if (isStart) {
          fromTime = formatted;

          // Auto set end time = start time + 1 hour if end not set
          final start = _parseTime(fromTime);
          final oneHourLater = start.add(const Duration(hours: 1));
          toTime = DateFormat('hh:mm a').format(oneHourLater);
        } else {
          toTime = formatted;
        }
      });

      _validateTimes();
      widget.onChanged(TimeSlot(fromTime: fromTime, toTime: toTime));
    }
  }

  void _validateTimes() {
    if (fromTime.isNotEmpty && toTime.isNotEmpty) {
      final start = _parseTime(fromTime);
      final end = _parseTime(toTime);
      final diff = end.difference(start).inMinutes;

      if (diff < 60) {
        setState(() {
          toTime = "";
          _errorText = "End time should be at least 1 hour after start time.";
        });
      } else {
        setState(() {
          _errorText = null;
        });
      }
    }
  }

  DateTime _parseTime(String time) {
    final now = DateTime.now();
    return DateFormat(
      'hh:mm a',
    ).parse(time).copyWith(year: now.year, month: now.month, day: now.day);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Start time box
            Expanded(
              child: InkWell(
                onTap: () => _pickTime(isStart: true),
                child: _timeBox(
                  label: fromTime.isNotEmpty ? fromTime : 'Start Time',
                  icon: Icons.access_time,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // End time box
            Expanded(
              child: InkWell(
                onTap: () => _pickTime(isStart: false),
                child: _timeBox(
                  label: toTime.isNotEmpty ? toTime : 'End Time',
                  icon: Icons.access_time,
                  isError: _errorText != null,
                ),
              ),
            ),
          ],
        ),

        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontFamily: font,
              ),
            ),
          ),
      ],
    );
  }

  Widget _timeBox({
    required String label,
    required IconData icon,
    bool isError = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: isError ? Colors.red : Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: font,
              color: Colors.grey,
            ),
          ),
          Icon(icon, color: Colors.grey.shade600, size: 20),
        ],
      ),
    );
  }
}
