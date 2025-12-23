import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/model/login_model/create_festival/festival_list_modal.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart'
    show UserService;

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
  bool isLoadingMore = false;
  bool eventCreated = false;
  bool eventUpdated = false;
  bool isLoading = false;
  bool isActive = true;
  List<String> temples = [];
  TextEditingController templeController = TextEditingController();
  int _currentPage = 1; 
  final int _itemsPerPage = 10; 
  bool hasMoreFestivals =
      true;
  List<FestivalListModal> festivalList = [];

  void addTemple(String templeName) {
    temples.add(templeName);
    notifyListeners();
  }

  void removeTemple(int index) {
    temples.removeAt(index);
    notifyListeners();
  }

  Future<bool> validateFestival(bool isUpdate) async {
    if (eventController.text.isEmpty) {
      message = "Please enter festival name";
      return false;
    } else if (descriptionContoller.text.isEmpty) {
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

  // Handle image uploading (presigned URLs and S3)
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
        descriptionContoller.text.trim(),
        temples,
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

  Future<void> updateFestival(
    String festivalId,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final templeId = selectedTempleId;
      final response = await userService.updateFestival(
        eventController.text.trim(),
        descriptionContoller.text.trim(),
        temples,
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
        _currentPage = 1;
        festivalList.clear();
        hasMoreFestivals = true;
        print('Fetching festivals (resetting)');
      } else {
        print('Fetching festivals (page $_currentPage)');
      }

      if (!hasMoreFestivals) {
        print('No more festivals to fetch');
        return;
      }

      if (isLoadingMore)
        return;

      isLoadingMore = true; // Mark loading as true when fetching more data
      isLoading = true; // Set isLoading to true while fetching
      notifyListeners(); // Notify listeners to show shimmer effect

      final response = await userService.fetchFestivals(_currentPage);

      // Handle the response and populate the list
      if (response.code == 200) {
        final newFestivals = List<FestivalListModal>.from(
          (response.data as List).map(
            (x) => x is FestivalListModal ? x : FestivalListModal.fromJson(x),
          ),
        );

        print('Fetched ${newFestivals.length} festivals');

        if (reset || _currentPage == 1) {
          festivalList = newFestivals;
        } else {
          festivalList.addAll(newFestivals);
        }

        // Update pagination state
        hasMoreFestivals = newFestivals.length == _itemsPerPage;

        if (hasMoreFestivals) {
          _currentPage++; // Increment page if there are more festivals
        } else {
          print('No more festivals to load.');
        }
      } else {
        message =
            'Failed to load festivals: ${response.message ?? 'Unknown error'}';
        print(message); // Log the error
      }
    } catch (e) {
      message = "Failed to fetch festivals: $e";
      print(message); // Log the error
    } finally {
      isLoadingMore = false; // Mark loading as complete
      isLoading = false; // Set isLoading to false once the data is fetched
      notifyListeners(); // Notify listeners to rebuild the UI
    }
  }

  // Reset the festival form
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
