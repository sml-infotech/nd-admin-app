

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nammadaiva_dashboard/service/user_service.dart';
import 'package:path/path.dart' as path; 
import 'package:mime/mime.dart';
class CreateBlogViewmodel extends ChangeNotifier {

  TextEditingController blogName=TextEditingController();
  TextEditingController blogDescription=TextEditingController();
  UserService userService=UserService();
   File? selectedImage;
  String? uploadedImageUrl;
    String? message;
    bool isImageUploading=false;




 Future<void> uploadImageToS3(File file) async {
    try {
      isImageUploading = true;
      notifyListeners();

      selectedImage = file;
      final fileName = path.basename(file.path); // keeps original extension

      final presignedUrl = await userService.presignedUrl(fileName, file.path);
      if (presignedUrl == null) {
        message = "Failed to get upload URL";
        return;
      }

      final imageUrl = await uploadToS3(presignedUrl.url, file);
      if (imageUrl == null) {
        message = "Image upload failed";
        return;
      }

      uploadedImageUrl = imageUrl;
      message = "File uploaded successfully";
    } catch (e) {
      message = "Upload error: $e";
    } finally {
      isImageUploading = false;
      notifyListeners();
    }
  }


  Future<String?> uploadToS3(String presignedUrl, File imageFile) async {
    try {
      final fileBytes = await imageFile.readAsBytes();

      final mimeType =
          lookupMimeType(imageFile.path) ?? 'application/octet-stream';

      final response = await http.put(
        Uri.parse(presignedUrl),
        body: fileBytes,
        headers: {'Content-Type': mimeType},
      );

      if (response.statusCode == 200) {
        final imageUrl = presignedUrl.split('?').first;
        print("✅ Uploaded successfully: $imageUrl");
        return imageUrl;
      } else {
        print("❌ Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error uploading to S3: $e");
      return null;
    }
  }
}