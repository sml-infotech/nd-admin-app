import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
class ImagePicker extends StatefulWidget {
  const ImagePicker({super.key});

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _temples = [];
  final List<File> _images = [];



  // Pick images
  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _images.addAll(result.files.map((f) => File(f.path!)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 0),child: 
    
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       

        // Image picker input
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Upload images",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_a_photo),
              onPressed: _pickImages,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Display picked images
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            _images.length,
            (index) => Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _images[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
