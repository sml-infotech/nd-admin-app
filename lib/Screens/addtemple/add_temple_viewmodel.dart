
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';

class AddTempleViewmodel extends ChangeNotifier {
  TextEditingController templeName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController architecture = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController templeController = TextEditingController();
  var authService = AuthService();

  bool isLoading=false;
  String message="";
  String presignedURL="";

  final List<String> temples = [];
  final List<File> images = [];
  bool templeAdded=false;
AddTempleViewmodel() {
  templeName.addListener(_onChange);
  address.addListener(_onChange);
  city.addListener(_onChange);
  state.addListener(_onChange);
  pincode.addListener(_onChange);
  architecture.addListener(_onChange);
  email.addListener(_onChange);
  phone.addListener(_onChange);
  description.addListener(_onChange);
  templeController.addListener(_onChange);
}

void _onChange() {
  notifyListeners();
}
  void addImage(File image) {
    images.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }


 void addTemple(String name) {
    temples.add(name);
    notifyListeners();
  }

  void removeTemple(int index) {
    temples.removeAt(index);
    notifyListeners();
  }

 bool validateAddTemple() {
  if (templeName.text.trim().isEmpty) {
    message = "Temple name cannot be empty";
    return false;
  }
  if (address.text.trim().isEmpty) {
    message = "Address cannot be empty";
    return false;
  }
  if (city.text.trim().isEmpty) {
    message = "City cannot be empty";
    return false;
  }
  if (state.text.trim().isEmpty) {
    message = "State cannot be empty";
    return false;
  }
  if (pincode.text.trim().isEmpty) {
    message = "Pincode cannot be empty";
    return false;
  }
  if (architecture.text.trim().isEmpty) {
    message = "Architecture cannot be empty";
    return false;
  }
  if (email.text.trim().isEmpty) {
    message = "Email cannot be empty";
    return false;
  }
  if (!isValidEmail(email.text.trim())) {
    message = "Invalid email address";
    return false;
  }
  if (phone.text.trim().isEmpty) {
    message = "Phone number cannot be empty";
    return false;
  }
  if (phone.text.trim().length != 10) {
    message = "Phone number must be 10 digits";
    return false;
  }
  if (temples.isEmpty) {
    message = "Please add at least one deity";
    return false;
  }
  if (images.isEmpty) {
    message = "Please upload at least one image";
    return false;
  }
  if (description.text.trim().isEmpty) {
    message = "Description cannot be empty";
    return false;
  }

  
  return true;
}

  bool isValidEmail(String email) {
  final regex = RegExp(
      r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

Future<void> presignedUrl() async {

    try {
        isLoading=true;
        notifyListeners();
      final response = await authService.presignedUrl(
        temples.first,temples.first
      );
      if (response.message.isNotEmpty) {
        print("->>> $response");
        presignedURL=response.url;
        message = response.message ?? "success";
        await addTempleApi();
        notifyListeners();
      } 
      // else if(response.code==409){
      //   isLoading=false;
      //   message = response.message ?? "user not Found";
      //   notifyListeners();
      // }
      else {
        isLoading=false;
        notifyListeners();
        message =  "some error occurred";
        print("message $message");
      }
    } catch (e) {
      isLoading=false;
      notifyListeners();
   
    }
  }







Future<void> addTempleApi() async {

    try {
        isLoading=true;
        notifyListeners();
      final response = await authService.addTemple(
        templeName.text.trim(),
        address.text.trim(),
        city.text.trim(),
        state.text.trim(),
        pincode.text.trim(),
        architecture.text.trim(),
        phone.text.trim(),
        email.text.trim(),
        description.text.trim(),
        temples,
        [presignedURL],
      );
      if (response.code==201) {
        print("->>> $response");
        message = response.message ?? "success";
        isLoading=false;
        templeAdded=true;
        notifyListeners();
      } 
      else if(response.code==409){
        isLoading=false;
        message = response.message ?? "user not Found";
        print(">>>>>>>>?????${message}");
        notifyListeners();
      }
      else {
        isLoading=false;
        notifyListeners();
        message =  "some error occurred";
        print("message $message");
      }
    } catch (e) {
      isLoading=false;
      notifyListeners();
   
    }
  }

   @override
  void dispose() {
  templeName.clear();
  address.clear();
  city.clear();
  state.clear();
  pincode.clear();
  architecture.clear();
  email.clear();
  phone.clear();
  description.clear();
  templeController.clear();
  temples.clear();
  images.clear();
  notifyListeners();


  }
}
