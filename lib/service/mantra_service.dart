import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_list_modal.dart';
import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_response_model.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

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
Future<MantraListModal> fetchMantra({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url =
          '${UrlConstant.list_mantras}?page=$page&limit=$limit';
      print('Fetching fetchMantra: $url');
      dynamic data = await apiService.get(url);
      return MantraListModal.fromJson(data);
    } catch (e) {
      print("fetchMantra service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

}
