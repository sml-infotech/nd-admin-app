import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_list_modal.dart';
import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_model.dart';
import 'package:nammadaiva_dashboard/service/mantra_service.dart';

class MantraListViewmodel extends ChangeNotifier {
  final mantraService = MantraService();

  List<MantraItem> mantras = [];
  String languageCode = "kn";

  int page = 1;
  bool hasMore = true;
  bool isLoading = true;
  bool isLoadingMore = false;

  Future<void> fetchMantra({bool reset = false}) async {
    try {
      if (reset) {
        page = 1;
        hasMore = true;
        mantras.clear();
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      notifyListeners();

      final response = await mantraService.fetchMantra(page: page, limit: 10);

      if (response != null && response.items.isNotEmpty) {
        mantras.addAll(response.items);
        page++;
      } else {
        hasMore = false;
      }
    } catch (e) {
      debugPrint("Error fetching mantras: $e");
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  void reset() {
    mantras = [];
    page = 1;
    hasMore = true;
    isLoading = true;
    isLoadingMore = false;
    notifyListeners();
  }
}
