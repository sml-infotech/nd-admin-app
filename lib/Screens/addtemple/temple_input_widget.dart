import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class TempleInputWidget extends StatefulWidget {
  final dynamic viewmodel; // Can be AddTempleViewmodel or UpdateTempleViewmodel
  final bool isUpdateMode; // true when coming from update screen

  const TempleInputWidget({
    super.key,
    required this.viewmodel,
    this.isUpdateMode = false,
  });

  @override
  State<TempleInputWidget> createState() => _TempleInputWidgetState();
}

class _TempleInputWidgetState extends State<TempleInputWidget> {
  @override
  void initState() {
    super.initState();

    // Prefill existing temples if in update mode
    if (widget.isUpdateMode && widget.viewmodel.prefilledTemples != null) {
      // assuming your UpdateTempleViewmodel has a List<String> prefilledTemples
      widget.viewmodel.temples = List<String>.from(widget.viewmodel.prefilledTemples);
    }
  }

  void _addTemple() {
    String text = widget.viewmodel.templeController.text.trim();
    if (text.isNotEmpty) {
      widget.viewmodel.addTemple(text);
      widget.viewmodel.templeController.clear();
      setState(() {}); // refresh UI after adding
    }
  }

  void _removeTemple(int index) {
    widget.viewmodel.removeTemple(index);
    setState(() {}); // refresh UI after removing
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewmodel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: vm.templeController,
          decoration: InputDecoration(
            hintText: "Add Deities",
            labelText: "Add Deities",
            labelStyle: TextStyle(fontFamily: font, color: Colors.grey),
            hintStyle: TextStyle(fontFamily: font, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTemple,
            ),
          ),
          onSubmitted: (_) => _addTemple(),
        ),

        const SizedBox(height: 15),

        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            vm.temples.length,
            (index) => Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      vm.temples[index],
                      style: TextStyle(fontFamily: font, color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeTemple(index),
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
