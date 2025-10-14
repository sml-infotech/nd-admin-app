

import 'dart:async';

import 'package:flutter/material.dart';

class OtpViewmodel extends ChangeNotifier{

  String otp = "";
   int ?remainingSeconds;
  Timer? timer;

}