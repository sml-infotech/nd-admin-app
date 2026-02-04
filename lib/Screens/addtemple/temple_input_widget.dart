import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class TempleInputWidget extends StatefulWidget {
  final List<String> list; // Pass the specific list (English or Kannada)
  final Function(String) onAdd;
  final Function(int) onRemove;
  final String hintText;

  const TempleInputWidget({
    super.key,
    required this.list,
    required this.onAdd,
    required this.onRemove,
    this.hintText = "Add Temple",
  });

  @override
  _TempleInputWidgetState createState() => _TempleInputWidgetState();
}

class _TempleInputWidgetState extends State<TempleInputWidget> {
  // Local controller so typing in English doesn't show up in Kannada field
  final TextEditingController _localController = TextEditingController();

  void _internalAdd() {
    final text = _localController.text.trim();
    if (text.isNotEmpty) {
      widget.onAdd(text);
      _localController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _localController,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.hintText,
            labelStyle: TextStyle(color: Colors.grey[700], fontFamily: font),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _internalAdd,
            ),
          ),
          onSubmitted: (_) => _internalAdd(),
        ),
        if (widget.list.isNotEmpty) const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            widget.list.length,
            (index) => Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.list[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => widget.onRemove(index),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
