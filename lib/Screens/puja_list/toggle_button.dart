import 'package:flutter/material.dart';

class SmallToggleSwitch extends StatefulWidget {
  final Function onChanged;
  const SmallToggleSwitch({super.key,required this.onChanged});

  @override
  State<SmallToggleSwitch> createState() => _SmallToggleSwitchState();
}

class _SmallToggleSwitchState extends State<SmallToggleSwitch> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.7, 
      child: Switch(
        value: isOn,
        onChanged: (value) {
          setState(() {
            isOn = value;
            widget.onChanged(value);
          });
        },
        activeColor: Colors.green,
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }
}
