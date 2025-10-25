

import 'package:nammadaiva_dashboard/model/login_model/forgotmodel/forgot_requestmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/forgotmodel/forgot_responsemodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/resetmodel/reset_requestmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/resetmodel/reset_responsemodel.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class PasswordService {
  final HttpApiService apiService = HttpApiService();

    Future<ForgotResponsemodel> forgotPassword(String email) async {
    try {
      final otpRequest = ForgotRequestmodel(email: email);
      
      final data = await apiService.post(
        UrlConstant.forgotPasswordUrl,
        otpRequest.toJson(),
      );
      print("1111111111$data");
      return ForgotResponsemodel.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }
 


    Future<ResetResponsemodel> resetPassword(String password) async {
    try {
      final Request = ResetRequestmodel(new_password: password);
      
      final data = await apiService.post(
        UrlConstant.resetPasswordUrl,
        Request.toJson(),
      );
      print("1111111111$data");
      return ResetResponsemodel.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }
}