
import 'package:flutter/material.dart';

class CreateUserViewmodel  extends ChangeNotifier{
  bool isLoading = false;
  String message = '';
  bool isCreateUserSuccess = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController role = TextEditingController();
 

  
}