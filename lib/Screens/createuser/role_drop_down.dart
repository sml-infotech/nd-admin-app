import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class CommonDropdownField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final List<String> items;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final double paddingSize;

  const CommonDropdownField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.items,
    this.selectedValue,
    this.onChanged,
    required this.paddingSize,
  });

  @override
  State<CommonDropdownField> createState() => _CommonDropdownFieldState();
}

class _CommonDropdownFieldState extends State<CommonDropdownField> {
  String? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
        child: DropdownButtonFormField<String>(
          value: _currentValue,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
            if (widget.onChanged != null) widget.onChanged!(value);
          },
          style:TextStyle(fontFamily: font, color: Colors.black,fontSize: 15) ,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            labelStyle: TextStyle(fontFamily: font, color: Colors.black),
            hintStyle: TextStyle(fontFamily: font, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          dropdownColor: Colors.white,

          items: widget.items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e, style: TextStyle(fontFamily: font)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
