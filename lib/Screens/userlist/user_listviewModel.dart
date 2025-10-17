import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/user_listModel.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';


class UserViewModel extends ChangeNotifier {
  final AuthService authService = AuthService();

  List<UserModel> userData = [];
  List<UserModel> get users => userData;

  bool isLoading = true;


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
}
