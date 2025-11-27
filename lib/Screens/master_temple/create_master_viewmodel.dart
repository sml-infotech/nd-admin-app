import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/post_master_temple_model.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class CreateMasterViewmodel extends ChangeNotifier {
  bool isLoading = false;
  String message = '';
  bool isCreateUserSuccess = false;
TempleService templeService=TempleService();
  final TextEditingController templeName = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  List<MasterTemple> excelTemples = [];

   Future<void> validateUser() async {
    String temple = templeName.text.trim();
    String Address = address.text.trim();
    String City = city.text.trim();
    String statee = state.text.trim();
    String pinCode = pincode.text.trim();


    if (temple.isEmpty) {
      message = "Please enter Name";
    }
    else if (Address.isEmpty) {
      message = "Please enter Address";
    }  else if (City.isEmpty) {
      message = "Please enter City";
    } else if (statee.isEmpty) {
      message = "State is Mandaratory";
    } 
    else if (pinCode.isEmpty) {
      message = "pinCode is Mandaratory";
    } 
     else {
      message = "";
      // await createUser();
      return;
    }

    notifyListeners();
  }

 Future<void> createMasterTemple() async {
    if (excelTemples.isEmpty) {
      message = "Add at least one temple";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      // Call your API service
      final response = await TempleService().postMasterTemple(excelTemples);

      message = response.message ?? "Success";
      isLoading = false;
      excelTemples.clear();
      reset();
      notifyListeners();
    } catch (e) {
      message = "Something went wrong: $e";
      isLoading = false;
      notifyListeners();
    }
  }




void reset(){
    templeName .clear();
   address .clear();
   city .clear();
  state.clear();
   pincode .clear();
}
}
