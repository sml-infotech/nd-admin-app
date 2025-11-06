
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class AddTempleViewmodel extends ChangeNotifier {
  TextEditingController templeName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController architecture = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController templeController = TextEditingController();
  var authService = TempleService();
  var userService=UserService();
  List<XFile> selectedImages = [];

  bool isLoading=false;
  String message="";
  String presignedURL="";
  List<String> uploadedImageUrls = [];

  final List<String> temples = [];
  bool templeAdded=false;
AddTempleViewmodel() {
  templeName.addListener(_onChange);
  address.addListener(_onChange);
  city.addListener(_onChange);
  state.addListener(_onChange);
  pincode.addListener(_onChange);
  architecture.addListener(_onChange);
  email.addListener(_onChange);
  phone.addListener(_onChange);
  description.addListener(_onChange);
  templeController.addListener(_onChange);
}

void _onChange() {
  notifyListeners();
}
  Future<void> addImages(List<String> newImages) async {
    try {
      isLoading = true;
      notifyListeners();

      // Prevent duplicates before adding
      for (final path in newImages) {
        final alreadyExists = selectedImages.any((img) => img.path == path);
        if (!alreadyExists) {
          selectedImages.add(XFile(path));
        }
      }

      print(
        "🖼 Final Selected Images: ${selectedImages.map((e) => e.path).toList()}",
      );

      // 🪣 Upload safely
      for (final file in List<XFile>.from(selectedImages)) {
        print("📤 Getting presigned URL for ${file.name}");
        final response = await userService.presignedUrl(file.name, file.path);

        if (response.url != null && response.url!.isNotEmpty) {
          final presignedUrlForFile = response.url!;
          print("✅ Got presigned URL for ${file.name}");

          final uploadedUrl = await uploadToS3(presignedUrlForFile, file);
          if (uploadedUrl != null) {
            if (!uploadedImageUrls.contains(uploadedUrl)) {
              uploadedImageUrls.add(uploadedUrl);
            }
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
      print("❌ Error in addImages: $e");
      message = "Something went wrong: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }


 void addTemple(String name) {
    temples.add(name);
    notifyListeners();
  }

  void removeTemple(int index) {
    temples.removeAt(index);
    notifyListeners();
  }

 bool validateAddTemple() {
  if (templeName.text.trim().isEmpty) {
    message = "Temple name cannot be empty";
    return false;
  }
  if (address.text.trim().isEmpty) {
    message = "Address cannot be empty";
    return false;
  }
  if (city.text.trim().isEmpty) {
    message = "City cannot be empty";
    return false;
  }
  if (state.text.trim().isEmpty) {
    message = "State cannot be empty";
    return false;
  }
  if (pincode.text.trim().isEmpty) {
    message = "Pincode cannot be empty";
    return false;
  }
  if (architecture.text.trim().isEmpty) {
    message = "Architecture cannot be empty";
    return false;
  }
  if (email.text.trim().isEmpty) {
    message = "Email cannot be empty";
    return false;
  }
  if (!isValidEmail(email.text.trim())) {
    message = "Invalid email address";
    return false;
  }
  if (phone.text.trim().isEmpty) {
    message = "Phone number cannot be empty";
    return false;
  }
  if (phone.text.trim().length != 10) {
    message = "Phone number must be 10 digits";
    return false;
  }
  if (temples.isEmpty) {
    message = "Please add at least one deity";
    return false;
  }
  if (selectedImages.isEmpty) {
    message = "Please upload at least one image";
    return false;
  }
  if (description.text.trim().isEmpty) {
    message = "Description cannot be empty";
    return false;
  }

  
  return true;
}

  bool isValidEmail(String email) {
  final regex = RegExp(
      r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

Future<void> presignedUrl() async {

    try {
        isLoading=true;
        notifyListeners();
      final response = await userService.presignedUrl(
        temples.first,temples.first
      );
      if (response.message.isNotEmpty) {
        print("->>> $response");
        presignedURL=response.url;
        message = response.message ?? "success";
        await addTempleApi();
        notifyListeners();
      } 
      // else if(response.code==409){
      //   isLoading=false;
      //   message = response.message ?? "user not Found";
      //   notifyListeners();
      // }
      else {
        isLoading=false;
        notifyListeners();
        message =  "some error occurred";
        print("message $message");
      }
    } catch (e) {
      isLoading=false;
      notifyListeners();
   
    }
  }







Future<void> addTempleApi() async {

    try {
        isLoading=true;
        notifyListeners();
      final response = await authService.addTemple(
        templeName.text.trim(),
        address.text.trim(),
        city.text.trim(),
        state.text.trim(),
        pincode.text.trim(),
        architecture.text.trim(),
        phone.text.trim(),
        email.text.trim(),
        description.text.trim(),
        temples,
        [presignedURL],
      );
      if (response.code==201) {
        print("->>> $response");
        message = response.message ?? "success";
        isLoading=false;
        templeAdded=true;
        notifyListeners();
      } 
      else if(response.code==409){
        isLoading=false;
        message = response.message ?? "user not Found";
        print(">>>>>>>>?????${message}");
        notifyListeners();
      }
      else {
        isLoading=false;
        notifyListeners();
        message =  "some error occurred";
        print("message $message");
      }
    } catch (e) {
      isLoading=false;
      notifyListeners();
   
    }
  }

   @override
  void dispose() {
  templeName.clear();
  address.clear();
  city.clear();
  state.clear();
  pincode.clear();
  architecture.clear();
  email.clear();
  phone.clear();
  description.clear();
  templeController.clear();
  temples.clear();
  selectedImages.clear();
  notifyListeners();


  }
}
