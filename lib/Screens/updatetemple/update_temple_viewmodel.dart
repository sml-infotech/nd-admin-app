import 'package:flutter/cupertino.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';

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
  TempleService templeService=TempleService();
bool isLoading=false;
bool templeUpdated=false;
String message = "";

  bool validateUpdateTemple() {
    final name = templeName.text.trim();
    final location = templeLocation.text.trim();
    final description = templeDescription.text.trim();
    final phone = templePhoneNumber.text.trim();
    final email = templeEmail.text.trim();
    final deities = templeDeities.text.trim();
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

    if (deities.isEmpty) {
      message = "Please add at least one deity";
      return false;
    }

    if (description.isEmpty) {
      message = "Description cannot be empty";
      return false;
    }

    // ✅ Everything valid
    message = "";
    return true;
  }

Future<void> updateTemple(String templeId) async {

    try {
        isLoading=true;
        notifyListeners();
      final response = await templeService.updateTemple(
          templeId,
          templeName.text.trim(),
          templeLocation.text.trim(),
          templeDescription.text.trim(),
          templePhoneNumber.text.trim(),
          templeEmail.text.trim(),
          templeDeities.text.trim(),
          templeArchitecture.text.trim(),
          templeCity.text.trim(),
          templeState.text.trim(),
          [templePincode.text.trim()],[]
       
      );
      if (response.code==201) {
        print("->>> $response");
        message = response.message ?? "success";
        isLoading=false;
        templeUpdated=true;
        notifyListeners();
      } 
      else if(response.code==409){
        isLoading=false;
        message = response.message ?? "user not Found";
        print(">>>>>>>>?????${message}");
        notifyListeners();
      }
      else {
        isLoading=false;
        notifyListeners();
        message =  "some error occurred";
        print("message $message");
      }
    } catch (e) {
      isLoading=false;
      notifyListeners();
   
    }
}






  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }
}
