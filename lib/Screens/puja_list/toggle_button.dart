import 'package:flutter/material.dart';

class SmallToggleSwitch extends StatefulWidget {
  final bool value; // ✅ current value from parent
  final ValueChanged<bool> onChanged;

  const SmallToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SmallToggleSwitch> createState() => _SmallToggleSwitchState();
}

class _SmallToggleSwitchState extends State<SmallToggleSwitch> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.value; // ✅ initialize with parent value
  }

  @override
  void didUpdateWidget(covariant SmallToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() => isOn = widget.value); // ✅ update when parent changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.7,
      child: Switch(
        value: isOn,
        onChanged: (value) {
          setState(() => isOn = value);
          widget.onChanged(value); // ✅ notify parent
        },
        activeColor: Colors.green,
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }
}
