import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class MultiImagePickerSection extends StatelessWidget {
  final Future<void> Function() onAddImages;
  final List<String> imagePaths;
  final Function(int) onRemoveImage;

  const MultiImagePickerSection({
    super.key,
    required this.onAddImages,
    required this.imagePaths,
    required this.onRemoveImage,
  });

  Future<void> _handleAddImages(BuildContext context) async {
    // 🛑 Check for permission first
    final status = await Permission.photos.request(); // For iOS
    final storageStatus = await Permission.storage.request(); // For Android

    if (status.isGranted || storageStatus.isGranted) {
      // ✅ Permission granted → trigger image picker
      await onAddImages();
    } else if (status.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
      // ⚠️ Permanently denied → show alert with settings option
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
              'Please enable photo or storage access in settings to upload images.'),
          actions: [
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } else {
      // 🚫 Permission denied temporarily
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required to upload images.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringConstant.uploadText,
            style: AppTextStyles.editTempleTitleStyle,
          ),
          const SizedBox(height: 8),

          // Upload Button Box
          GestureDetector(
            onTap: () => _handleAddImages(context),
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

          // Display Selected Images
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
