import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/puja_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

class CreatePujaViewmodel extends ChangeNotifier {
  final TextEditingController pujaName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController duration = TextEditingController();
  final TextEditingController fee = TextEditingController();
  final TextEditingController maxDevotees = TextEditingController();
  final TextEditingController deitiesController = TextEditingController();

  final PujaService pujaService = PujaService();

  List<XFile> selectedImages = [];
  List<String> deities = [];
  Temple? selectedTemple;
  List<String> deitiesList = [];

  bool bookingCutoff = false;
  bool priestDakshina = false;
  bool specialReq = false;
  bool hideActive = false;
  bool isLoading = false;
  bool isValid = false;
  int page = 1;
  final int limit = 10;
  final TempleService templeService = TempleService();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
List<Temple> templeData = [];
  List<String> templeList = [];  
  String message = "";
  String selectedDeities="";
  String selectedDeityId="";

  Map<String, bool> selectedDays = {
    "Mon": false,
    "Tue": false,
    "Wed": false,
    "Thu": false,
    "Fri": false,
    "Sat": false,
    "Sun": false,
  };

  CreatePujaViewmodel() {
    pujaName.addListener(_onChange);
    description.addListener(_onChange);
    duration.addListener(_onChange);
    fee.addListener(_onChange);
    maxDevotees.addListener(_onChange);
    deitiesController.addListener(_onChange);
  }

  void _onChange() => validateForm(auto: true);

  bool validateForm({bool auto = false}) {
   if(templeData.isEmpty){
      message = "Please select Temple";
   }
   else if(deities.isEmpty){
      message = "Please select Deities";
   }
   else  if (pujaName.text.trim().isEmpty) {
      message = "Please enter Puja name";
    } else if (description.text.trim().isEmpty) {
      message = "Please enter description";
    } else if (!selectedDays.containsValue(true)) {
      message = "Select at least one day";
    } else if (duration.text.trim().isEmpty) {
      message = "Please enter puja duration";
    } else if (fee.text.trim().isEmpty || double.tryParse(fee.text) == null) {
      message = "Enter a valid fee";
    } else if (maxDevotees.text.trim().isEmpty ||
        int.tryParse(maxDevotees.text) == null) {
      message = "Enter valid maximum devotees";
    } else if (selectedStartDate == null) {
      message = "Please select a start date";
    } else if (selectedEndDate == null) {
      message = "Please select an end date";
    } else if (fromTime == null || toTime == null) {
      message = "Please select both From and To time";
    } else if (selectedImages.isEmpty) {
      message = "Please upload at least one image";
    } else {
      createPuja();
      isValid = true;
      if (!auto) notifyListeners();
      return true;
    }

    isValid = false;
    if (!auto) notifyListeners();
    return false;
  }

  void toggleDay(String day) {
    selectedDays[day] = !(selectedDays[day] ?? false);
    notifyListeners();
  }

  void addDeity(String name) {
    deities.add(name);
    notifyListeners();
  }

  void removeDeity(int index) {
    deities.removeAt(index);
    notifyListeners();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }


  Future<void> getTemples({bool reset = false}) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    if (reset) {
      templeData.clear();
      templeList.clear();
      page = 1;
    }

    final response = await templeService.getTemples(page: page, limit: limit);

    if (response.data != null && response.data!.isNotEmpty) {
      templeData.addAll(response.data!);
      templeList = templeData.map((t) => t.name).toList();
      page++;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> createPuja() async {
    try {
      isLoading = true;
      notifyListeners();

      final timeSlot = TimeSlot(
        fromTime: formatTimeOfDay(fromTime!),
        toTime: formatTimeOfDay(toTime!),
      );

      final requestDays =
          selectedDays.entries.where((e) => e.value).map((e) => e.key).toList();

      // Debug print
      print("""
--- Creating Puja ---
Temple ID: $selectedDeityId
Puja Name: ${pujaName.text}
Description: ${description.text}
Deities: $deities
Fee: ${fee.text}
Max Devotees: ${maxDevotees.text}
Special Req: $specialReq
Days: $requestDays
From: ${selectedStartDate.toString()} To: ${selectedEndDate.toString()}
Images: ${selectedImages.map((e) => e.path).toList()}
---------------------
""");

      final response = await pujaService.cretaPuja(
        selectedDeityId,
        pujaName.text,
        deities,
        description.text,
        int.parse(maxDevotees.text),
        int.parse(fee.text),
        selectedImages.map((x) => x.path).toList(),
        2,
        specialReq,
        selectedStartDate.toString(),
        selectedEndDate.toString(),
        requestDays,
        [timeSlot],
      );

      if (response.code == 201) {
        message = response.message ?? "Success";
        print("✅ Puja created successfully: ${response.toJson()}");
      } else {
        message = "❌ Error: ${response.message ?? "Unknown error"}";
        print("Error response: ${response.toJson()}");
      }
    } catch (e) {
      print("⚠️ Puja creation failed: $e");
      message = "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pujaName.dispose();
    description.dispose();
    duration.dispose();
    fee.dispose();
    maxDevotees.dispose();
    deitiesController.dispose();
    super.dispose();
  }
void setSelectedTemple(Temple temple) {
  selectedTemple = temple;
  
  // Suppose each temple has deities list
  if (temple.deities != null && temple.deities!.isNotEmpty) {
    deitiesList = List<String>.from(temple.deities!);
  } else {
    deitiesList = [];
  }

  notifyListeners();
}
  
}
