import 'dart:async';
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
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;
  List<UserModel> userData = [];
  List<UserModel> get users => userData;
  List<Map<String, String>> templeList = [];

  List<EditUserResponse> editData = [];
  List<EditUserResponse> get editdata => editData;
  bool isLoadingMore = false;

  bool isLoading = true;
  bool editLoading = false;

  List<String> selectedTempleIds = [];
  bool hasMore = true;
  int page = 1;
  final int _pageSize = 10;
  String message = "";
  List<Temple> _templeData = [];

  final Map<String, bool> _tempActiveMap = {};
  bool getTempActive(String userId) => _tempActiveMap[userId] ?? false;
  void setTempActive(String userId, bool value) {
    _tempActiveMap[userId] = value;
    notifyListeners();
  }

  void toggleTempleSelection(String id) {
    if (selectedTempleIds.contains(id)) {
      selectedTempleIds.remove(id);
    } else {
      selectedTempleIds.add(id);
    }
    notifyListeners();
  }

  Future<void> getUsers({bool reset = false}) async {
    if (reset) {
      page = 1;
      hasMore = true;
      userData.clear();

      isLoading = true;
      notifyListeners();
    }

    if (!hasMore || isLoadingMore) return;

    if (page != 1) {
      isLoadingMore = true;
      notifyListeners();
    }

    try {
      final response = await authService.getUserDetails(
        page: page,
        pageSize: _pageSize,
        search: searchController.text,
      );

      final users = response.users ?? [];

      if (users.isNotEmpty) {
        userData.addAll(users);
        hasMore = users.length == _pageSize;
        if (hasMore) page++;
      } else {
        hasMore = false;
      }
    } catch (e) {
      hasMore = false;
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> fetchMoreUsers() async {
    if (hasMore && !isLoadingMore && !isLoading) {
      await getUsers();
    }
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      getUsers(reset: true); // << FIXED
    });
  }

  Future<void> editUser(
    String userId,
    String name,
    bool isActive, {
    List<String>? selectedTemples,
  }) async {
    editLoading = true;
    notifyListeners();
    try {
      final filteredTemples = (selectedTemples ?? [])
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();
      print("selectedTemplesselectedTemples${selectedTemples}");
      print("selectedTemplesselectedTemples${filteredTemples}");

      final response = await authService.editUser(
        userId,
        name,
        role.text,
        isActive,
        selectedTemples: filteredTemples,
      );
      if (response.message.isNotEmpty) {
        editData.add(response);

        final index = userData.indexWhere((user) => user.id == userId);
        if (index != -1) {
          userData[index] = UserModel(
            id: userId,
            fullName: name,
            email: userData[index].email,
            role: role.text.isNotEmpty ? role.text : userData[index].role,
            isActive: isActive,
            createdAt: userData[index].createdAt,
            updatedAt: DateTime.now().toIso8601String(),
            phoneNumber: userData[index].phoneNumber,

            associatedTemples: filteredTemples
                .map(
                  (id) => TempleModel(
                    id: id,
                    name: _getTempleNameById(id),
                    address: '',
                    city: '',
                    state: '',
                    pincode: '',
                    architecture: '',
                    phoneNumber: '',
                    email: '',
                    description: '',
                    createdAt: '',
                    updatedAt: '',
                    deities: [],
                    images: [],
                  ),
                )
                .toList(),
          );
        }
      }
    } catch (e, st) {
      print("❌ Error editing user: $e");
      print("🔍 Stack trace: $st");
    }

    editLoading = false;
    notifyListeners();
  }

  String _getTempleNameById(String id) {
    if (templeList.isEmpty) return '';

    final Map<String, String> temple = templeList.firstWhere(
      (t) => t['id'] == id,
      orElse: () => <String, String>{'id': '', 'name': ''},
    );

    return temple['name'] ?? '';
  }

  Future<void> getTemples({bool reset = false}) async {
    isLoading = true;
    notifyListeners();

    final response = await templeService.getTemples(page: 1, limit: 50);

    if (response.data != null && response.data!.isNotEmpty) {
      _templeData.addAll(response.data!);
      templeList = _templeData
          .map((t) => {"id": t.id.toString(), "name": t.name.toString()})
          .toList();
      page++;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateValidate(String fullName) async {
    if (fullName.isEmpty) {
      message = "Please fill FullName";
      return false;
    } else if (role.text.isEmpty) {
      message = "Role is Mandaratory";
      return false;
    } else if ((role.text == "Temple" || role.text == "Agent") &&
        (selectedTempleIds.isEmpty)) {
      message = "Select Temple";
      return false;
    } else {
      return true;
    }
  }

  void resetData() {
    userData.clear();
    editData.clear();
    templeList.clear();
    _templeData.clear();
    selectedTempleIds.clear();
    _tempActiveMap.clear();
    searchController.clear;

    page = 1;
    hasMore = true;
    isLoading = false;
    editLoading = false;
    role.clear();

    notifyListeners();
  }
}
