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
  bool isLoadingForApproval = false;
  bool isUpdated = false;
  String message = '';

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
      final response = await _templeService.fetchUpdateRequests(
        page: page,
        limit: limit,
      );

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

  Future<void> approvalTempleUpdate(String requestId, int requestIndex) async {
    try {
      isLoadingForApproval = true;
      notifyListeners();
      final Map<String, String> fieldDecisions = {};

      final approved = approvedFields[requestIndex];
      if (approved != null) {
        for (var field in approved) {
          fieldDecisions[field] = "Approved";
        }
      }

      final rejected = rejectedReasons[requestIndex];
      if (rejected != null) {
        for (var field in rejected.keys) {
          fieldDecisions[field] = "Rejected";
        }
      }

      if (fieldDecisions.isEmpty) {
        debugPrint("⚠️ No fields to send for review.");
        return;
      }

      debugPrint("📤 Sending review decisions: $fieldDecisions");

      final response = await _templeService.updateApproval(
        requestId,
        fieldDecisions,
      );
      if (response.code == 200) {
        isLoadingForApproval = false;
        isUpdated = true;
        notifyListeners();
        message = response.message;
        debugPrint("✅ Approval Response: ${response.toJson()}");
      } else {
        isLoadingForApproval = false;
        isUpdated = false;
        message = response.message;
        notifyListeners();
      }
    } catch (e) {
      isLoadingForApproval = false;
      isUpdated = false;
      message = 'Error approving temple update';
      notifyListeners();

      debugPrint("❌ Error approving temple update: $e");
    }
  }

  void reset() {
    page = 1;
    int limit = 10;
    hasMore = true;
    isLoading = false;
    isLoadingMore = false;
    isLoadingForApproval = false;
    isUpdated = false;
    message = '';

    expandedIndex = 0;
    final Map<int, Map<String, String>> rejectedReasons = {};
    requests = [];
    final Map<int, Set<String>> approvedFields = {};
  }
}
