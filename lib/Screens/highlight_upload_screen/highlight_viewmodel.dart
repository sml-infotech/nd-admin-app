import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:mime/mime.dart'; // To detect the MIME type
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/service/highlight_service.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class HighlightViewmodel extends ChangeNotifier {
  bool isLoading = false;
  String message = '';
  List<XFile> selectedImages = [];
  List<String> uploadedImageUrls = [];
  var userService = UserService();
  var highLightService = HighlightService();

  // Function to add images or videos
  Future<void> addMedia(List<String> newFiles, bool isVideo) async {
    try {
      isLoading = true;
      notifyListeners();

      for (final path in newFiles) {
        final alreadyExists = selectedImages.any((img) => img.path == path);
        if (!alreadyExists) {
          selectedImages.add(XFile(path));
        }
      }

      print(
        "📷 Final Selected Media: ${selectedImages.map((e) => e.path).toList()}",
      );

      // 🪣 Upload safely
      for (final file in List<XFile>.from(selectedImages)) {
        print("📤 Getting presigned URL for ${file.name}");

        final response = await userService.presignedUrl(file.name, file.path);

        if (response.url != null && response.url!.isNotEmpty) {
          final presignedUrlForFile = response.url!;
          print("✅ Got presigned URL for ${file.name}");

          // Upload to S3 using the presigned URL
          final uploadedUrl = await uploadToS3(
            presignedUrlForFile,
            file,
            isVideo,
          );
          if (uploadedUrl != null) {
            if (!uploadedImageUrls.contains(uploadedUrl)) {
              uploadedImageUrls.add(uploadedUrl);
            }
            notifyListeners();
            selectedImages.remove(file);

            print("✅ Uploaded ${file.name} -> $uploadedUrl");
          } else {
            print("❌ Upload failed for ${file.name}");
            message = "Upload failed for ${file.name}";
          }
        } else {
          print("⚠️ Failed to get presigned URL for ${file.name}");
          message =
              response.message ??
              "Failed to get presigned URL for ${file.name}";
        }
      }
    } catch (e) {
      print("❌ Error in addMedia: $e");
      message = "Something went wrong: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Function to upload the file to S3 using the presigned URL
  Future<String?> uploadToS3(
    String presignedUrl,
    XFile file,
    bool isVideo,
  ) async {
    try {
      final fileBytes = await file.readAsBytes();
      final mimeType = isVideo
          ? 'video/mp4'
          : lookupMimeType(file.path) ?? 'application/octet-stream';

      final response = await http.put(
        Uri.parse(presignedUrl),
        headers: {
          'Content-Type': mimeType,
          'Content-Length': fileBytes.length.toString(),
        },
        body: fileBytes,
      );

print("mimeType${mimeType}");
      if (response.statusCode == 200) {
        await createHighlight(mimeType, presignedUrl);
        print("✅ File uploaded successfully to S3: ${file.name}");
        return presignedUrl; // Return the presigned URL or the file URL in S3
      } else {
        print("❌ Error uploading file to S3: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error uploading to S3: $e");
      return null;
    }
  }

  Future<void> createHighlight(String mimeType, String presignedUrl) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await highLightService.createHighlight(
        presignedUrl,
        mimeType.contains(  'video') ? 'video' : 'image',
        presignedUrl,
      );
     

      if (response.code == 200) {
        message = response.message!;
        print("✅ Highlight created successfully $message");
        notifyListeners();
      } else {
        message = "Some error occurred";
        notifyListeners();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      message = "Something went wrong";
      isLoading = false;
      notifyListeners();
    }
  }
}
