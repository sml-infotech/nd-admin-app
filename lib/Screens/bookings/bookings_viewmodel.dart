import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/model/login_model/booking_model/booking_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_payment_status/update_booking.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class BookingsViewmodel extends ChangeNotifier {
  List<BookingModel> bookings = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool isUpdating = false;
  var userService = UserService();

  List<Temple> templeData = [];
  String? selectedTemple;
  String? selectedTempleId;
  int selectedSegment = 2;
  final List<String> segments = ["Today", "Tomorrow", "Upcoming", "Past"];
  final TempleService api = TempleService();
  int page = 1;
  bool uploadCompleted = false;

  int? expandedIndex;
  List<String> uploadedImageUrls = [];
  bool isUploading = false;
  String? userRole;

  final ImagePicker _picker = ImagePicker();
  Future<void> uploadSelectedImages(String bookingId) async {
    if (selectedImages.isEmpty) return;

    try {
      isUploading = true;
      notifyListeners();

      for (final file in List<XFile>.from(selectedImages)) {
        final response = await userService.presignedUrl(file.name, file.path);

        if (response.url != null) {
          final uploadedUrl = await uploadToS3(response.url!, file);
          if (uploadedUrl != null) {
            uploadedImageUrls.add(uploadedUrl);
          }
        }
      }
    } finally {
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

  List<XFile> selectedImages = [];
  Future<void> pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images);
      notifyListeners();
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  void setExpanded(int index) {
    expandedIndex = expandedIndex == index ? null : index;
    notifyListeners();
  }

  void setUserRole(String role) {
    userRole = role;
    notifyListeners();
  }

  void resetBookings() {
    page = 1;
    bookings.clear();
    hasMore = true;
    notifyListeners();
  }

  /// Fetch temples list
  Future<void> fetchTemples() async {
    isLoading = true;
    notifyListeners();

    final response = await api.getTemples(page: 1, limit: 2000);

    if (response.data != null && response.data!.isNotEmpty) {
      templeData = response.data!;
      // selectedTemple = templeData.first.name;
      // selectedTempleId = templeData.first.id;

      await fetchBookings();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBookings({
    bool reset = false,
    String filter = "upcoming",
  }) async {
    if (reset) {
      page = 1;
      bookings.clear();
      hasMore = true;
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    try {
      final result = await api.fetchBookings(
        selectedTempleId ?? "",
        page: page,
        filter: filter,
      );

      final newItems = result.data ?? [];

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      List<BookingModel> filtered;

      if (filter == "today") {
        filtered = newItems.where((b) {
          final d = DateTime.parse(b.pujaDate).toLocal();
          final day = DateTime(d.year, d.month, d.day);
          return day == today;
        }).toList();
      } else if (filter == "tomorrow") {
        filtered = newItems.where((b) {
          final d = DateTime.parse(b.pujaDate).toLocal();
          final day = DateTime(d.year, d.month, d.day);
          return day == tomorrow;
        }).toList();
      } else if (filter == "upcoming") {
        filtered = newItems.where((b) {
          final d = DateTime.parse(b.pujaDate).toLocal();
          final day = DateTime(d.year, d.month, d.day);
          return day.isAfter(today); // ✅ REAL upcoming
        }).toList();
      } else if (filter == "past") {
        filtered = newItems.where((b) {
          final d = DateTime.parse(b.pujaDate).toLocal();
          final day = DateTime(d.year, d.month, d.day);
          return day.isBefore(today);
        }).toList();
      } else {
        filtered = newItems;
      }

      if (filtered.isNotEmpty) {
        bookings.addAll(filtered);
        page++;
      }

      if (newItems.length < result.limit) {
        hasMore = false;
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  void selectTemple(Temple temple) async {
    selectedSegment = 0;

    selectedTemple = temple.name;
    selectedTempleId = temple.id;

    Navigator.pop(_bottomSheetContext!);

    await fetchBookings(reset: true);
  }

  BuildContext? _bottomSheetContext;

  void openTempleBottomSheet(BuildContext context) {
    _bottomSheetContext = context;
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: templeData.length,
        itemBuilder: (_, index) {
          final temple = templeData[index];
          return Padding(
            padding: EdgeInsetsGeometry.fromLTRB(5, 10, 0, 0),
            child: ListTile(
              title: Text(temple.name, style: TextStyle(fontFamily: font)),
              onTap: () => selectTemple(temple),
            ),
          );
        },
      ),
    );
  }

  Future<void> updateBooking(String bookingId) async {
    try {
      isUploading = true;
      notifyListeners();

      var data = BookingCompletionRequest(
        bookingStatus: "completed",
        images: uploadedImageUrls,
      );

      final response = await userService.updateBooking(data, bookingId);
      uploadedImageUrls.clear();
      if (response.code == 200) {
        await reset1();
        uploadCompleted = true;
        Future.delayed(const Duration(seconds: 1), () {
          fetchBookings(reset: true);
        });
        debugPrint("Booking updated successfully");
      } else {
        debugPrint("Failed to update booking: ${response.code}");
      }

      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<void> reset() async {
    bookings = [];
    isLoading = false;
    isLoadingMore = false;
    hasMore = true;
    isUpdating = false;
    isUploading = false;
    templeData = [];
    selectedTemple = null;
    selectedTempleId = null;
    selectedSegment = 2;
    page = 1;
    expandedIndex = null;
    uploadedImageUrls = [];
    selectedImages = [];
    bookings.clear();
    hasMore = true;
    notifyListeners();
    userRole = null;
    notifyListeners();
  }

  Future<void> reset1() async {
    bookings = [];
    isLoading = false;
    isLoadingMore = false;
    hasMore = true;
    isUpdating = false;
    isUploading = false;
    selectedTemple = null;
    selectedTempleId = null;
    selectedSegment = 2;
    page = 1;
    expandedIndex = null;
    uploadedImageUrls = [];
    selectedImages = [];
    bookings.clear();
    hasMore = true;
    notifyListeners();
    userRole = null;
    notifyListeners();
  }
}
