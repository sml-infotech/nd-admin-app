import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:provider/provider.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_viewmodel.dart';

class TempleImagePickerWidget extends StatelessWidget {
  const TempleImagePickerWidget({super.key});

  Future<void> _pickImages(BuildContext context) async {
    final vm = Provider.of<AddTempleViewmodel>(context, listen: false);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        if (file.path != null) {
          vm.addImage(File(file.path!));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTempleViewmodel>(
      builder: (context, vm, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Upload images",
                  border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: () => _pickImages(context),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              if (vm.images.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    vm.images.length,
                    (index) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            vm.images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () => vm.removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
