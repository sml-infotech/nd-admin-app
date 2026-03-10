import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/event_service.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart'
    show TempleService;

class EventListViewmodel extends ChangeNotifier {
  int templePage = 1;
  int eventPage = 1;

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

  Future<void> fetchEvents(
    String templeId,
    bool reset, {
    String query = "",
  }) async {
    if (isLoading || isLoadingMore) return;

    if (reset) {
      events.clear();
      eventPage = 1;
      hasMore = true;
    }

    if (eventPage == 1) {
      isLoading = true;
    } else {
      isLoadingMore = true;
    }

    notifyListeners();

    try {
      final response = await eventService.fetchEventes(
        page: eventPage,
        limit: limit,
        temple_id: templeId,
        search: query, // send search query to API
      );

      events.addAll(response.events);

      if (response.events.length < limit) {
        hasMore = false;
      } else {
        eventPage++;
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
    if (isLoadingMore) return;
    isLoading = true;
    if (reset) {
      templePage = 1;
      templeData.clear();
    }

    isLoadingMore = true;
    notifyListeners();

    final response = await templeService.getTemples(page: templePage);

    if (response.data != null && response.data!.isNotEmpty) {
      templeData.addAll(response.data!);
      templePage++;
    }

    isLoadingMore = false;
    isLoading = false;
    notifyListeners();
  }

  void reset() {
    templePage = 1;
    eventPage = 1;
    int limit = 10;
    isLoading = false;
    isLoadingMore = false;
    hasMore = true;
    eventService = EventService();
    templeService = TempleService();
    events = [];
    templeData = [];
    selectedTempleId = "";
    selectedTemple = null;
    templeList = [];
    notifyListeners();
  }
}
