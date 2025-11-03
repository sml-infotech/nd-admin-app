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

 List<TempleRequest> get visibleRequests =>
      requests.where((r) => r.status != 'PartiallyReviewed' && r.status != 'Completed').toList();
  Future<void> fetchUpdateRequests({bool reset = false}) async {
    if (isLoading || isLoadingMore) return;

    if (reset) {
      page = 1;
      hasMore = true;
      requests.clear();
      notifyListeners();
    }

    if (!hasMore) return;

    // Use a loop to fetch enough pages so the visible list is reasonably full.
    // Safety: cap number of pages to fetch in one call to avoid infinite loops.
    const int maxExtraPages = 5; // tweak if needed
    int extraFetchedPages = 0;

    try {
      // If first page, set isLoading, otherwise isLoadingMore (UI difference)
      if (page == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      notifyListeners();

      bool continueFetching = true;

      while (continueFetching) {
        // Prevent concurrent double-calls
        if (!hasMore) break;

        debugPrint('[fetchUpdateRequests] fetching page: $page');

        final response = await _templeService.fetchUpdateRequests(page: page, limit: limit);

        // If response structure differs, adapt accordingly
        final newRequests = response.data?.requests ?? <TempleRequest>[];

        if (newRequests.isNotEmpty) {
          requests.addAll(newRequests);

          // If server returned less than limit => no more pages
          if (newRequests.length < limit) {
            hasMore = false;
          } else {
            // there might be more pages
            page++;
          }
        } else {
          // no new items on this page
          hasMore = false;
        }

        // After adding, check how many visible requests we have
        final int visibleCount = visibleRequests.length;
        debugPrint('[fetchUpdateRequests] visibleCount=$visibleCount, hasMore=$hasMore');

        // Stop fetching if:
        // - visibleCount >= limit (we have a page full of visible items),
        // - or there are no more pages,
        // - or we already fetched the allowed extra pages.
        extraFetchedPages++;
        final bool reachedEnoughVisible = visibleCount >= limit;
        final bool reachedMaxExtra = extraFetchedPages >= maxExtraPages;

        if (reachedEnoughVisible || !hasMore || reachedMaxExtra) {
          continueFetching = false;
        } else {
          // We will loop and fetch next page
          isLoadingMore = true;
          notifyListeners();
        }
      }
    } catch (e, st) {
      debugPrint("Error fetching update requests: $e\n$st");
      // on error, stop further trying to fetch in this flow
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
