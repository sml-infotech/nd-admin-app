import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/event_service.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart'
    show TempleService;

class EventListViewmodel extends ChangeNotifier {
  int page = 1;
  final int limit = 10;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  EventService eventService = EventService();
  TempleService templeService = TempleService();
  List<EventItem> events = [];
  List<Temple> templeData = [];
  String? selectedTempleId;
  Temple? selectedTemple;
  void setSelectedTemple(Temple temple) {
    selectedTemple = temple;
    print('Selected Temple: ${temple.name}');
    notifyListeners();
  }

  Future<void> fetchEvents(String trempleId,bool reset ) async {
    if (isLoading || isLoadingMore) return;

    if (reset) {
      events.clear();
      page = 1;
      hasMore = true;
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
        temple_id: trempleId ?? '',
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

  List<String> templeList = [];
  Future<void> getTemples({bool reset = false}) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    if (reset) {
      templeData.clear();
      templeList.clear();
      page = 1;
    }

    final response = await templeService.getTemples();

    if (response.data != null && response.data!.isNotEmpty) {
      templeData.addAll(response.data!);
      templeList = templeData.map((t) => t.name).toList();
      selectedTempleId = templeData.first.id;
      page++;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  void  reset() {
      page = 1;
   int limit = 10;
   isLoading = false;
   isLoadingMore = false;
   hasMore = true;
   eventService = EventService();
   templeService = TempleService();
  events = [];
 templeData = [];
   selectedTempleId="";
  selectedTemple = null;
  templeList = [];
    notifyListeners();
  }
}
