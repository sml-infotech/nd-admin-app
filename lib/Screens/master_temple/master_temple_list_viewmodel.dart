import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/master_temple_list_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/post_master_temple_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_onboard/update_onboard_model.dart'
    show UpdateOnboardModel;
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class MasterTempleListViewmodel extends ChangeNotifier {
  final TempleService api = TempleService();

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String message = "";
  String language = "en";

  int page = 1;
  List<MasterTempleListModal> temples = [];

  Future<void> fetchTemples({bool reset = false}) async {
    try {
      if (reset) {
        page = 1;
        hasMore = true;
        temples.clear();
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      notifyListeners();

      final response = await api.fetchMasterTemples(page: page, limit: 10);
      if (response.data.isNotEmpty) {
        temples.addAll(response.data!);
        page++;
      } else {
        hasMore = false;
      }
    } catch (e) {
      debugPrint("Error fetching temples: $e");
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

Future<void> updateOnboard(String templeId, bool newValue) async {
  try {
    final index = temples.indexWhere((t) => t.id == templeId);
    if (index != -1) {
      temples[index] = temples[index].copyWith(isOnboarded: newValue);
      notifyListeners();
    }

    isLoading = true;
    notifyListeners();

    var data = UpdateOnboardModel(
      temple_id: templeId,
      is_onboarded: newValue,
    );

    await api.updateOnboard(data);

    isLoading = false;
    notifyListeners();

  } catch (e) {
    final index = temples.indexWhere((t) => t.id == templeId);
    if (index != -1) {
      temples[index] = temples[index].copyWith(isOnboarded: !newValue);
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }
}



  void reset() {
    isLoading = false;
    isLoadingMore = false;
    hasMore = true;

    page = 1;
    temples = [];
    notifyListeners();
  }
}
