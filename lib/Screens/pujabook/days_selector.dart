import 'package:flutter/material.dart';

class DaysSelector extends StatefulWidget {
  final Map<String, bool> initialDays;
  final Function(Map<String, bool>) onChanged;

  const DaysSelector({
    super.key,
    required this.initialDays,
    required this.onChanged,
  });

  @override
  State<DaysSelector> createState() => _DaysSelectorState();
}

class _DaysSelectorState extends State<DaysSelector> {
  late Map<String, bool> selectedDays;

  final List<String> daysOrder = ['M', 'Th', 'W', 'Tu', 'F', 'S', 'Su'];

  @override
  void initState() {
    super.initState();
    selectedDays = Map<String, bool>.from(widget.initialDays);
  }

  void toggleDay(String day) {
    setState(() {
      selectedDays[day] = !(selectedDays[day] ?? false);
    });
    widget.onChanged(selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: daysOrder.map((day) {
        final bool isSelected = selectedDays[day] ?? false;
        return GestureDetector(
          onTap: () => toggleDay(day),
          child: AnimatedContainer(
            width: 30,
            height: 30,
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.grey[200],
              borderRadius: BorderRadius.circular(100),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        blurRadius: 6,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}