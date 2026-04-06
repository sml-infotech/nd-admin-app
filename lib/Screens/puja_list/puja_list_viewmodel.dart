import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/toggleactivemodel/toggle_active_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/toggleprasadaddressmodel/toggle_prasad_address_model.dart';
import 'package:nammadaiva_dashboard/service/puja_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class PujaListViewmodel extends ChangeNotifier {
  final TempleService templeService = TempleService();
  final PujaService pujaService = PujaService();
  String language = "en";

  List<PujaData> pujaList = [];
  List<PujaDataForActive> pujaDataForActive = [];
  List<Temple> templeData = [];
  List<String> templeList = [];

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMorePujas = true;
  bool isToggling = false;
  bool isFetchingNextPage = false; // To show loader at the bottom of the list
  int _currentPage = 1;
  int _itemsPerPage = 10;
  bool hasNextPage = true;
  String? selectedTemple;
  String templeId = '';
  String message = '';
  bool? isActive;
  bool? isPrasadAvailable;

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
    if (isLoading || isFetchingNextPage) return;

    if (reset) {
      _currentPage = 1;
      hasNextPage = true;
      templeData.clear();
      templeList.clear();
      isLoading = true;
    } else {
      if (!hasNextPage) return;
      isFetchingNextPage = true;
      _currentPage++; // ✅ increment only once here
    }

    notifyListeners();

    try {
      final response = await templeService.getTemples(
        page: _currentPage,
        limit: 10,
      );

      if (response.data != null && response.data!.isNotEmpty) {
        templeData.addAll(response.data!);
        templeList = templeData.map((t) => t.name).toList();

        // ✅ If less than limit, no more pages
        if (response.data!.length < 10) {
          hasNextPage = false;
        }
      } else {
        hasNextPage = false;
      }
    } catch (e) {
      debugPrint("Error fetching temples: $e");
    } finally {
      isLoading = false;
      isFetchingNextPage = false;
      notifyListeners();
    }
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

  Future<bool> togglePrasadAvailable(String pujaId, bool toggle) async {
    try {
      // Find the puja and update locally first
      final pujaIndex = pujaList.indexWhere((puja) => puja.id == pujaId);
      if (pujaIndex == -1) {
        message = "Puja not found";
        notifyListeners();
        return false;
      }

      // Update the local puja
      pujaList[pujaIndex].requiresPrasadAddress = toggle;
      notifyListeners();

      // Make API call
      final response = await pujaService.togglePrasadAddress(pujaId, toggle);

      if (response.code == 200) {
        message = response.message ?? "Updated successfully";
        notifyListeners();
        return true;
      } else {
        // Revert on failure
        pujaList[pujaIndex].requiresPrasadAddress = !toggle;
        message = response.message ?? "Some error occurred";
        notifyListeners();
        return false;
      }
    } catch (e) {
      // Find and revert on error
      final pujaIndex = pujaList.indexWhere((puja) => puja.id == pujaId);
      if (pujaIndex != -1) {
        pujaList[pujaIndex].requiresPrasadAddress = !toggle;
      }
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

  Future<void> reset({bool skipNotify = false}) async {
    pujaList = [];
    pujaDataForActive = [];
    // templeData = [];
    // templeList = [];

    isLoading = true;
    isLoadingMore = false;
    hasMorePujas = true;
    isToggling = false;

    _currentPage = 1;
    _itemsPerPage = 10;

    selectedTemple = null;
    templeId = '';
    message = '';
    isActive = false;
    print(">-------->>>>>");
    if (!skipNotify) {
      notifyListeners();
    }
    return;
  }
}
