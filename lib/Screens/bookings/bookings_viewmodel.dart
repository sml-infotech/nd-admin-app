import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/model/login_model/booking_model/booking_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class BookingsViewmodel extends ChangeNotifier {
  List<BookingModel> bookings = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool isUpdating = false;

  List<Temple> templeData = [];
  String? selectedTemple;
  String? selectedTempleId;
  int selectedSegment = 0;
  final List<String> segments = ["Today", "Tomorrow", "Upcoming", "Past"];
  final TempleService api = TempleService();
  int page = 1;
  int? expandedIndex;

  String? userRole;

  void setExpanded(int index) {
    expandedIndex = expandedIndex == index ? null : index;
    notifyListeners();
  }

  void setUserRole(String role) {
    userRole = role;
    notifyListeners();
  }

  void resetBookings() {
    page = 1;
    bookings.clear();
    hasMore = true;
    notifyListeners();
  }

  /// Fetch temples list
  Future<void> fetchTemples() async {
    isLoading = true;
    notifyListeners();

    final response = await api.getTemples(page: 1, limit: 2000);

    if (response.data != null && response.data!.isNotEmpty) {
      templeData = response.data!;
      selectedTemple = templeData.first.name;
      selectedTempleId = templeData.first.id;

      await fetchBookings();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBookings({
    bool reset = false,
    String filter = "today",
  }) async {
    if (selectedTempleId == null) return;

    if (reset) {
      page = 1;
      bookings.clear();
      hasMore = true;
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    try {
      final result = await api.fetchBookings(
        selectedTempleId!,
        page: page,
        filter: filter,
      );
      final newItems = result.data ?? [];

      List<BookingModel> filtered = newItems;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      if (filter == "today") {
        filtered = newItems
            .where(
              (b) =>
                  DateTime.parse(
                    b.pujaDate,
                  ).toLocal().difference(today).inDays ==
                  0,
            )
            .toList();
      } else if (filter == "tomorrow") {
        filtered = newItems
            .where(
              (b) =>
                  DateTime.parse(
                    b.pujaDate,
                  ).toLocal().difference(today).inDays ==
                  1,
            )
            .toList();
      }

      if (filtered.isNotEmpty) {
        bookings.addAll(filtered);
        page++; // increment page only if API returned data
      } else if (newItems.length < result.limit) {
        hasMore = false; // no more pages
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  void selectTemple(Temple temple) async {
    selectedSegment = 0;

    selectedTemple = temple.name;
    selectedTempleId = temple.id;

    Navigator.pop(_bottomSheetContext!);

    /// Fetch bookings for the newly selected temple
    await fetchBookings(reset: true);
  }

  BuildContext? _bottomSheetContext;

  void openTempleBottomSheet(BuildContext context) {
    _bottomSheetContext = context;
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: templeData.length,
        itemBuilder: (_, index) {
          final temple = templeData[index];
          return Padding(
            padding: EdgeInsetsGeometry.fromLTRB(5, 10, 0, 0),
            child: ListTile(
              title: Text(temple.name, style: TextStyle(fontFamily: font)),
              onTap: () => selectTemple(temple),
            ),
          );
        },
      ),
    );
  }

  void reset() {
    bookings = [];
    isLoading = false;
    isLoadingMore = false;
    hasMore = true;
    isUpdating = false;

    templeData = [];
    selectedTemple = null;
    selectedTempleId = null;
    selectedSegment = 0;
    page = 1;
    expandedIndex = null;

    bookings.clear();
    hasMore = true;
    notifyListeners();
    userRole = null;
    notifyListeners();
  }
}
