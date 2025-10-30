import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart'; // <-- ensure this has TimeSlot

class TimeSlotSelector extends StatefulWidget {
  final List<TimeSlot> initialSlots;
  final Function(List<TimeSlot>) onChanged;

  const TimeSlotSelector({
    super.key,
    required this.initialSlots,
    required this.onChanged,
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

  Future<void> _pickSlot(BuildContext context) async {
    final from = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (from == null) return;

    final to = await showTimePicker(
      context: context,
      initialTime: from.replacing(hour: (from.hour + 1) % 24),
    );
    if (to == null) return;

    // Validation
    final fromMinutes = from.hour * 60 + from.minute;
    final toMinutes = to.hour * 60 + to.minute;
    if (toMinutes <= fromMinutes) {
      Fluttertoast.showToast(msg: "End time must be after start time");
      return;
    }

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

  String _formatDisplay(String timeStr) {
    // convert "HH:mm:ss" → "HH:mm"
    final parts = timeStr.split(':');
    return "${parts[0]}:${parts[1]}";
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
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.grey),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onPressed: () => _pickSlot(context),
              icon: const Icon(Icons.add),
              label: Text(
                "Add Time Slot",
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
            return Chip(
              label: Text(
                "${_formatDisplay(slot.fromTime)} - ${_formatDisplay(slot.toTime)}",
                style: TextStyle(fontFamily: font),
              ),
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
