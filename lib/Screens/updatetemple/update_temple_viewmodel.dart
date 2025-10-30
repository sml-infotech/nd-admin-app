import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class UpdateTempleViewmodel extends ChangeNotifier {
  TextEditingController templeName = TextEditingController();
  TextEditingController templeLocation = TextEditingController();
  TextEditingController templeDescription = TextEditingController();
  TextEditingController templePhoneNumber = TextEditingController();
  TextEditingController templeEmail = TextEditingController();
  TextEditingController templeDeities = TextEditingController();
  TextEditingController templeArchitecture = TextEditingController();
  TextEditingController templeCity = TextEditingController();
  TextEditingController templeState = TextEditingController();
  TextEditingController templePincode = TextEditingController();
  TempleService templeService = TempleService();
  UserService userService=UserService();
  bool isLoading = false;
  bool templeUpdated = false;
  String message = "";
  List<String> images = [];
  bool validateUpdateTemple() {
    final name = templeName.text.trim();
    final location = templeLocation.text.trim();
    final description = templeDescription.text.trim();
    final phone = templePhoneNumber.text.trim();
    final email = templeEmail.text.trim();
    final deities = templeDeities.text.trim();
    final architecture = templeArchitecture.text.trim();
    final city = templeCity.text.trim();
    final state = templeState.text.trim();
    final pincode = templePincode.text.trim();

    if (name.isEmpty) {
      message = "Temple name cannot be empty";
      return false;
    }

    if (location.isEmpty) {
      message = "Address cannot be empty";
      return false;
    }

    if (city.isEmpty) {
      message = "City cannot be empty";
      return false;
    }

    if (state.isEmpty) {
      message = "State cannot be empty";
      return false;
    }

    if (pincode.isEmpty) {
      message = "Pincode cannot be empty";
      return false;
    } else if (pincode.length != 6 || int.tryParse(pincode) == null) {
      message = "Pincode must be a valid 6-digit number";
      return false;
    }

    if (architecture.isEmpty) {
      message = "Architecture cannot be empty";
      return false;
    }

    if (email.isEmpty) {
      message = "Email cannot be empty";
      return false;
    } else if (!isValidEmail(email)) {
      message = "Invalid email address";
      return false;
    }

    if (phone.isEmpty) {
      message = "Phone number cannot be empty";
      return false;
    } else if (phone.length != 10 || int.tryParse(phone) == null) {
      message = "Phone number must be 10 digits";
      return false;
    }

    if (deities.isEmpty) {
      message = "Please add at least one deity";
      return false;
    }

    if (description.isEmpty) {
      message = "Description cannot be empty";
      return false;
    }
    message = "";
    return true;
  }
  List<XFile> selectedImages = [];

  List<String> uploadedImageUrls = [];

  
  void addImage(String image) {
    images.add(image);
    notifyListeners();
  }

  Future<void> addImages(List<String> newImages) async {
    try {
      isLoading = true;
      notifyListeners();

      selectedImages.addAll(newImages.map((path) => XFile(path)));
      debugPrint("🖼 Selected Images: ${selectedImages.map((e) => e.path).toList()}");

      for (final file in selectedImages) {
        debugPrint("📤 Getting presigned URL for ${file.name}");
        final response = await userService.presignedUrl(file.name, file.path);

        if (response.url != null && response.url!.isNotEmpty) {
          final presignedUrl = response.url!;
          debugPrint("✅ Got presigned URL for ${file.name}");
          final uploadedUrl = await uploadToS3(presignedUrl, file);

          if (uploadedUrl != null) {
            uploadedImageUrls.add(uploadedUrl);
           images.add(uploadedUrl);
          } else {
            debugPrint("❌ Upload failed for ${file.name}");
            message = "Upload failed for ${file.name}";
          }
        } else {
          debugPrint("⚠️ Failed to get presigned URL for ${file.name}");
          message = response.message ?? "Failed to get presigned URL for ${file.name}";
        }
      }
    } catch (e, st) {
      debugPrint("❌ Error while uploading images: $e");
      debugPrint(st.toString());
      message = "Unexpected error occurred: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  Future<void> updateTemple(String templeId) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await templeService.updateTemple(
        templeId,
        templeName.text.trim(),
        templeLocation.text.trim(),
        templeCity.text.trim(),
        templeState.text.trim(),
        templePincode.text.trim(),
        templeArchitecture.text.trim(),
        templePhoneNumber.text.trim(),
        templeEmail.text.trim(),
        templeDescription.text.trim(),
        [templeDeities.text.trim()],
        images,
      );
      if (response.code == 201) {
        print("->>> $response");
        message = response.message ?? "success";
        isLoading = false;
        templeUpdated = true;
        notifyListeners();
      } else if (response.code == 409) {
        isLoading = false;
        message = response.message ?? "user not Found";
        print(">>>>>>>>?????${message}");
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        message = "some error occurred";
        print("message $message");
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  Future<String?> uploadToS3(String presignedUrl, XFile imageFile) async {
  try {
    final fileBytes = await imageFile.readAsBytes();

    final response = await http.put(
      Uri.parse(presignedUrl),
      body: fileBytes,
      headers: {
        'Content-Type': 'image/jpeg', 
      },
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
