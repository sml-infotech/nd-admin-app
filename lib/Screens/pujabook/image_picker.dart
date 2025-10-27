import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class MultiImagePickerSection extends StatelessWidget {
  final VoidCallback onAddImages;
  final List<String> imagePaths; // local paths or URLs
  final Function(int) onRemoveImage; // remove image by index

  const MultiImagePickerSection({
    super.key,
    required this.onAddImages,
    required this.imagePaths,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ Title
          Text(
            StringConstant.uploadText,
            style: AppTextStyles.editTempleTitleStyle,
          ),
          const SizedBox(height: 8),

          // 📤 Upload Button Box
          GestureDetector(
            onTap: onAddImages,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Image.asset(ImageStrings.uploadImg, height: 40),
                  const SizedBox(height: 8),
                  Text(
                    StringConstant.uploadImageSeva,
                    style: TextStyle(fontFamily: font, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // 🖼️ Display Selected Images
          if (imagePaths.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: imagePaths.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final path = imagePaths[index];
                  final isNetwork = path.startsWith('http');

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: isNetwork
                            ? Image.network(path,
                                width: 100, height: 100, fit: BoxFit.cover)
                            : Image.file(File(path),
                                width: 100, height: 100, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => onRemoveImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.close,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
