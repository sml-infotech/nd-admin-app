import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_request_templemodel/update_request_temple_model.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class BookingsViewmodel extends ChangeNotifier {
  List<TempleRequest> bookings = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool isUpdating = false;
  TempleService templeService = TempleService();

  int page = 1;
  String? userRole;

  void setUserRole(String role) {
    userRole = role;
    notifyListeners();
  }

  void reset() {
    bookings.clear();
    page = 1;
    hasMore = true;
    notifyListeners();
  }

  Future<void> fetchBookings({bool reset = false}) async {
    try {
      if (reset) {
        page = 1;
        bookings.clear();
        hasMore = true;
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      notifyListeners();

      // final response = await templeService.getPujas(templeId)

      // if (response.isNotEmpty) {
      //   if (reset) {
      //     bookings = response;
      //   } else {
      //     bookings.addAll(response);
      //   }

      //   page++;
      // } else {
      //   hasMore = false;
      // }
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> approveBooking(String id) async {
    isUpdating = true;
    notifyListeners();

    try {
     // await ApiService.approveBooking(id);
      bookings.removeWhere((e) => e.id == id);
    } catch (e) {
      debugPrint("Approval error: $e");
    }

    isUpdating = false;
    notifyListeners();
  }
}
