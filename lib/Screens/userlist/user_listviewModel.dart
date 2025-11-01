import 'dart:core';
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/edit_userresponse.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/user_listModel.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService authService = UserService();
  final TextEditingController role = TextEditingController();
  final TempleService templeService = TempleService();

  List<UserModel> userData = [];
  List<UserModel> get users => userData;
 List<Map<String, dynamic>> templeList = []; 

  List<EditUserResponse> editData = [];
  List<EditUserResponse> get editdata => editData;

  bool isLoading = true;
  bool editLoading = false;

List<String> selectedTempleIds = [];
  bool hasMore = true;
  int page = 1;
  final int _pageSize = 10;
  List<Temple> _templeData = [];

  final Map<String, bool> _tempActiveMap = {};
  bool getTempActive(String userId) => _tempActiveMap[userId] ?? false;
  void setTempActive(String userId, bool value) {
    _tempActiveMap[userId] = value;
    notifyListeners();
  }

  Future<void> getUsers({bool reset = false}) async {
    if (reset) {
      page = 1;
      hasMore = true;
      userData.clear();
    }

    if (!hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final response = await authService.getUserDetails(page: page, pageSize: _pageSize);

      if (response.users.isNotEmpty) {
        userData.addAll(response.users);
        if (response.users.length < _pageSize) {
          hasMore = false; // no more pages
        } else {
          page++; // next page
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      print("Error fetching users: $e");
      hasMore = false;
    }

    isLoading = false;
    notifyListeners();
  }

  /// Fetch more users (pagination)
  Future<void> fetchMoreUsers() async {
    if (!hasMore) return;
    await getUsers();
  }

  /// Edit user API call
  Future<void> editUser(String userId, String name, bool isActive) async {
    editLoading = true;
    notifyListeners();

    try {
      final response = await authService.editUser(userId, name, role.text, isActive);

      if (response.message.isNotEmpty) {
        editData.add(response);

        // Update local user list immediately
        final index = userData.indexWhere((user) => user.id == userId);
        if (index != -1) {
          userData[index] = UserModel(
            id: userId,
            fullName: name,
            email: userData[index].email,
            role: role.text.isNotEmpty ? role.text : userData[index].role,
            isActive: isActive,
           
            updatedAt:"", phoneNumber: '', createdAt: '', associatedTemples: [],
          );
        }
      }
    } catch (e) {
      print("Error editing user: $e");
    }

    editLoading = false;
    notifyListeners();
  }

   Future<void> getTemples({bool reset = false}) async {

    isLoading = true;
    notifyListeners();

    final response = await templeService.getTemples(page: 1, limit: 10);

    if (response.data != null && response.data!.isNotEmpty) {
      _templeData.addAll(response.data!);
templeList = _templeData
        .map((t) => {
              "id": t.id.toString(),
              "name": t.name.toString(),
            })
        .toList();      page++;
    }

    isLoading = false;
    notifyListeners();
  }

}
