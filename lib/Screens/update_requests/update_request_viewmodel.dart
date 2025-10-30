import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_request_templemodel/update_request_temple_model.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class UpdateRequestViewModel extends ChangeNotifier {
  final TempleService _templeService = TempleService();

  int page = 1;
  final int limit = 10;
  bool hasMore = true;
  bool isLoading = false;
  bool isLoadingMore = false;

  int? expandedIndex;
  final Map<int, Map<String, String>> rejectedReasons = {};
  List<TempleRequest> requests = [];
  final Map<int, Set<String>> approvedFields = {};

  Future<void> fetchUpdateRequests({bool reset = false}) async {
    if (reset) {
      page = 1;
      hasMore = true;
      requests.clear();
      notifyListeners();
    }

    if (!hasMore) return;

    if (page == 1) {
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    try {
      final response = await _templeService.fetchUpdateRequests(page: page, limit: limit);

      if (response.data != null && response.data!.requests.isNotEmpty) {
        requests.addAll(response.data!.requests);

        if (response.data!.requests.length < limit) {
          hasMore = false;
        } else {
          page++;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      debugPrint("Error fetching update requests: $e");
      hasMore = false;
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }
}
