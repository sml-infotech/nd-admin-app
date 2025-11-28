import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/post_master_temple_model.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class CreateMasterViewmodel extends ChangeNotifier {
  bool isLoading = false; // API call loader
  bool isExcelLoading = false; // Excel upload loader
  bool showExcelPopup = false; // Popup visibility

  String message = '';
  bool isCreateUserSuccess = false;

  TempleService templeService = TempleService();

  final TextEditingController templeName = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController pincode = TextEditingController();

  List<MasterTemple> excelTemples = [];

  /// -----------------------------
  /// VALIDATION
  /// -----------------------------
  Future<void> validateUser() async {
    String temple = templeName.text.trim();
    String Address = address.text.trim();
    String City = city.text.trim();
    String statee = state.text.trim();
    String pinCode = pincode.text.trim();

    if (temple.isEmpty) {
      message = "Please enter Name";
    } else if (Address.isEmpty) {
      message = "Please enter Address";
    } else if (City.isEmpty) {
      message = "Please enter City";
    } else if (statee.isEmpty) {
      message = "State is Mandatory";
    } else if (pinCode.isEmpty) {
      message = "Pincode is Mandatory";
    } else {
      message = "";
      return;
    }

    notifyListeners();
  }

  /// -----------------------------
  /// POST API
  /// -----------------------------
  Future<void> createMasterTemple() async {
    if (excelTemples.isEmpty) {
      message = "Add at least one temple";
      notifyListeners();
      return;
    }

    try {
      message = "";

      isLoading = true;
      notifyListeners();

      final response = await TempleService().postMasterTemple(excelTemples);

      message = response.message ?? "Success";
      excelTemples.clear();
      showExcelPopup = false;
      reset();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      message = "Something went wrong: $e";
      isLoading = false;
      excelTemples.clear();
      showExcelPopup = false;

      notifyListeners();
    }
  }

  /// -----------------------------
  /// EXCEL POPUP CONTROLS
  /// -----------------------------
  void setExcelLoading(bool value) {
    isExcelLoading = value;
    notifyListeners();
  }

  void openExcelPopup() {
    showExcelPopup = true;
    notifyListeners();
  }

  void closeExcelPopup() {
    showExcelPopup = false;
    excelTemples.clear();

    notifyListeners();
  }

  void removeTemple(int index) {
    excelTemples.removeAt(index);
        if(excelTemples.isEmpty){
          showExcelPopup = false;

    }
    notifyListeners();
  }

  void reset() {
    templeName.clear();
    address.clear();
    city.clear();
    state.clear();
    pincode.clear();
  }
}
