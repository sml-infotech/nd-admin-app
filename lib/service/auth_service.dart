import 'package:nammadaiva_dashboard/model/login_model/login_request.dart';
import 'package:nammadaiva_dashboard/model/login_model/login_response.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class AuthService {
  final HttpApiService apiService = HttpApiService();

  Future<LoginResponse> loginUser(String emailId, String password) async {
    try {
      final loginRequest = LoginModel(email: emailId, password: password);

      final data = await apiService.post(
        UrlConstant.loginUrl,
        loginRequest.toJson(),
      );

      return LoginResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }
}
