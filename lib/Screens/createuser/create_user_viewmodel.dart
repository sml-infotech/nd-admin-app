import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class CreateUserViewmodel extends ChangeNotifier {
  bool isLoading = false;
  String message = '';
  bool isCreateUserSuccess = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController role = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<Temple> _templeData = [];
  List<Temple> get templeData => _templeData;
  List<Map<String, dynamic>> templeList = []; // ✅ store id + name both
  String? selectedTempleName;
  String? selectedTempleId;
  List<String> selectedTempleIds = [];
  int page = 1;
  final int limit = 10;
  final UserService userService = UserService();
  final TempleService templeService = TempleService();
  bool _isDisposed = false;

  Future<void> validateUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty) {
      message = "Please enter Name";
    } else if (!isValidEmail(email)) {
      message = "Please enter valid email";
    } else if (password.isEmpty) {
      message = "Please enter password";
    } else if (password.length < 8) {
      message = "Password must be at least 8 characters";
    } else if (phoneController.text.isEmpty) {
      message = "Please enter Phone Number";
    } else if (phoneController.text.length != 10) {
      message = "Please enter valid Phone Number";
    } else if (role.text.isEmpty) {
      message = "Role is Mandaratory";
    } else if ((role.text == "Temple" || role.text == "Agent") &&
        (selectedTempleIds.isEmpty)) {
      message = "Select Temple";
    } else {
      message = "";
      await createUser();
      return;
    }

    notifyListeners();
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-+.]+@([\w-]+\.)+[\w-]{2,4}$'); 
    return regex.hasMatch(email);
  }

  Future<void> createUser() async {
    try {
      isLoading = true;
      notifyListeners();

      print("${nameController.text}");
      print("${emailController.text}");
      print("${passwordController.text}");
      print("${role.text}");
      print("${selectedTempleId}");
      print("${phoneController.text}");

      final response = await userService.createUser(
        nameController.text,
        emailController.text,
        passwordController.text,
        role.text,
        selectedTempleIds,
        phoneController.text,
      );

      if (response.code == 201) {
        message = response.message!;
        isCreateUserSuccess = true;
      } else if (response.code == 409) {
        message = response.error ?? "";
      } else {
        message = "Some error occurred";
      }
      isLoading = false;
    } catch (e) {
      message = "Something went wrong";
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTemples({bool reset = false}) async {
    if (_isDisposed) return;
    if (isLoading) return;

    if (reset) {
      _templeData.clear();
      templeList.clear();
      page = 1;
      isLoading = true;
    }

    notifyListeners();

    try {
      final response = await templeService.getTemples(page: page, limit: limit);

      if (_isDisposed) return; // 🔥 IMPORTANT

      if (response.data != null && response.data!.isNotEmpty) {
        _templeData.addAll(response.data!);

        templeList = _templeData.map((t) {
          return {
            'id': t.id,
            'name': t.name.toString().replaceAll(RegExp(r'[{}]'), '').trim(),
          };
        }).toList();

        page++;
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  // Get temple ID by name
  String? getTempleIdByName(String name) {
    final temple = _templeData.firstWhere(
      (t) => t.name == name,
      orElse: () => Temple(
        id: '',
        name: '',
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
      ),
    );
    return temple.id.isNotEmpty ? temple.id : null;
  }

  void selectTemple(String? name) {
    selectedTempleName = name;
    selectedTempleId = getTempleIdByName(name ?? "");
    print("Selected Temple: Name=$selectedTempleName, ID=$selectedTempleId");
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    role.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
