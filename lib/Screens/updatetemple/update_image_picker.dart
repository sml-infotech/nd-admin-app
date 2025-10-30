import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:provider/provider.dart';

class UpdateImagepickerWidget extends StatelessWidget {
  UpdateImagepickerWidget({super.key});

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages(BuildContext context) async {
    final viewModel = Provider.of<UpdateTempleViewmodel>(
      context,
      listen: false,
    );
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final imagePaths = pickedFiles.map((e) => e.path).toList();
      await viewModel.addImages(imagePaths); // Use Provider instance directly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateTempleViewmodel>(
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
                    borderSide: const BorderSide(
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: ColorConstant.primaryColor,
                    ),
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
                          child: displayImage(vm.images[index]),
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

  Widget displayImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(path, width: 100, height: 100, fit: BoxFit.cover);
    }
    return Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover);
  }
}
