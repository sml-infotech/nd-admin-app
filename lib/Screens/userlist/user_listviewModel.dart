import 'dart:core';

import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/edit_userresponse.dart';
import 'package:nammadaiva_dashboard/model/login_model/user_listModel.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';


class UserViewModel extends ChangeNotifier {
  final AuthService authService = AuthService();
  final TextEditingController role = TextEditingController();

  List<UserModel> userData = [];
  List<UserModel> get users => userData;

  List <EditUserResponse> editData=[];
  List <EditUserResponse> get editdata =>editData;

  bool isLoading = true;
  bool editloading =false;


  Future<void> getUsers({bool reset = false}) async {

    isLoading = true;
    notifyListeners();

  
    try {
      final response = await authService.getUserDetails();

      if (response.users.isNotEmpty) {
        userData.addAll(response.users);
      }
          isLoading = false;

    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }


Future<void> editUser(String userId, String name, bool isActive) async {
  editloading = true;
  notifyListeners();

  try {
    final response = await authService.editUser(userId, name, role.text, isActive);

    if (response.message.isNotEmpty) {
      editData.add(response);
      int index = userData.indexWhere((user) => user.id == userId);
      if (index != -1) {
        userData[index] = UserModel(
          id: userId,
          fullName: name,
          email: userData[index].email,
          role: role.text.isNotEmpty ? role.text : userData[index].role,
          isActive: isActive,
          associatedTempleId: userData[index].associatedTempleId,
          updatedAt: DateTime.now(),
        );
      }
    }
  } catch (e) {
    print("Error: $e");
  }

  editloading = false;
  notifyListeners();
}



}
