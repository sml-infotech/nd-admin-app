import 'package:nammadaiva_dashboard/arguments/update_mantra.dart'
    hide UpdateMantra;
import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_list_modal.dart';
import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_response_model.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

import '../model/login_model/mantra_model/update_mantra.dart';

class MantraService {
  final HttpApiService apiService = HttpApiService();

  Future<CreateMantraResponse> createMantra(
    String mantraName,
    String mantra,
    String mantraImage,
  ) async {
    try {
      final loginRequest = MantraModel(
        mantraName: mantraName,
        mantra: mantra,
        deityImageUrl: mantraImage,
      );

      final data = await apiService.post(
        UrlConstant.create_mantra,
        loginRequest.toJson(),
      );

      return CreateMantraResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<MantraListModal> fetchMantra({int page = 1, int limit = 10}) async {
    try {
      final url = '${UrlConstant.list_mantras}?page=$page&limit=$limit';
      print('Fetching fetchMantra: $url');
      dynamic data = await apiService.get(url);
      return MantraListModal.fromJson(data);
    } catch (e) {
      print("fetchMantra service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<MantraUpdateResponse> mantraUpdate(
   String mantraId,String mantraName,String mantra,String image
  ) async {
    try {
      final updateMantra = UpdateMantra(
        mantraId: mantraId,
        mantraName: mantraName,
        mantra:mantra,
        deityImageUrl: image,
      );

      final data = await apiService.put(
        UrlConstant.update_mantra,
        updateMantra.toJson(),
      );

      print("✅ toggle PUJA activate: $data");

      return MantraUpdateResponse.fromJson(data);
    } catch (e) {
      print("❌ toggle: API request failed -> $e");
      throw Exception('API failed: $e');
    }
  }
}
