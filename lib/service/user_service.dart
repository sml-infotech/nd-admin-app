import 'package:nammadaiva_dashboard/model/login_model/contact_us_model/contact_us_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/create_festival/create_festival_modal.dart';
import 'package:nammadaiva_dashboard/model/login_model/create_festival/festival_list_modal.dart';
import 'package:nammadaiva_dashboard/model/login_model/createmodel/create_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/createmodel/create_usermodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/edit_usermodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/edit_userresponse.dart';
import 'package:nammadaiva_dashboard/model/login_model/mark_as_read/mark_as_read_modal.dart';
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

  Future<CreateFestivalResponse> createFestivals(
    String name,
    String description,
    List<String> deityNames,
    String startDate,
    String endDate,
    String startTime,
    String endTime,
    List<String>? images,
  ) async {
    try {
      final createUser = Festival(
        name: name,
        description: description,
        deityNames: deityNames,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        images: images!.map((url) => Image(url: url, isPrimary: true)).toList(),
        isActive: true,
      );

      print(">>>>.${createUser.toJson()}");
      final data = await apiService.post(
        UrlConstant.create_festival,
        createUser.toJson(),
      );
      print("1111111111$data");
      return CreateFestivalResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<UserListResponse> getUserDetails({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    try {
      final url =
          '${UrlConstant.userListUrl}?page=$page&pageSize=$pageSize&search=$search';
      print('Fetching users: $url');
      dynamic data = await apiService.get(url);
      return UserListResponse.fromJson(data);
    } catch (e) {
      print("User service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<ContactResponse> fetchContactUsList(int page) async {
    try {
      final url = '${UrlConstant.contact_us}?page=$page';
      print('Fetching users: $url');
      dynamic data = await apiService.get(url);
      return ContactResponse.fromJson(data);
    } catch (e) {
      print("User service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<FestivalResponse> fetchFestivals(int page) async {
    try {
      final url = '${UrlConstant.list_festivals}?page=$page';
      print('Fetching users: $url');
      dynamic data = await apiService.get(url);
      return FestivalResponse.fromJson(data);
    } catch (e) {
      print("User service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<ContactResponse> markAsRead(String id) async {
    try {
      final url = "${UrlConstant.mark_as_read}/$id/mark-as-read";

      final Map<String, dynamic> data = await apiService.put(url, {});
      return ContactResponse.fromJson(data);
    } catch (e) {
      print("Mark as read API failed: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<EditUserResponse> editUser(
    String id,
    String name,
    String role,
    bool isActive, {
    List<String>? selectedTemples,
  }) async {
    try {
      var editData = EditUsermodel(
        id: id,
        fullName: name,
        role: role,
        isActive: isActive,
        associated_temple_ids: selectedTemples ?? [],
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
