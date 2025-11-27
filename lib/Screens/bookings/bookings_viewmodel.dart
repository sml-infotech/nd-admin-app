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

Future<void> fetchBookings({bool reset = false}) async {
  if (selectedTempleId == null) return;

  try {
    if (reset) {
      page = 1;
      bookings.clear();
      hasMore = true;
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    final result = await api.fetchBookings(selectedTempleId!, page: page); // <- pass page here
    final newItems = result.data ?? [];
    if (newItems.isNotEmpty) {
      bookings.addAll(newItems);
      page++; // increment page for next fetch
    } else {
      hasMore = false;
    }
  } catch (e) {
    debugPrint("Fetch error: $e");
  }

  isLoading = false;
  isLoadingMore = false;
  notifyListeners();
}


  void selectTemple(Temple temple) async {
    selectedTemple = temple.name;
    selectedTempleId = temple.id;
    Navigator.pop(_bottomSheetContext!); // close bottom sheet
    resetBookings();
    await fetchBookings();
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
          return Padding(padding: EdgeInsetsGeometry.fromLTRB(5, 10, 0, 0),child: 
          
          ListTile(
            title: Text(temple.name,style: TextStyle(fontFamily: font),),
            onTap: () => selectTemple(temple),
          ));
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

    page = 1;
    expandedIndex = null;

    bookings.clear();
    hasMore = true;
    notifyListeners();
    userRole = null;
    notifyListeners();
  }
}
