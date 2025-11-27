import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/master_temple_list_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/post_master_temple_model.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class MasterTempleListViewmodel extends ChangeNotifier {
  final TempleService api = TempleService();

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

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
}
