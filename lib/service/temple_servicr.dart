import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujaresponsemodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_requestmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_request_templemodel/update_request_temple_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_temple_admin/admin_update_templemodal.dart';
import 'package:nammadaiva_dashboard/model/login_model/updatetemple/update_temple_request_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/updatetemple/update_temple_response.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class TempleService {
  final HttpApiService apiService = HttpApiService();
 Future<TempleResponse> getTemples({int page = 1, int limit = 10}) async {
  try {
    final url = '${UrlConstant.templeUser}?page=$page&limit=$limit';
    print('Fetching temples: $url');
    dynamic data = await apiService.get(url);
    return TempleResponse.fromJson(data);
  } catch (e) {
    print("Temple service decode fails: $e");
    throw Exception('API failed: $e');
  }
}




Future<CreateTempleResponse> addTemple(
  String name,
  String address,
  String city,
  String state,
  String pincode,
  String architecture,
  String phoneNumber,
  String email,
  String description,
  List<String> deities,
  List<String> images,
) async {
  try {
    final request = AddTemple(
      name: name,
      address: address,
      city: city,
      state: state,
      pincode: pincode,
      architecture: architecture,
      phoneNumber: phoneNumber,
      email: email,
      description: description,
      deities: deities,
      images: images,
    );

    // Print the request as JSON
    print(">>>>>>>>>>>>>>> Request JSON >>>>>>>>>>>");
    print(request.toJson());
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");

    final data = await apiService.post(
      UrlConstant.addTempleUrl,
      request.toJson(),
    );

    print("API Response >>>> $data");
    return CreateTempleResponse.fromJson(data);
  } catch (e) {
    print("Auth service decode fails: $e");
    throw Exception('API failed: $e');
  }
}




 Future<PujaListResponse> getPujas(String templeId) async {
  try {
    final url = '${UrlConstant.getPujas}?temple_id=$templeId';
    print('Fetching getPujas: $url');
    dynamic data = await apiService.get(url);
    return PujaListResponse.fromJson(data);
  } catch (e) {
    print("getPujas service decode fails: $e");
    throw Exception('API failed: $e');
  }
}



Future<TempleUpdateResponse> updateTemple(Map<String, dynamic> payload) async {
  try {
    print(">>>>>>>>>>>>>>> Temple Update Request JSON >>>>>>>>>>>");
    print(payload);
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");

    final data = await apiService.post(
      UrlConstant.updateTempleUrl,
      payload,
    );

    print("✅ Temple Update API Response >>>> $data");
    return TempleUpdateResponse.fromJson(data);
  } catch (e) {
    print("❌ Temple Update service failed: $e");
    throw Exception('Temple update API failed: $e');
  }
}

Future<AdminTempleUpdateResponse> updateTemplebyAdmin(AddTemple datas) async {
  try {
  final request=datas;
    final data = await apiService.put(
      UrlConstant.updateTempleAdminUrl,
      request.toJson(),
    );

    print("✅ Temple Update API Response >>>> $data");
    return AdminTempleUpdateResponse.fromJson(data);
  } catch (e) {
    print("❌ Temple Update service failed: $e");
    throw Exception('Temple update API failed: $e');
  }
}



Future<TempleUpdateRequestListModel> fetchUpdateRequests({int page = 1, int limit = 10}) async {
  try {
    final url = '${UrlConstant.updateTempleRequestUrl}?page=$page&limit=$limit';
    print('Fetching updateTemple: $url');
    dynamic data = await apiService.get(url);
    return TempleUpdateRequestListModel.fromJson(data);
  } catch (e) {
    print("updateTemple service decode fails: $e");
    throw Exception('API failed: $e');
  }
}


  }
