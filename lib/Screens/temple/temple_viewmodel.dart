import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class TempleViewModel extends ChangeNotifier {
  List<Temple> temples = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

  final TempleService authService = TempleService();

  int page = 1;
  int limit = 10;

  Future<void> fetchTemples({bool refresh = false}) async {
    try {
      if (isLoading) return;

      if (page == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      notifyListeners();

      if (refresh) {
        temples.clear();
        page = 1;
        hasMore = true;
        isLoadingMore = false;
      }

      final response = await authService.getTemples(page: page, limit: limit);

      if (response.data != null && response.data!.isNotEmpty) {
        temples.addAll(response.data!);

        if (response.data!.length < limit) {
          hasMore = false;
        } else {
          page++;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      print("Error fetching temples: $e");
      hasMore = false;
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  void reset() {
    temples = [];
    isLoading = false;
    isLoadingMore = false;
    hasMore = true;
    page = 1;
    limit = 10;
    notifyListeners();
  }

  /// 👇 Add this helper method
  Future<void> resetAndFetch() async {
    reset();
    await fetchTemples(refresh: true);
  }
}
