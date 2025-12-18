import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class TempleViewModel extends ChangeNotifier {
  List<Temple> temples = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
    final TextEditingController searchController = TextEditingController();

  final TempleService authService = TempleService();
Timer? _debounce;

  int page = 1;
  int limit = 10;

Future<void> fetchTemples({bool refresh = false}) async {
    try {
      // if (isLoading) return;

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

      final response = await authService.getTemples(page: page, limit: limit,search:searchController.text );

      if (response.data != null && response.data!.isNotEmpty) {
  if (searchController.text.isNotEmpty) {
    // 🔥 Search mode → always replace list
    temples = response.data!;
    hasMore = false;      // No pagination while searching
  } else {
    // Normal pagination
    temples.addAll(response.data!);

    if (response.data!.length < limit) {
      hasMore = false;
    } else {
      page++;
    }
  
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
    isLoading = true;
    isLoadingMore = false;
    hasMore = true;
    page = 1;
    limit = 10;
    print("dfgdfgdfgdfg");
    notifyListeners();
  }

  Future<void> resetAndFetch() async {
    reset();
    await fetchTemples(refresh: true);
  }
  void onSearchChanged() {
  if (_debounce?.isActive ?? false) _debounce!.cancel();

  _debounce = Timer(const Duration(milliseconds: 400), () {
    resetAndFetch();
  });
}

}
