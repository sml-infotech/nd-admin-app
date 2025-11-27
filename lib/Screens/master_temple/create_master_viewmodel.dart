import 'package:flutter/material.dart';

class CreateMasterViewmodel extends ChangeNotifier {
  bool isLoading = false;
  String message = '';
  bool isCreateUserSuccess = false;

  final TextEditingController templeName = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  List<TempleModelExcel> excelTemples = [];

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

void reset(){
    templeName .clear();
   address .clear();
   city .clear();
  state.clear();
   pincode .clear();
}
}
class TempleModelExcel {
  final String templeName;
  final String address;
  final String city;
  final String state;
  final String pincode;

  TempleModelExcel({
    required this.templeName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
  });
}