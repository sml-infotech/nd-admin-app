import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujaresponsemodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/puja_service.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class CreatePujaViewmodel extends ChangeNotifier {
  final TextEditingController pujaName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController duration = TextEditingController();
  final TextEditingController fee = TextEditingController();
  final TextEditingController benefitController = TextEditingController();

  final TextEditingController maxDevotees = TextEditingController();
  final TextEditingController deitiesController = TextEditingController();
  final TextEditingController pujaNameInKannadam = TextEditingController();
  final TextEditingController descriptionInKannadam = TextEditingController();

  final PujaService pujaService = PujaService();
  final TempleService templeService = TempleService();
  final UserService userService = UserService();

  List<XFile> selectedImages = [];
  List<String> deities = [];
  List<String> deitiesList = [];
  List<Temple> templeData = [];
  List<String> templeList = [];
  List<String> uploadedImageUrls = [];
  List<String> deitiesListEn = [];
  List<String> deitiesListKn = [];
  List<String> selectedDeities = [];
  Temple? selectedTemple;
  List<String> deitiesOptionsEn = [];
  List<String> deitiesOptionsKn = [];
  List<String> selectedDeitiesEn = [];
  List<String> selectedDeitiesKn = [];
  String message = "";
  // String selectedDeities = "";
  String selectedDeityId = "";
  String? presignedURL;
  String? selectedTempleId;

  String? pujaId;

  bool bookingCutoff = false;
  bool priestDakshina = false;
  bool specialReq = false;
  bool hideActive = false;
  bool isLoading = false;
  bool isValid = false;
  bool pujaCreated = false;
  String selectedCutoffOption = '1';

  int page = 1;
  final int limit = 10;

  List<Benefit> benefits = [];
  List<String> benefitsEn = [];

  // KN
  final TextEditingController benefitControllerKn = TextEditingController();
  List<String> benefitsKn = [];

  void addBenefit(String text, {required bool isKannada}) {
    if (isKannada) {
      benefitsKn.add(text);
    } else {
      benefitsEn.add(text);
    }
    notifyListeners();
  }

  void removeBenefit(int index, {required bool isKannada}) {
    if (isKannada) {
      benefitsKn.removeAt(index);
    } else {
      benefitsEn.removeAt(index);
    }
    notifyListeners();
  }

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  Map<String, bool> selectedDays = {
    "Mon": true,
    "Tue": true,
    "Wed": true,
    "Thu": true,
    "Fri": true,
    "Sat": true,
    "Sun": true,
  };

  List<String> cutOffDays = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '20',
  ];
  int? cutOffDay;

  List<TimeSlot> timeSlots = [];

  Future<bool> validateForm(bool isFromUpdate) async {
    if (selectedTemple == null) {
      message = "Please select Temple";
    }
    //  else if (deities.isEmpty) {
    //   message = "Please select Deities";
    // }
    else if (pujaName.text.trim().isEmpty) {
      message = "Please enter Puja name";
    } else if (description.text.trim().isEmpty) {
      message = "Please enter description";
    } else if (!selectedDays.containsValue(true)) {
      message = "Select at least one day";
    } else if (fee.text.trim().isEmpty || double.tryParse(fee.text) == null) {
      message = "Enter a valid fee";
    } else if (maxDevotees.text.trim().isEmpty ||
        int.tryParse(maxDevotees.text) == null) {
      message = "Enter valid maximum devotees";
    } else if (selectedStartDate == null) {
      message = "Please select a start date";
    } else if (selectedEndDate == null) {
      message = "Please select an end date";
    } else if (timeSlots.isEmpty) {
      message = "Please add at least one time slot";
    } else {
      if (isFromUpdate) {
        await updatepuja();
        return true;
      } else {
        await createPuja();
        return true;
      }
    }

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

  Future<void> addImages(List<String> newImages) async {
    try {
      isLoading = true;
      notifyListeners();

      // Prevent duplicates before adding
      for (final path in newImages) {
        final alreadyExists = selectedImages.any((img) => img.path == path);
        if (!alreadyExists) {
          selectedImages.add(XFile(path));
        }
      }

      print(
        "🖼 Final Selected Images: ${selectedImages.map((e) => e.path).toList()}",
      );

      // 🪣 Upload safely
      for (final file in List<XFile>.from(selectedImages)) {
        print("📤 Getting presigned URL for ${file.name}");
        final response = await userService.presignedUrl(file.name, file.path);

        if (response.url != null && response.url!.isNotEmpty) {
          final presignedUrlForFile = response.url!;
          print("✅ Got presigned URL for ${file.name}");

          final uploadedUrl = await uploadToS3(presignedUrlForFile, file);
          if (uploadedUrl != null) {
            if (!uploadedImageUrls.contains(uploadedUrl)) {
              uploadedImageUrls.add(uploadedUrl);
            }
            selectedImages.remove(file);

            print("✅ Uploaded ${file.name} -> $uploadedUrl");
          } else {
            print("❌ Upload failed for ${file.name}");
            message = "Upload failed for ${file.name}";
          }
        } else {
          print("⚠️ Failed to get presigned URL for ${file.name}");
          message =
              response.message ??
              "Failed to get presigned URL for ${file.name}";
        }
      }
    } catch (e) {
      print("❌ Error in addImages: $e");
      message = "Something went wrong: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeImage(int index) async {
    await removeS3(uploadedImageUrls[index]);
    selectedImages.removeAt(index);

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

    final response = await templeService.getTemples(
      page: page,
      limit: limit,
      language: "kn",
    );
    if (response.data != null && response.data!.isNotEmpty) {
      templeData.addAll(response.data!);
      templeList = templeData.map((t) => t.name).toList();
      print(">>>>>>>>>>>>${templeData.first.translations}");
      page++;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createPuja() async {
    try {
      isLoading = true;
      notifyListeners();

      if (timeSlots.isEmpty) {
        message = "Please add at least one time slot";
        isLoading = false;
        notifyListeners();
        return;
      }
      final requestDays = selectedDays.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      final benefitsList = benefitsEn.toList();


      final response = await pujaService.cretaPuja(
        selectedTempleId ?? "",
        pujaName.text,
        deitiesList,
        description.text,
        int.parse(maxDevotees.text),
        double.parse(fee.text),
        uploadedImageUrls,
        cutOffDay ?? 1,
        specialReq,
        selectedStartDate.toString(),
        selectedEndDate.toString(),
        requestDays,
        timeSlots,
        benefitsList,
        [
          Translation(
            languageCode: "kn",
            pujaName: pujaNameInKannadam.text,
            description: descriptionInKannadam.text,
            deityNames: selectedDeitiesKn,
            benefits: benefitsKn,
          ),
        ],
      );

      if (response.code == 200) {
        message = response.message ?? "Success";
        print("✅ Puja created successfully: ${response.toJson()}");
        pujaCreated = true;

        notifyListeners();
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
  Future<void> removeS3(String filename) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await userService.removeS3(filename);
      if (response.code == 200) {
        print("->>> $response");
        message = "success";
                isLoading = false;

        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        message = "some error occurred";
        print("message $message");
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updatepuja() async {
    try {
      isLoading = true;
      notifyListeners();

      if (timeSlots.isEmpty) {
        message = "Please add at least one time slot";
        isLoading = false;
        notifyListeners();
        return;
      }

      final requestDays = selectedDays.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      final pujaIdValue = this.pujaId ?? "";
      final templeId = selectedTempleId;

      final response = await pujaService.updatePuja(
        pujaIdValue,
        "",
        pujaName.text,
        selectedDeitiesEn,
        description.text,
        int.parse(maxDevotees.text),
        double.parse(fee.text),
        uploadedImageUrls,
        2,
        specialReq,
        selectedStartDate!.toIso8601String(),
        selectedEndDate!.toIso8601String(),
        requestDays,
        timeSlots,
        benefitsEn.toList(),
        [
          Translation(
            languageCode: "kn",
            pujaName: pujaNameInKannadam.text,
            description: descriptionInKannadam.text,
            deityNames: selectedDeitiesKn,
            benefits: benefitsKn,
          ),
        ],
      );

      if (response.code == 200) {
        message = response.message ?? "Success";
        print("✅ Puja updated successfully: ${response.toJson()}");
        pujaCreated = true;
        await resetForm();
        notifyListeners();
      } else {
        message = "❌ Error: ${response.message ?? "Unknown error"}";
        print("Error response: ${response.toJson()}");
      }
    } catch (e) {
      print("⚠️ Puja update failed: $e");
      message = "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> uploadToS3(String presignedUrl, XFile imageFile) async {
    try {
      final fileBytes = await imageFile.readAsBytes();

      final response = await http.put(
        Uri.parse(presignedUrl),
        body: fileBytes,
        headers: {'Content-Type': 'image/jpeg'},
      );
      if (response.statusCode == 200) {
        final imageUrl = presignedUrl.split('?').first;
        print("✅ Uploaded successfully: $imageUrl");
        return imageUrl;
      } else {
        print("❌ Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error uploading to S3: $e");
      return null;
    }
  }

  Future<void> resetForm() async {
    pujaName.clear();
    description.clear();
    duration.clear();
    fee.clear();
    maxDevotees.clear();
    deitiesController.clear();

    selectedImages.clear();
    deities = [];
    deitiesList = [];
    selectedTemple = null;
    // selectedDeities = "";
    selectedDeityId = "";

    bookingCutoff = false;
    priestDakshina = false;
    specialReq = false;
    hideActive = false;

    selectedStartDate = null;
    selectedEndDate = null;
    fromTime = null;
    toTime = null;
    timeSlots = [];
    notifyListeners();
    deitiesListEn = [];
    selectedDeitiesEn = [];
    selectedDeitiesKn = [];
    deitiesListKn = [];
    deities = [];
    selectedDeities = [];
    benefits = [];
    benefitsEn = [];
    benefitsKn = [];
    message = "";
    isValid = false;
    isLoading = false;
    pujaNameInKannadam.clear();
    descriptionInKannadam.clear();
    cutOffDay = null;
    uploadedImageUrls.clear();
    // selectedDays.clear();
    cutOffDay = 1;
    deitiesOptionsEn = [];
    deitiesOptionsKn = [];
    notifyListeners();
  }

  void setSelectedTemple(Temple temple, {List<String>? initialDeitiesEn}) {
    selectedTemple = temple;
    selectedTempleId = temple.id;

    deitiesOptionsEn = List<String>.from(temple.deities ?? []);

    if (temple.translations != null && temple.translations!.isNotEmpty) {
      deitiesOptionsKn = List<String>.from(
        temple.translations!.first.deities ?? [],
      );
    } else {
      deitiesOptionsKn = [];
    }

    if (initialDeitiesEn != null) {
      selectedDeitiesEn = initialDeitiesEn;
      selectedDeitiesKn = initialDeitiesEn.map((enName) {
        int index = deitiesOptionsEn.indexOf(enName);
        if (index != -1 && index < deitiesOptionsKn.length) {
          return deitiesOptionsKn[index];
        }
        return enName;
      }).toList();
    }

    notifyListeners();
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
}
