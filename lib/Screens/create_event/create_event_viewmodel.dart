import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/event_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';


class CreateEventViewmodel extends ChangeNotifier {
  TempleService templeService = TempleService();
  EventService eventService = EventService();
  TextEditingController eventController = TextEditingController();
  TextEditingController knEventNameController = TextEditingController();
  TextEditingController descriptionContoller = TextEditingController();
  TextEditingController knDescriptionContoller = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController knLocationController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController knContactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  UserService userService = UserService();
  List<TimeSlot> timeSlots = [];
  List<Temple> templeData = [];
  Temple? selectedTemple;
  String? selectedTempleId;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  List<String> uploadedImageUrls = [];
  List<XFile> selectedImages = [];
  String message = '';
  bool eventCreated = false;
  bool eventUpdated = false;

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

  Future<void> removeImage(int index) async {
    await removeS3(uploadedImageUrls[index]);
    selectedImages.removeAt(index);
    notifyListeners();
  }

  Future<void> removeS3(String filename) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await userService.removeS3(filename);
      if (response.code == 200) {
        print("->>> $response");
        message = "success";
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

  Future<bool> validateKNnEvent() async {
    if (knEventNameController.text.isEmpty) {
      message = "Please enter event name in Kannada.";
      return false;
    }
    if (knDescriptionContoller.text.isEmpty) {
      message = "Please enter description in Kannada.";
      return false;
    }
    if (knLocationController.text.isEmpty) {
      message = "Please enter location in Kannada.";
      return false;
    }
    return true;
  }

  Future<bool> validateEvent() async {
  
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
    if (timeSlots.isEmpty) {
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

  int _currentPage = 1;
  bool hasNextPage = true;
  bool isLoading = false;
  bool isFetchingNextPage = false;
  int page = 1;
  final int limit = 10;
  List<String> templeList = [];

  Future<void> getTemples({bool reset = false}) async {
    if (isLoading || isFetchingNextPage) return;

    if (reset) {
      _currentPage = 1;
      hasNextPage = true;
      templeData.clear();
      templeList.clear();
      isLoading = true;
    } else {
      if (!hasNextPage) return;
      isFetchingNextPage = true;
    }

    notifyListeners();

    try {
      final response = await templeService.getTemples(
        page: _currentPage,
        limit: 10,
      );

      if (response.data != null && response.data!.isNotEmpty) {
        templeData.addAll(response.data!);

        templeList = templeData.map((t) => t.name).toList();

        if (response.data!.length < 10) {
          hasNextPage = false;
        } else {
          _currentPage++;
        }
      } else {
        hasNextPage = false;
      }
    } catch (e) {
      debugPrint("API Error: $e");
    } finally {
      isLoading = false;
      isFetchingNextPage = false;
      notifyListeners();
    }
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
        knEventNameController.text,
        selectedStartDate!.toIso8601String(),
        descriptionContoller.text,
        knDescriptionContoller.text,
        locationController.text,
        knLocationController.text,
        contactNameController.text,
        knContactNameController.text,
        contactNumberController.text,
        selectedEndDate!.toIso8601String(),
        timeSlots.first.fromTime,
        timeSlots.first.toTime,
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

  Future<void> updateEvent(String eventId) async {
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

      final response = await eventService.updateEvents(
        selectedTempleId?.isEmpty ?? true ? null : selectedTempleId,
        eventId,
        eventController.text,
        knEventNameController.text,
        selectedStartDate!,
        descriptionContoller.text,
        knDescriptionContoller.text,
        locationController.text,
        knLocationController.text,
        contactNameController.text,
        knContactNameController.text,
        contactNumberController.text,
        selectedEndDate!,
        timeSlots.first.fromTime,
        timeSlots.first.toTime,
        uploadedImageUrls,
      );

      if (response.code == 200) {
        message = response.message ?? "Success";
        eventUpdated = true;
        print("✅ updateEvent successfully: ${response.toJson()}");
        notifyListeners();
      } else {
        eventUpdated = false;
        message = "❌ Error: ${response.message ?? "Unknown error"}";
        print("Error response: ${response.toJson()}");
      }
    } catch (e) {
      print("⚠️ updateEvent update failed: $e");
      message = "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    eventController.clear();
    knEventNameController.clear();
    descriptionContoller.clear();
    knDescriptionContoller.clear();
    locationController.clear();
    knLocationController.clear();
    contactNameController.clear();
    knContactNameController.clear();
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
