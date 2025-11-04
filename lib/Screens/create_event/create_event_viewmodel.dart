import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/model/login_model/createmodel/create_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/event_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

// Compatibility extension: provide startTime / endTime getters expected by the viewmodel.
// If your TimeSlot class actually exposes differently-named fields (e.g. `from`, `to`, `start`, `end`),
// update these getters to return the correct underlying values.
extension TimeSlotCompatibility on TimeSlot {
  String get startTime => '';
  String get endTime => '';
}

class CreateEventViewmodel extends ChangeNotifier {
  TempleService templeService = TempleService();
  EventService eventService = EventService();
  TextEditingController eventController = TextEditingController();
    TextEditingController descriptionContoller = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController contactNameController = TextEditingController();
    TextEditingController contactNumberController = TextEditingController();
  UserService userService = UserService();
  List<TimeSlot> timeSlots = [];
  List<Temple> templeData = [];
  Temple? selectedTemple;
  String selectedTempleId = '';
  DateTime ?selectedStartDate ;
  DateTime ?selectedEndDate ;
  List<String> uploadedImageUrls = [];
  List<XFile> selectedImages = [];
  String message = '';
  bool eventCreated = false;

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

  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
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



 Future<bool> validateEvent(bool isFromUpdate) async {
    if (selectedTemple == null) {
      message = "Please select a temple.";
      return false;
    }
    if (eventController.text.isEmpty) {
      message = "Please enter event name.";
      return false;
    }
    if (descriptionContoller.text.isEmpty) {
      message = "Please enter description.";
      return false;
    }
    if (locationController.text.isEmpty) {
      message = "Please enter location.";
      return false;
    }
    if (contactNameController.text.isEmpty) {
      message = "Please enter contact name.";
      return false;
    }
    if (contactNumberController.text.isEmpty) {
      message = "Please enter contact number.";
      return false;
    }
    if (selectedStartDate == null) {
      message = "Please select start date.";
      return false;
    }
    if (selectedEndDate == null) {  
      message = "Please select end date.";
      return false;
    }
    if (selectedEndDate!.isBefore(selectedStartDate!)) {
      message = "End date cannot be before start date.";
      return false;
    }
    if(timeSlots.isEmpty){
      message = "Please add at least one time slot.";
      return false;
    } 
    if (uploadedImageUrls.isEmpty) {
      message = "Please upload at least one image.";
      return false;
    }
    return true;
 }

  void setSelectedTemple(Temple temple) {
    selectedTemple = temple;
    print('Selected Temple: ${temple.name}');
    notifyListeners();
  }

  int page = 1;
  final int limit = 10;
  bool isLoading = false;
  List<String> templeList = [];
  Future<void> getTemples({bool reset = false}) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    if (reset) {
      templeData.clear();
      templeList.clear();
      page = 1;
    }

    final response = await templeService.getTemples(page: page, limit: limit);

    if (response.data != null && response.data!.isNotEmpty) {
      templeData.addAll(response.data!);
      templeList = templeData.map((t) => t.name).toList();
      selectedTempleId = templeData.first.id;
      page++;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }



 Future<void> createEvent() async {
    try {
      isLoading = true;
      notifyListeners();

      if (timeSlots.isEmpty) {
        message = "Please add at least one time slot";
        isLoading = false;
        notifyListeners();
        return;
      }

      final templeId = selectedTempleId;

      final response = await eventService.createEvent(
        templeId,
        eventController.text,
        selectedStartDate!.toIso8601String(),
        descriptionContoller.text,
        locationController.text,
        contactNameController.text,
        contactNumberController.text,
        selectedEndDate!.toIso8601String(),
        timeSlots.first.startTime,
        timeSlots.first.endTime,
        uploadedImageUrls,
      );

      if (response.code == 201) {
        message = response.message ?? "Success";
        eventCreated = true;
        print("✅ createEvent successfully: ${response.toJson()}");
        notifyListeners();
      } else {
        eventCreated = false;
        message = "❌ Error: ${response.message ?? "Unknown error"}";
        print("Error response: ${response.toJson()}");
      }
    } catch (e) {
      print("⚠️ Puja update failed: $e");
      message = "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
void reset() {
    eventController.clear();
    descriptionContoller.clear();
    locationController.clear();
    contactNameController.clear();
    contactNumberController.clear();

    timeSlots = [];
    templeData = [];
    selectedTemple = null;
    selectedTempleId = '';
    selectedStartDate = null;
    selectedEndDate = null;
    uploadedImageUrls = [];
    selectedImages = [];
    message = '';
    eventCreated = false;

  
  }
}
