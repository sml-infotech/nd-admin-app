import 'package:nammadaiva_dashboard/model/login_model/createmodel/create_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/createmodel/create_usermodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/edit_usermodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/edit_userresponse.dart';
import 'package:nammadaiva_dashboard/model/login_model/presignedurl/presigned_requestmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/user_listModel.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class UserService {
  final HttpApiService apiService = HttpApiService();
  Future<UserResponse> createUser(
    String name,
    String email,
    String password,
    String role,
    List<String>? templeId,
    String phone,
  ) async {
    print(">>>>.${templeId}");
    try {
      final createUser = CreateUsermodel(
        full_name: name,
        email: email,
        password: password,
        role: role,
        temple_ids: templeId,
        phone_number: phone,
      );

      final data = await apiService.post(
        UrlConstant.createUser,
        createUser.toJson(),
      );
      print("1111111111$data");
      return UserResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<UserListResponse> getUserDetails({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final url = '${UrlConstant.userListUrl}?page=$page&pageSize=$pageSize';
      print('Fetching users: $url');
      dynamic data = await apiService.get(url);
      return UserListResponse.fromJson(data);
    } catch (e) {
      print("User service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<EditUserResponse> editUser(
    String id,
    String name,
    String role,
    bool isActive,
  ) async {
    try {
      var editData = EditUsermodel(
        id: id,
        fullName: name,
        role: role,
        isActive: isActive,
      );

      final url = UrlConstant.userEditUrl;
      dynamic data = await apiService.put(url, editData.toJson());
      return EditUserResponse.fromJson(data);
    } catch (e) {
      print("Edit user API failed: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<PresignedUrlResponse> presignedUrl(
    String filename,
    String contentType,
  ) async {
    try {
      final otpRequest = TempleImage(
        filename: filename,
        contentType: contentType,
      );

      final data = await apiService.post(
        UrlConstant.presignedUrl,
        otpRequest.toJson(),
      );
      print("1111111111$data");
      return PresignedUrlResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }
}
