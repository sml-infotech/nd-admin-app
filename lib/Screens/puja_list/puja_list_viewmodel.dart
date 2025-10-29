import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class PujaListViewmodel extends ChangeNotifier {
  List<PujaData> pujaList = [];
  bool isLoading = true;  // Initially, set to false so it doesn't show loading by default.
  final TempleService templeService = TempleService();
String? selectedTemple;
  List<Temple> templeData = [];
  List<String> templeList = [];
  int page = 1;
  int limit = 10;
  String templeId='';

  Future<void> fetchPujas({required String templeId}) async {
    try {
      // Set loading to true before starting the network request
      isLoading = true;
      notifyListeners();  // Notify listeners that loading state has changed

      final response = await templeService.getPujas(templeId);

      if (response.data.isNotEmpty) {
        pujaList = response.data;
        print("pujaList: $pujaList");
      } else {
        print("No Pujas found");
        pujaList = [];  // Ensure pujaList is empty if no data is returned
      }
    } catch (e) {
      print("Error fetching pujas: $e");
      pujaList = [];  // Ensure pujaList is empty in case of an error
    } finally {
      isLoading = false;  // Set loading to false after the request completes
      notifyListeners();  // Notify listeners that loading has finished
    }
  }

  // Fetch Temples (for reference, you can apply similar changes to this method)
  Future<void> getTemples({bool reset = false}) async {
   

    isLoading = true;
    notifyListeners();

    if (reset) {
      templeData.clear();
      templeList.clear();
      page = 1;
    }

    final response = await templeService.getTemples(page: page, limit: limit);

    if (response.data != null && response.data!.isNotEmpty) {
      templeData.addAll(response.data!);
      templeId=response.data!.first.id;
      selectedTemple=response.data!.first.name;
      templeList = templeData.map((t) => t.name).toList();
      page++;
    }

    isLoading = false;
    notifyListeners();
  }
}
