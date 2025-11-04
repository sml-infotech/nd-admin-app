import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/event_service.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';

class EventListViewmodel extends ChangeNotifier {
  int page = 1;
  final int limit = 10;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  EventService eventService = EventService();
  List<EventItem> events = [];

  Future<void> fetchEvents({bool refresh = false}) async {
    if (isLoading || isLoadingMore) return;

    if (refresh) {
      page = 1;
      hasMore = true;
      events.clear();
    }

    // Set loading state based on page
    if (page == 1) {
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    try {
      final response = await eventService.fetchEventes(
        page: page,
        limit: limit,
        temple_id: "21e37f32-388c-46a6-9249-70d6b9a6448f",
      );

      events.addAll(response.events);
      
      // Check if more data is available
      if (response.events.length < limit) {
        hasMore = false;
      } else {
        page++;
      }
    } catch (e) {
      print("Error fetching events: $e");
      hasMore = false;
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }
}
