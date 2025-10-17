import 'package:nammadaiva_dashboard/model/login_model/createmodel/create_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/createmodel/create_usermodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/login_request.dart';
import 'package:nammadaiva_dashboard/model/login_model/login_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/otpmodel/otp_request.dart';
import 'package:nammadaiva_dashboard/model/login_model/otpmodel/otp_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/user_listModel.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
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

  Future<OtpResponse> verifyOtp(String emailId, String otp) async {
    try {
      final otpRequest = OtpRequest(email: emailId, otp: otp);
      final data = await apiService.post(
        UrlConstant.otpUrl,
        otpRequest.toJson(),
      );
      return OtpResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }


    Future<UserResponse> createUser(String name ,String email,String password,String role) async {
    try {
      final otpRequest = CreateUsermodel(full_name:name , email:email, password:password , role: role);
      
      final data = await apiService.post(
        UrlConstant.createUser,
        otpRequest.toJson(),
      );
      print("1111111111$data");
      return UserResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

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



 Future<UserListResponse> getUserDetails() async {
  try {
    final url = '${UrlConstant.userListUrl}';
    print('Fetching temples: $url');
    dynamic data = await apiService.get(url);
    return UserListResponse.fromJson(data);
  } catch (e) {
    print("Temple service decode fails: $e");
    throw Exception('API failed: $e');
  }
}
}
