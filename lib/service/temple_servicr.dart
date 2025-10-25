import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_requestmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
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
  }
