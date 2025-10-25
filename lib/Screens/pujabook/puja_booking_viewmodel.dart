

import 'package:flutter/material.dart';

class PujaBookingViewmodel extends ChangeNotifier{

  TextEditingController pujaName=TextEditingController();
  TextEditingController description=TextEditingController();
  TextEditingController duration=TextEditingController();
  TextEditingController fee=TextEditingController();
    TextEditingController maxDevotees=TextEditingController();

String? selectedSlot;
  DateTime? selectedDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  bool bookingCutoff = false;
  bool priestDakshina = false;
  bool specialReq = false;
  bool hideActive = false;

}