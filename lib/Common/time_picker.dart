import 'package:flutter/material.dart';

class TimeSlot {
  DateTime startTime;
  DateTime endTime;

  TimeSlot({required this.startTime, required this.endTime});
  
  TimeSlot copyWith({DateTime? startTime, DateTime? endTime}) {
    return TimeSlot(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  final Function(TimeSlot) onTimeChanged;
  final TimeSlot initialTimeSlot;

  const TimePickerWidget({
    Key? key,
    required this.onTimeChanged,
    required this.initialTimeSlot,
  }) : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeSlot timeSlot;

  @override
  void initState() {
    super.initState();
    timeSlot = widget.initialTimeSlot;
  }

  Future<void> _pickTime(bool isStartTime) async {
    // Get the current time depending on whether it's the start or end time.
    final currentTime = isStartTime ? timeSlot.startTime : timeSlot.endTime;
    final TimeOfDay initialTime = TimeOfDay.fromDateTime(currentTime);

    // Show the time picker dialog
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      // Create a new DateTime object based on the selected time
      final DateTime newTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        if (isStartTime) {
          timeSlot = timeSlot.copyWith(startTime: newTime);
        } else {
          timeSlot = timeSlot.copyWith(endTime: newTime);
        }
        widget.onTimeChanged(timeSlot); // Notify the parent with the updated times
      });
    }
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Start Time Field
        Expanded(
          child: InkWell(
            onTap: () => _pickTime(true),  // True for Start Time
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Start Time",
                  hintText: _formatTime(timeSlot.startTime),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        
        // End Time Field
        Expanded(
          child: InkWell(
            onTap: () => _pickTime(false), // False for End Time
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "End Time",
                  hintText: _formatTime(timeSlot.endTime),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
