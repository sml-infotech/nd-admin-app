import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class CreateEventViewmodel extends ChangeNotifier {
  TempleService templeService = TempleService();
  TextEditingController eventController = TextEditingController();
    TextEditingController descriptionContoller = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController contactNameController = TextEditingController();
    TextEditingController contactNumberController = TextEditingController();

  List<Temple> templeData = [];
  Temple? selectedTemple;
  String selectedTempleId = '';
  DateTime ?selectedStartDate ;
  DateTime ?selectedEndDate ;

  void setSelectedTemple(Temple temple) {
    selectedTemple = temple;
    print('Selected Temple: ${temple.name}');
    notifyListeners();
  }

  int page = 1;
  final int limit = 10;
  bool isLoading = false;
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

    final response = await templeService.getTemples(page: page, limit: limit);

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
}
