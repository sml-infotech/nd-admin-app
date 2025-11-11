import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/toggleactivemodel/toggle_active_model.dart';
import 'package:nammadaiva_dashboard/service/puja_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class PujaListViewmodel extends ChangeNotifier {
  final TempleService templeService = TempleService();
  final PujaService pujaService = PujaService();

  List<PujaData> pujaList = [];
  List<PujaDataForActive> pujaDataForActive = [];
  List<Temple> templeData = [];
  List<String> templeList = [];

  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMorePujas = true;
  bool isToggling = false;

  int _currentPage = 1;
  int _itemsPerPage = 10;

  String? selectedTemple;
  String templeId = '';
  String message = '';
  bool? isActive;

  Future<void> fetchPujas({bool reset = false}) async {
    try {
      if (reset) {
        _currentPage = 1;
        pujaList.clear();
        hasMorePujas = true;
      }

      if (!hasMorePujas) return;

      if (_currentPage == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      notifyListeners();

      final response = await templeService.getPujas(
        templeId,
        page: _currentPage,
        limit: _itemsPerPage,
      );

      if (response.code == 200) {
        final newPujas = response.data.pujas;

        if (reset || _currentPage == 1) {
          pujaList = newPujas;
        } else {
          pujaList.addAll(newPujas);
        }

        // ✅ if server returns fewer than requested items → no more data
        hasMorePujas = newPujas.length == _itemsPerPage;
        if (hasMorePujas) {
          _currentPage++;
        }
      } else {
        hasMorePujas = false;
      }
    } catch (e) {
      print("⚠️ Error fetching pujas: $e");
      hasMorePujas = false;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePujas() async {
    if (isLoadingMore || !hasMorePujas) return;
    await fetchPujas(reset: false);
  }

  Future<void> getTemples({bool reset = false}) async {
    isLoading = true;
    notifyListeners();

    if (reset) {
      templeData.clear();
      templeList.clear();
    }

    final response = await templeService.getTemples(page: 1, limit: 50);

    if (response.data != null && response.data!.isNotEmpty) {
      templeData = response.data!;
      templeId = templeData.first.id;
      selectedTemple = templeData.first.name;
      templeList = templeData.map((t) => t.name).toList();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> toggleActivate(String pujaId, bool toggle) async {
    try {
      final response = await pujaService.activateToggle(pujaId, toggle);

      if (response.code == 200 && response.data != null) {
        pujaDataForActive = [response.data!];
        message = response.message ?? "Updated successfully";
        isActive = response.data!.isActive ?? toggle;
        notifyListeners();
        return true;
      } else {
        message = response.message ?? "Some error occurred";
        notifyListeners();
        return false;
      }
    } catch (e) {
      message = "Something went wrong: $e";
      notifyListeners();
      return false;
    }
  }

  void resetPagination() {
    _currentPage = 1;
    hasMorePujas = true;
    pujaList.clear();
    notifyListeners();
  }

  void reset() {
    pujaList = [];
    pujaDataForActive = [];
    templeData = [];
    templeList = [];

    isLoading = true;
    isLoadingMore = false;
    hasMorePujas = true;
    isToggling = false;

    _currentPage = 1;
    _itemsPerPage = 10;

    selectedTemple = "";
    templeId = '';
    message = '';
    isActive = false;
    notifyListeners();
  }
}
