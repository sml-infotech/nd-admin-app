
import 'dart:io';

import 'package:flutter/material.dart';

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

  final List<String> temples = [];
  final List<File> images = [];
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
    return templeName.text.trim().isNotEmpty &&
        address.text.trim().isNotEmpty &&
        city.text.trim().isNotEmpty &&
        state.text.trim().isNotEmpty &&
        pincode.text.trim().isNotEmpty &&
        architecture.text.trim().isNotEmpty &&
        email.text.trim().isNotEmpty &&
        isValidEmail(email.text) &&
        phone.text.trim().isNotEmpty &&
        phone.text.length==10&&
        temples.isNotEmpty&&images.isNotEmpty&&
        description.text.trim().isNotEmpty;
  }
  bool isValidEmail(String email) {
  final regex = RegExp(
      r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

}
