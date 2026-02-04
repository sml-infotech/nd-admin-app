import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/model/login_model/create_festival/festival_list_modal.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart'
    show UserService;

class CreateFestivalViewmodel extends ChangeNotifier {
  TextEditingController eventController = TextEditingController();
  TextEditingController knEventNameController = TextEditingController();
  TextEditingController descriptionContoller = TextEditingController();
  TextEditingController knDescriptionContoller = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController knLocationController = TextEditingController();
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
  bool isLoadingMore = false;
  bool eventCreated = false;
  bool eventUpdated = false;
  bool isLoading = false;
  bool isInitialLoading = true; // first time only

  bool isActive = true;
  List<String> deities = [];
  List<String> deitiesKn = [];
  TextEditingController templeController = TextEditingController();
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool hasMoreFestivals = true;
  List<FestivalListModal> festivalList = [];

  void addDeity(String templeName) {
    deities.add(templeName);
    notifyListeners();
  }

  void removeDeity(int index) {
    deities.removeAt(index);
    notifyListeners();
  }

  void addDeityKn(String templeName) {
    deitiesKn.add(templeName);
    notifyListeners();
  }

  void removeDeityKn(int index) {
    deitiesKn.removeAt(index);
    notifyListeners();
  }

  Future<bool> validateFestival(bool isUpdate) async {
    if (eventController.text.trim().isEmpty) {
      message = "Please enter festival name";
      return false;
    } else if (descriptionContoller.text.trim().isEmpty) {
      message = "Please enter description";
      return false;
    } else if (selectedStartDate == null) {
      message = "Please select start date";
      return false;
    } else if (selectedEndDate == null) {
      message = "Please select end date";
      return false;
    }
    return true;
  }

  Future<bool> validateFestivalKn() async {
    if (knEventNameController.text.trim().isEmpty) {
      message = "Please enter festival name in Kannada";
      return false;
    } else if (knDescriptionContoller.text.trim().isEmpty) {
      message = "Please enter description in Kannada";
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

      // Upload images to S3
      for (final file in List<XFile>.from(selectedImages)) {
        final response = await userService.presignedUrl(file.name, file.path);
        if (response.url != null && response.url!.isNotEmpty) {
          final uploadedUrl = await uploadToS3(response.url!, file);
          if (uploadedUrl != null && !uploadedImageUrls.contains(uploadedUrl)) {
            uploadedImageUrls.add(uploadedUrl);
            selectedImages.remove(file);
          } else {
            message = "Upload failed for ${file.name}";
          }
        } else {
          message =
              response.message ??
              "Failed to get presigned URL for ${file.name}";
        }
      }
    } catch (e) {
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
        return presignedUrl.split('?').first;
      }
    } catch (e) {
      message = "Error uploading to S3: $e";
    }
    return null;
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  Future<void> createFestival() async {
    try {
      isLoading = true;
      notifyListeners();

      final templeId = selectedTempleId;
      final response = await userService.createFestivals(
        eventController.text.trim(),
        knEventNameController.text.trim(),
        descriptionContoller.text.trim(),
        knDescriptionContoller.text.trim(),
        deities,
        deitiesKn,
        selectedStartDate!.toIso8601String(),
        selectedEndDate!.toIso8601String(),
        timeSlots.first.fromTime ?? "00:00",
        timeSlots.first.toTime ?? "00:00",
        uploadedImageUrls,
      );

      if (response.code == 200) {
        message = response.message ?? "Success";
        eventCreated = true;
        notifyListeners();
      } else {
        eventCreated = false;
        message = "❌ Error: ${response.message ?? "Unknown error"}";
      }
    } catch (e) {
      message = "Something went wrong: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateFestival(String festivalId) async {
    try {
      isLoading = true;
      notifyListeners();

      final templeId = selectedTempleId;
      final response = await userService.updateFestival(
        eventController.text.trim(),
        knEventNameController.text.trim(),
        descriptionContoller.text.trim(),
        knDescriptionContoller.text.trim(),
        deities,
        deitiesKn,
        selectedStartDate!.toIso8601String(),
        selectedEndDate!.toIso8601String(),
        timeSlots.first.fromTime ?? "00:00",
        timeSlots.first.toTime ?? "00:00",
        uploadedImageUrls,
        festivalId,
      );

      if (response.code == 200) {
        message = response.message ?? "Success";
        eventCreated = true;
        notifyListeners();
      } else {
        eventCreated = false;
        message = "❌ Error: ${response.message ?? "Unknown error"}";
      }
    } catch (e) {
      message = "Something went wrong: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFestivals({bool reset = false}) async {
    try {
      if (reset) {
        isInitialLoading = true;
        _currentPage = 1;
        festivalList.clear();
        hasMoreFestivals = true;
        notifyListeners();
      }

      if (!hasMoreFestivals || isLoadingMore) return;

      if (!reset) {
        isLoadingMore = true;
        notifyListeners();
      }

      final response = await userService.fetchFestivals(_currentPage);

      final newFestivals = response.data;

      festivalList.addAll(newFestivals);
      hasMoreFestivals = newFestivals.length == _itemsPerPage;

      if (hasMoreFestivals) _currentPage++;
    } catch (e) {
      debugPrint("Fetch failed $e");
    } finally {
      isInitialLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> deleteFestival(String festivalId) async {
    try {
      isInitialLoading = true;
      notifyListeners();

      final response = await userService.deleteFestival(festivalId);

      if (response.code == 200) {
        festivalList.removeWhere((e) => e.id == festivalId);
        isInitialLoading = false;
        message = "Festival deleted successfully";
        notifyListeners();
        return true;
      } else {
        message = response.message ?? "Delete failed";
        return false;
      }
    } catch (e) {
      message = "Delete failed: $e";
      return false;
    } finally {
      isInitialLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    eventController.clear();
    knEventNameController.clear();
    descriptionContoller.clear();
    knDescriptionContoller.clear();
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
    isInitialLoading = true;
    deities.clear();
    deitiesKn.clear();
    isActive = false;
    notifyListeners();
  }
}
