import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';
import 'package:nammadaiva_dashboard/arguments/temple_details_arguments.dart';
import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_requestmodel.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTempleViewmodel extends ChangeNotifier {
  TextEditingController templeName = TextEditingController();
  TextEditingController templeLocation = TextEditingController();
  TextEditingController templeDescription = TextEditingController();
  TextEditingController templePhoneNumber = TextEditingController();
  TextEditingController templeEmail = TextEditingController();
  TextEditingController templeDeities = TextEditingController();
  TextEditingController templeArchitecture = TextEditingController();
  TextEditingController templeCity = TextEditingController();
  TextEditingController templeState = TextEditingController();
  TextEditingController templePincode = TextEditingController();
  TextEditingController templeNameInKannadam = TextEditingController();
  TextEditingController templeLocationInKannadam = TextEditingController();
  TextEditingController templeDescriptionInKannadam = TextEditingController();
  TextEditingController templeDeitiesInKannadam = TextEditingController();
TextEditingController templeArchitectureInKannadam = TextEditingController();
  TextEditingController templeCityInKannadam = TextEditingController();
  TextEditingController templeStateInKannadam = TextEditingController();

  final TextEditingController templeController =
      TextEditingController(); // ✅ add this

  TempleService templeService = TempleService();
  UserService userService = UserService();

  bool isLoading = false;
  bool templeUpdated = false;
  String message = "";
  List<String> images = [];
  TempleDetailsArguments? originalTempleData;
  final listEquals = const ListEquality().equals;
  
  List<String> temples = [];
  List<String> templesInKannadam = [];
  List<String> _prefilledTemples = [];

  List<String> get prefilledTemples => _prefilledTemples;

  set prefilledTemples(List<String> deities) {
    _prefilledTemples = deities;
    // Keep text controller in sync for validation
    templeDeities.text = deities.join(', ');
    notifyListeners();
  }

  void addTemple(String temple) {
    final trimmed = temple.trim();
    if (trimmed.isNotEmpty && !_prefilledTemples.contains(trimmed)) {
      _prefilledTemples.add(trimmed);
      print("Updated Deities List: $_prefilledTemples");
      templeDeities.text = _prefilledTemples.join(', '); 
      notifyListeners();
    }
  }

  void addTempleInKannadam(String name) {
    final trimmed = name.trim();
    if (trimmed.isNotEmpty && !_prefilledTemplesInKannadam.contains(trimmed)) {
      _prefilledTemplesInKannadam.add(trimmed);
      // Keep the text controller in sync
      templeDeitiesInKannadam.text = _prefilledTemplesInKannadam.join(', ');
      notifyListeners();
    }
  }

  void removeTemple(int index) {
    if (index >= 0 && index < _prefilledTemples.length) {
      _prefilledTemples.removeAt(index);
      templeDeities.text = _prefilledTemples.join(', ');
      notifyListeners();
    }
  }

  void removeTempleInKannadam(int index) {
    if (index >= 0 && index < _prefilledTemplesInKannadam.length) {
      _prefilledTemplesInKannadam.removeAt(index);
      templeDeitiesInKannadam.text = _prefilledTemplesInKannadam.join(', ');
      notifyListeners();
    }
  }

  // Other properties related to Kannada (prefilledTemplesInKannadam)
  List<String> _prefilledTemplesInKannadam = [];
  List<String> get prefilledTemplesInKannadam => _prefilledTemplesInKannadam;
  List<String> finalKannadaDeities = [];

  set prefilledTemplesInKannadam(List<String> deities) {
    _prefilledTemplesInKannadam = deities;
    finalKannadaDeities = deities;
    // Keep text controller in sync for validation
    templeDeitiesInKannadam.text = deities.join(', ');
    notifyListeners(); 
  }

  bool validateUpdateTemple() {
    final name = templeName.text.trim();
    final location = templeLocation.text.trim();
    final description = templeDescription.text.trim();
    final phone = templePhoneNumber.text.trim();
    final email = templeEmail.text.trim();
    final architecture = templeArchitecture.text.trim();
    final city = templeCity.text.trim();
    final state = templeState.text.trim();
    final pincode = templePincode.text.trim();

    if (name.isEmpty) {
      message = "Temple name cannot be empty";
      return false;
    }
    if (location.isEmpty) {
      message = "Address cannot be empty";
      return false;
    }
    if (city.isEmpty) {
      message = "City cannot be empty";
      return false;
    }
    if (state.isEmpty) {
      message = "State cannot be empty";
      return false;
    }
    if (pincode.isEmpty) {
      message = "Pincode cannot be empty";
      return false;
    } else if (pincode.length != 6 || int.tryParse(pincode) == null) {
      message = "Pincode must be a valid 6-digit number";
      return false;
    }
    if (architecture.isEmpty) {
      message = "Architecture cannot be empty";
      return false;
    }
    if (email.isEmpty) {
      message = "Email cannot be empty";
      return false;
    } else if (!isValidEmail(email)) {
      message = "Invalid email address";
      return false;
    }
    if (phone.isEmpty) {
      message = "Phone number cannot be empty";
      return false;
    } else if (phone.length != 10 || int.tryParse(phone) == null) {
      message = "Phone number must be 10 digits";
      return false;
    }
    // Validate list instead of text field for better accuracy
    if (_prefilledTemples.isEmpty) {
      message = "Please add at least one deity";
      return false;
    }
    if (description.isEmpty) {
      message = "Description cannot be empty";
      return false;
    }

    message = "";
    return true;
  }

  List<XFile> selectedImages = [];
  List<String> uploadedImageUrls = [];

  Future<void> addImages(List<String> newImages) async {
    try {
      isLoading = true;
      notifyListeners();

      final newXFiles = newImages.map((path) => XFile(path)).toList();

      final existingPaths = selectedImages.map((e) => e.path).toSet();
      final uniqueNewXFiles = newXFiles
          .where((file) => !existingPaths.contains(file.path))
          .toList();

      if (uniqueNewXFiles.isEmpty) {
        debugPrint("⚠️ No new unique images to upload");
        message = "Duplicate images skipped.";
        isLoading = false;
        notifyListeners();
        return;
      }

      selectedImages.addAll(uniqueNewXFiles);
      debugPrint(
        "🖼 Selected Images (unique): ${selectedImages.map((e) => e.path).toList()}",
      );

      for (final file in uniqueNewXFiles) {
        debugPrint("📤 Getting presigned URL for ${file.name}");
    final response = await userService.presignedUrl(file.name, file.path);

        if (response.url != null && response.url!.isNotEmpty) {
          final presignedUrl = response.url!;
          final uploadedUrl = await uploadToS3(presignedUrl, file);

          if (uploadedUrl != null) {
            if (!uploadedImageUrls.contains(uploadedUrl)) {
              uploadedImageUrls.add(uploadedUrl);
            }
            if (!images.contains(uploadedUrl)) {
              images.add(uploadedUrl);
            }

            debugPrint("✅ Uploaded: $uploadedUrl");
            notifyListeners();
          } else {
            message = "Upload failed for ${file.name}";
          }
        } else {
          message =
              response.message ??
              "Failed to get presigned URL for ${file.name}";
        }
      }
    } catch (e, st) {
      debugPrint("❌ Error while uploading images: $e");
      debugPrint(st.toString());
      message = "Unexpected error occurred: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> updateTemple(String templeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('userRole');

    try {
      isLoading = true;
      notifyListeners();

      final Map<String, dynamic> changes = {};
      final listEquals = const ListEquality().equals;

      bool isChanged(dynamic oldVal, dynamic newVal) {
        return newVal != null &&
            newVal.toString().trim() != oldVal?.toString().trim();
      }

      // ---------------- ENGLISH FIELD CHANGES ----------------
      if (isChanged(originalTempleData?.name, templeName.text)) {
        changes["name"] = templeName.text.trim();
      }

      if (isChanged(originalTempleData?.address, templeLocation.text)) {
        changes["address"] = templeLocation.text.trim();
      }

      if (isChanged(originalTempleData?.description, templeDescription.text)) {
        changes["description"] = templeDescription.text.trim();
      }

      // DETECT CHANGES IN ENGLISH DEITIES (Using List Comparison)
      bool englishDeitiesChanged = !listEquals(originalTempleData?.deities, _prefilledTemples);
      if (englishDeitiesChanged) {
        changes["deities"] = _prefilledTemples;
      }

      // ---------------- KANNADA TRANSLATION ----------------
      final originalKnTranslation = originalTempleData?.translations.firstWhere(
        (t) => t.languageCode == 'kn',
        orElse: () => Translation(
          languageCode: 'kn',
          name: '',
          address: '',
          city: '',
          state: '',
          description: '',
          deities: [],
        ),
      );

      Map<String, dynamic> knChanges = {};

      if (isChanged(originalKnTranslation?.name, templeNameInKannadam.text)) {
        knChanges["name"] = templeNameInKannadam.text.trim();
      }
      if (isChanged(originalKnTranslation?.address, templeLocationInKannadam.text)) {
        knChanges["address"] = templeLocationInKannadam.text.trim();
      }
      if (isChanged(originalKnTranslation?.description, templeDescriptionInKannadam.text)) {
        knChanges["description"] = templeDescriptionInKannadam.text.trim();
      }

      // DETECT CHANGES IN KANNADA DEITIES (Using List Comparison)
      bool kannadaDeitiesChanged = !listEquals(originalKnTranslation?.deities, _prefilledTemplesInKannadam);
      if (kannadaDeitiesChanged) {
        knChanges["deities"] = _prefilledTemplesInKannadam;
      }

      // IMAGES CHANGE DETECTION
      bool imagesChanged = !listEquals(originalTempleData?.images, images);

      // // FINAL CHANGE CHECK
      // if (changes.isEmpty && knChanges.isEmpty && !imagesChanged && !englishDeitiesChanged && !kannadaDeitiesChanged) {
      //   message = "No changes detected.";
      //   isLoading = false;
      //   notifyListeners();
      //   return;
      // }

      if (userRole == "Super Admin" || userRole == "Admin") {
        final updateTempleDataByAdmin = AddTemple(
          templeId: templeId,
          name: templeName.text.trim(),
          address: templeLocation.text.trim(),
          city: templeCity.text.trim(),
          state: templeState.text.trim(),
          pincode: templePincode.text.trim(),
          architecture: templeArchitecture.text.trim(),
          phoneNumber: templePhoneNumber.text.trim(),
          email: templeEmail.text.trim(),
          description: templeDescription.text.trim(),
          deities: _prefilledTemples, // Use the latest list
          images: images,
          translations: [
            Translation(
              languageCode: "kn",
              name: templeNameInKannadam.text.trim(),
              address: templeLocationInKannadam.text.trim(),
              city: templeCityInKannadam.text.trim(),
              state: templeStateInKannadam.text.trim(),
              description: templeDescriptionInKannadam.text.trim(),
              deities: _prefilledTemplesInKannadam, // Use the latest list
            ),
          ],
        );

        final response = await templeService.updateTemplebyAdmin(
          updateTempleDataByAdmin,
        );
        templeUpdated = response.message == "Temple updated successfully";
        message = response.message ?? "Temple update failed";
      } else {
        // For non-admins, ensure the "deities" is included in changes if list changed
        if (englishDeitiesChanged) {
          changes["deities"] = _prefilledTemples;
        }
        final payload = {"temple_id": templeId, "changes": changes};
        final response = await templeService.updateTemple(payload);
        templeUpdated = response.code == 201;
        message = response.message ?? "Temple update failed";
      }
    } catch (e, st) {
      debugPrint("❌ Update failed: $e");
      debugPrint(st.toString());
      message = "Update failed";
      templeUpdated = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
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

  void reset() {
    templeName.clear();
    templeLocation.clear();
    templeDescription.clear();
    templePhoneNumber.clear();
    templeEmail.clear();
    templeDeities.clear();
    templeArchitecture.clear();
    templeCity.clear();
    templeState.clear();
    templePincode.clear();
    templeNameInKannadam.clear();
    templeLocationInKannadam.clear();
    templeDescriptionInKannadam.clear();
    templeDeitiesInKannadam.clear();
    templeArchitectureInKannadam.clear();
    templeCityInKannadam.clear();
    templeStateInKannadam.clear();
    
    _prefilledTemples.clear();
    _prefilledTemplesInKannadam.clear();
    selectedImages.clear();
    uploadedImageUrls.clear();
    images.clear();

    isLoading = false;
    templeUpdated = false;
    message = "";
    originalTempleData = null;

    notifyListeners();
  }
}