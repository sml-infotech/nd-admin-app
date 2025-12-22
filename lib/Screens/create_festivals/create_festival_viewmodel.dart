
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class CreateFestivalViewmodel extends ChangeNotifier {

TextEditingController eventController = TextEditingController();
  TextEditingController descriptionContoller = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  UserService userService = UserService();
  List<TimeSlot> timeSlots = [];
  String selectedTempleId = '';
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  List<String> uploadedImageUrls = [];
  List<XFile> selectedImages = [];
  String message = '';
  bool eventCreated = false;
  bool eventUpdated = false;
  bool isLoading = false;
  bool isActive = true;
List<String> temples = [];
  TextEditingController templeController = TextEditingController();


  void addTemple(String templeName) {
    temples.add(templeName);
    notifyListeners();
  }



  void removeTemple(int index) {
    temples.removeAt(index);
    notifyListeners();
  }

Future<bool>validateFestival(bool isUpdate) async {
  if (eventController.text.isEmpty) {
    message = "Please enter festival name";
    return false;
  }
  else if (descriptionContoller.text.isEmpty) {
    message = "Please enter description";
      return false;
  }
 
  else if (selectedStartDate == null) {
    message = "Please select start date";
      return false;
  }
  else if (selectedEndDate == null) {
    message = "Please select end date";
      return false;
  }

  return true;
}



  Future<void> addImages(List<String> newImages) async {
    try {
      isLoading = true;
      notifyListeners();

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


  void reset() {
    eventController.clear();
    descriptionContoller.clear();
    locationController.clear();
    contactNameController.clear();
    contactNumberController.clear();
    timeSlots.clear();
    selectedTempleId = '';
    selectedStartDate = null;
    selectedEndDate = null;
    uploadedImageUrls.clear();
    selectedImages.clear();
    message = '';
    eventCreated = false;
    eventUpdated = false;
    isLoading = false;
    notifyListeners();
  }
}