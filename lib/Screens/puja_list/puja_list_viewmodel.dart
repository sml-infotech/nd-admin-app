import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/toggleactivemodel/toggle_active_model.dart';
import 'package:nammadaiva_dashboard/service/puja_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class PujaListViewmodel extends ChangeNotifier {
  List<PujaData> pujaList = [];
  List<PujaDataForActive> pujaDataForActive = [];
  bool isLoading = true;  
  final TempleService templeService = TempleService();
  final PujaService pujaService = PujaService();
String? selectedTemple;
  List<Temple> templeData = [];
  List<String> templeList = [];
  int page = 1;
  int limit = 10;
  String templeId='';
  String message = '';
  String puja_id='';
  bool ?isActive;
bool isToggling = false;


  Future<void> fetchPujas({required String templeId}) async {
    try {
      isLoading = true;
      notifyListeners();  

      final response = await templeService.getPujas(templeId);

      if (response.data.isNotEmpty) {
        pujaList = response.data;
        print("pujaList: $pujaList");
      } else {
        print("No Pujas found");
        pujaList = [];
      }
    } catch (e) {
      print("Error fetching pujas: $e");
      pujaList = []; 
    } finally {
      isLoading = false;  
      notifyListeners();  
    }
  }

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

   Future<bool> toggleActivate(String pujaId, bool toggle) async {
  try {
    final response = await pujaService.activateToggle(pujaId, toggle);

    if (response.code == 200 && response.data != null) {
      pujaDataForActive=response.data != null ? [response.data!] : [];
      message = response.message ?? "Updated successfully";
      isActive = response.data!.isActive ?? toggle; // ✅ sync from backend
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

}
