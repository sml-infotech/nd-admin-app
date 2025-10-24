import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class TempleInputWidget extends StatefulWidget {
  const TempleInputWidget({super.key});

  @override
  State<TempleInputWidget> createState() => _TempleInputWidgetState();
}

class _TempleInputWidgetState extends State<TempleInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _temples = [];

  void _addTemple() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _temples.add(text);
      });
      _controller.clear();
    }
  }

  void _removeTemple(int index) {
    setState(() {
      _temples.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Enter temple",
            labelText:"Enter temple" ,
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
  crossAxisAlignment: WrapCrossAlignment.start,
  runAlignment: WrapAlignment.start,  
  spacing: 8,                           
  runSpacing: 8,                       
  children: List.generate(
    _temples.length,
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
            Text(_temples[index]),
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
)
,
      ],
    );
  }
}
