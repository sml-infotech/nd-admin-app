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

  List<EditUserResponse> editData = [];
  List<EditUserResponse> get editdata => editData;

  bool isLoading = true;
  bool editLoading = false;

  /// Pagination fields
  bool hasMore = true;
  int page = 1;
  final int _pageSize = 10;

  /// Map to temporarily hold active state for each user while editing
  final Map<String, bool> _tempActiveMap = {};
  bool getTempActive(String userId) => _tempActiveMap[userId] ?? false;
  void setTempActive(String userId, bool value) {
    _tempActiveMap[userId] = value;
    notifyListeners();
  }

  /// Fetch initial users or reset list
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
            associatedTempleId: userData[index].associatedTempleId,
            updatedAt: DateTime.now(),
          );
        }
      }
    } catch (e) {
      print("Error editing user: $e");
    }

    editLoading = false;
    notifyListeners();
  }
}
