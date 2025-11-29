import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart'; // <<-- mime lookup
import 'package:path/path.dart' as path; // <<-- basename

import 'package:nammadaiva_dashboard/service/mantra_service.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class CreateMantraViewmodel extends ChangeNotifier {
  final mantraName = TextEditingController();
  final mantra = TextEditingController();

  File? selectedImage;
  String? uploadedImageUrl;
  String? message;

  bool isImageUploading = false;
  bool isLoading = false;

  final mantraService = MantraService();
  final userService = UserService();

  bool validateForm() {
    if (mantraName.text.isEmpty) {
      message = "Please fill Mantra Name";
      return false;
    }
    if (mantra.text.isEmpty) {
      message = "Please fill Mantra";
      return false;
    }
    if (uploadedImageUrl == null) {
      message = "Upload the image first";
      return false;
    }
    return true;
  }

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

  Future<void> createMantra() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await mantraService.createMantra(
        mantraName.text,
        mantra.text,
        uploadedImageUrl!,
      );

      if (response.code == 200) {
        message = "Mantra created successfully";
        isLoading = false;
        reset();
        notifyListeners();
      } else {
        message = response.message ?? "API error";
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      message = "Something went wrong: $e";
      isLoading = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


    void reset() {
    mantraName.clear();
    mantra.clear();
    selectedImage = null;
    uploadedImageUrl = null;
    message = null;
    isImageUploading = false;
    isLoading = false;

    notifyListeners();
  }
}
