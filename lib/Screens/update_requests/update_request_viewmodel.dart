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

  /// 👇 Add this field for role
  String userRole = '';

  void setUserRole(String role) {
    userRole = role;
    notifyListeners();
  }

  

Future<void> fetchUpdateRequests({bool reset = false}) async {
  if (isLoading || isLoadingMore) return;

  if (reset) {
    page = 1;
    hasMore = true;
    requests.clear();
    notifyListeners();
  }

  if (!hasMore) return;

  const int maxExtraPages = 5;
  int extraFetchedPages = 0;

  try {
    if (page == 1) {
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    bool continueFetching = true;

    /// ✅ Send status **only for Admins**
    String? status;
    if (userRole.toLowerCase() == "super admin" ||
        userRole.toLowerCase() == "admin") {
      status = "Pending";
    } else {
      status = null; // 👈 No status filter for other roles
    }

    while (continueFetching) {
      if (!hasMore) break;

      debugPrint(
        '[fetchUpdateRequests] fetching page: $page (role=$userRole, status=${status ?? "none"})',
      );

      final response = await _templeService.fetchUpdateRequests(
        page: page,
        limit: limit,
        status: status ?? "", // 👈 Only send if not null
      );

      final newRequests = response.data?.requests ?? <TempleRequest>[];

      if (newRequests.isNotEmpty) {
        requests.addAll(newRequests);
        if (newRequests.length < limit) {
          hasMore = false;
        } else {
          page++;
        }
      } else {
        hasMore = false;
      }

      extraFetchedPages++;
      if (extraFetchedPages >= maxExtraPages) {
        continueFetching = false;
      }
    }
  } catch (e, st) {
    debugPrint("Error fetching update requests: $e\n$st");
    hasMore = false;
  } finally {
    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }
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
        rejected?.values.join(', ') ?? '',
      );

      if (response.code == 200) {
        isLoadingForApproval = false;
        isUpdated = true;
        message = response.message;
        notifyListeners();
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
    hasMore = true;
    isLoading = false;
    isLoadingMore = false;
    isLoadingForApproval = false;
    isUpdated = false;
    message = '';
    expandedIndex = null;
    requests = [];
    rejectedReasons.clear();
    approvedFields.clear();
  }
}
