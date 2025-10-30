import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';
import 'package:nammadaiva_dashboard/arguments/temple_details_arguments.dart';
import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_requestmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/updatetemple/update_temple_request_model.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  UserService userService = UserService();

  bool isLoading = false;
  bool templeUpdated = false;
  String message = "";
  List<String> images = [];
  TempleDetailsArguments? originalTempleData;

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

  Future<void> addImages(List<String> newImages) async {
    try {
      isLoading = true;
      notifyListeners();

      selectedImages.addAll(newImages.map((path) => XFile(path)));
      debugPrint(
        "🖼 Selected Images: ${selectedImages.map((e) => e.path).toList()}",
      );

      for (final file in selectedImages) {
        debugPrint("📤 Getting presigned URL for ${file.name}");
        final response = await userService.presignedUrl(file.name, file.path);

        if (response.url != null && response.url!.isNotEmpty) {
          final presignedUrl = response.url!;
          final uploadedUrl = await uploadToS3(presignedUrl, file);

          if (uploadedUrl != null) {
            uploadedImageUrls.add(uploadedUrl);
            images.add(uploadedUrl);
            notifyListeners();
          } else {
            message = "Upload failed for ${file.name}";
          }
        } else {
          message =
              response.message ??
              "Failed to get presigned URL for ${file.name}";
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
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> updateTemple(String templeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('userRole');

    try {
      isLoading = true;
      notifyListeners();

      final Map<String, dynamic> changes = {};
      final listEquals = const ListEquality().equals;

      bool isChanged(dynamic oldVal, dynamic newVal) {
        return newVal != null &&
            newVal.toString().trim() != oldVal?.toString().trim();
      }

      if (isChanged(originalTempleData?.name, templeName.text.trim())) {
        changes["name"] = templeName.text.trim();
      }

      if (isChanged(originalTempleData?.address, templeLocation.text.trim())) {
        changes["address"] = templeLocation.text.trim();
      }

      if (isChanged(
        originalTempleData?.description,
        templeDescription.text.trim(),
      )) {
        changes["description"] = templeDescription.text.trim();
      }

      if (isChanged(originalTempleData?.city, templeCity.text.trim())) {
        changes["city"] = templeCity.text.trim();
      }

      if (isChanged(originalTempleData?.state, templeState.text.trim())) {
        changes["state"] = templeState.text.trim();
      }

      if (isChanged(originalTempleData?.pincode, templePincode.text.trim())) {
        changes["pincode"] = templePincode.text.trim();
      }

      if (isChanged(
        originalTempleData?.phoneNumber,
        templePhoneNumber.text.trim(),
      )) {
        changes["phone_number"] = templePhoneNumber.text.trim();
      }

      if (isChanged(originalTempleData?.email, templeEmail.text.trim())) {
        changes["email"] = templeEmail.text.trim();
      }

      if (isChanged(
        originalTempleData?.architecture,
        templeArchitecture.text.trim(),
      )) {
        changes["architecture"] = templeArchitecture.text.trim();
      }

      final newDeities = templeDeities.text
          .trim()
          .split(',')
          .map((e) => e.trim())
          .toList();
      if (!listEquals(originalTempleData?.deities ?? [], newDeities)) {
        changes["deities"] = newDeities;
      }

      final oldImages = List<String>.from(originalTempleData?.images ?? []);
      final newImages = List<String>.from(images);

      if (oldImages.length != newImages.length ||
          !const ListEquality().equals(oldImages, newImages)) {
        changes["images"] = newImages;
      }

      if (changes.isEmpty) {
        message = "No changes detected.";
        isLoading = false;
        notifyListeners();
        return;
      }

      debugPrint("📦 Changes to send: $changes");

      if (userRole == "Super Admin" || userRole == "Admin") {
        final updateTempleDataByAdmin = AddTemple(
          templeId: templeId,
          name: templeName.text.trim(),
          address: templeLocation.text.trim(),
          city: templeCity.text.trim(),
          state: templeState.text.trim(),
          pincode: templePincode.text.trim(),
          architecture: templeArchitecture.text.trim(),
          phoneNumber: templePhoneNumber.text.trim(),
          email: templeEmail.text.trim(),
          description: templeDescription.text.trim(),
          deities: ["dsfsdf"],
          images: newImages,
        );
        final response = await templeService.updateTemplebyAdmin(
          updateTempleDataByAdmin,
        );

        templeUpdated = response.message == "Temple updated successfully";
        message =
            response.message ??
            (templeUpdated
                ? "Temple updated successfully."
                : "Temple update failed.");
      } else {
        final payload = {"temple_id": templeId, "changes": changes};
        debugPrint("📤 Sending payload: $payload");

        final response = await templeService.updateTemple(payload);
        templeUpdated = response.code == 201;
        message =
            response.message ??
            (templeUpdated
                ? "Temple updated successfully."
                : "Temple update failed.");
      }
    } catch (e, st) {
      debugPrint("❌ Update failed: $e");
      debugPrint(st.toString());
      message = "Update failed: $e";
      templeUpdated = false;
    } finally {
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
        headers: {'Content-Type': 'image/jpeg'},
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
