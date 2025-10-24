import 'dart:ffi';

class OtpArguments {
  final String email;
 final String password;
 final bool isFromCreateUser;
  OtpArguments({required this.email,required this.password,required this.isFromCreateUser});
}