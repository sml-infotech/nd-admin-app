import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart'; // ensure this defines TimeSlot

class TimeSlotSelector extends StatefulWidget {
  final List<TimeSlot> initialSlots;
  final Function(List<TimeSlot>) onChanged;
  final DateTime? startTime;
  final DateTime? endTime;

  const TimeSlotSelector({
    super.key,
    required this.initialSlots,
    required this.onChanged,
    this.startTime,
    this.endTime,
  });

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  late List<TimeSlot> timeSlots;

  @override
  void initState() {
    super.initState();
    timeSlots = List.from(widget.initialSlots);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }

  Future<TimeOfDay?> _showCustomTimePicker(
    BuildContext context,
    String title,
    TimeOfDay initialTime,
  ) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: title,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              helpTextStyle: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          child: MediaQuery(
            // show 12-hour picker with AM/PM
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );
  }

  Future<void> _pickSlot(BuildContext context) async {
    final now = DateTime.now();

    // pick start time
    final from = await _showCustomTimePicker(
      context,
      "Select Start Time",
      TimeOfDay.now(),
    );
    if (from == null) return;

    final selectedStart = DateTime(
      widget.startTime?.year ?? now.year,
      widget.startTime?.month ?? now.month,
      widget.startTime?.day ?? now.day,
      from.hour,
      from.minute,
    );

    // disallow past times if selecting for today
    if (selectedStart.isBefore(now) &&
        DateUtils.isSameDay(selectedStart, now)) {
      Fluttertoast.showToast(msg: "Start time cannot be in the past");
      return;
    }

    // If a global start/end (widget.startTime/widget.endTime) are provided,
    // ensure selected start lies within that range (if applicable)
    // if (widget.startTime != null &&
    //     widget.endTime != null &&
    //     (selectedStart.isBefore(widget.startTime!) || selectedStart.isAfter(widget.endTime!))) {
    //   Fluttertoast.showToast(msg: "Selected start time must be within the allowed date range");
    //   return;
    // }

    // pick end time (default +1 hour)
    final defaultEndHour = (from.hour + 1) % 24;
    final defaultEnd = from.replacing(hour: defaultEndHour);

    final to = await _showCustomTimePicker(
      context,
      "Select End Time",
      defaultEnd,
    );
    if (to == null) return;

    final selectedEnd = DateTime(
      widget.endTime?.year ?? now.year,
      widget.endTime?.month ?? now.month,
      widget.endTime?.day ?? now.day,
      to.hour,
      to.minute,
    );

    // ensure end > start
    if (!selectedEnd.isAfter(selectedStart)) {
      Fluttertoast.showToast(msg: "End time must be after start time");
      return;
    }

    // If global start/end provided, ensure selected end is within range
    // if (widget.startTime != null &&
    //     widget.endTime != null &&
    //     (selectedEnd.isBefore(widget.startTime!) ||
    //         selectedEnd.isAfter(widget.endTime!))) {
    //   Fluttertoast.showToast(
    //     msg: "Selected end time must be within the allowed date range",
    //   );
    //   return;
    // }

    final slot = TimeSlot(
      fromTime: _formatTimeOfDay(from),
      toTime: _formatTimeOfDay(to),
    );

    setState(() {
      timeSlots.add(slot);
    });

    widget.onChanged(timeSlots);
  }

  void _removeSlot(int index) {
    setState(() {
      timeSlots.removeAt(index);
    });
    widget.onChanged(timeSlots);
  }

  String formatTimeRange(String fromTime, String toTime) {
    try {
      if (fromTime.trim().isEmpty) return "";
      final from = DateFormat("HH:mm:ss").parse(fromTime);
      final formattedFrom = DateFormat("hh:mm a").format(from);

      if (toTime.trim().isEmpty) {
        // show only start time if toTime is empty
        return formattedFrom;
      }

      final to = DateFormat("HH:mm:ss").parse(toTime);
      final formattedTo = DateFormat("hh:mm a").format(to);

      return "$formattedFrom - $formattedTo";
    } catch (e) {
      // Defensive fallback
      if (toTime.trim().isEmpty) return fromTime;
      return "$fromTime - $toTime";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.grey),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onPressed: () => _pickSlot(context),
              child: Text(
                AppLocalizations.of(context)!.add_time_slot,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: font,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(timeSlots.length, (index) {
            final slot = timeSlots[index];
            final label = formatTimeRange(
              slot.fromTime ?? "",
              slot.toTime ?? "",
            );
            return Chip(
              label: Text(label, style: TextStyle(fontFamily: font)),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () => _removeSlot(index),
              backgroundColor: Colors.blue.shade50,
            );
          }),
        ),
      ],
    );
  }
}
