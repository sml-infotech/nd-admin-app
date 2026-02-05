import 'package:nammadaiva_dashboard/model/login_model/booking_model/booking_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_requestmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/master_temple_list_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/post_master_temple_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_onboard/update_onboard_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_request_templemodel/update_request_temple_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_temple_admin/admin_update_templemodal.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_temple_approval/update-temple_approval-response.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_temple_approval/update_temple_approval_modal.dart';
import 'package:nammadaiva_dashboard/model/login_model/updatetemple/update_temple_response.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class TempleService {
  final HttpApiService apiService = HttpApiService();
  Future<TempleResponse> getTemples({
    int page = 1,
    int limit = 10,
    String search = "",
    String language = "kn",
  }) async {
    try {
      final url =
          '${UrlConstant.templeUser}?page=$page&limit=$limit&search=$search&language=$language';
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
    List<Translation> translations,
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
        translations: translations,
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

  Future<PujaListResponse> getPujas(
    String templeId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url =
          '${UrlConstant.getPujas}'
          '?page=$page'
          '&limit=$limit'
          '&language=kn'
          '${templeId != null && templeId.isNotEmpty ? '&temple_id=$templeId' : ''}';

      print('Fetching getPujas: $url');

      dynamic data = await apiService.get(url);
      return PujaListResponse.fromJson(data);
    } catch (e) {
      print("getPujas service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<BookingResponse> fetchBookings(
    String templeId, {
    int page = 1,
    int limit = 10,
    String filter = "",
  }) async {
    try {
      final url =
          '${UrlConstant.bookingList}'
          '?page=$page'
          '&limit=$limit'
          '&$filter=true'
          '${templeId != null && templeId.isNotEmpty ? '&temple_id=$templeId' : ''}';

      print('Fetching bookings: $url');

      dynamic data = await apiService.get(url);
      return BookingResponse.fromJson(data);
    } catch (e) {
      print("Bookings service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<MasterTempleListResponse> fetchMasterTemples({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url =
          '${UrlConstant.master_temples}?page=$page&limit=$limit&language=kn';
      print('Fetching MasterTemples: $url');

      final data = await apiService.get(url);
      return MasterTempleListResponse.fromJson(data);
    } catch (e) {
      print("MasterTemples service decode fails: $e");
      throw Exception('API MasterTemples: $e');
    }
  }

  Future<TempleUpdateResponse> postMasterTemple(
    List<MasterTemple> request,
  ) async {
    try {
      final data = await apiService.post(UrlConstant.create_master_temple, {
        "temples": request.map((e) => e.toJson()).toList(),
      });

      print("✅ Temple Update API Response >>>> $data");
      return TempleUpdateResponse.fromJson(data);
    } catch (e) {
      print("❌ Temple Update service failed: $e");
      throw Exception('Temple update API failed: $e');
    }
  }

  Future<TempleUpdateResponse> updateTemple(
    Map<String, dynamic> payload,
  ) async {
    try {
      print(">>>>>>>>>>>>>>> Temple Update Request JSON >>>>>>>>>>>");
      print(payload);
      print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");

      final data = await apiService.post(UrlConstant.updateTempleUrl, payload);

      print("✅ Temple Update API Response >>>> $data");
      return TempleUpdateResponse.fromJson(data);
    } catch (e) {
      print("❌ Temple Update service failed: $e");
      throw Exception('Temple update API failed: $e');
    }
  }

  Future<MasterTempleListModal> updateOnboard(UpdateOnboardModel datas) async {
    try {
      final request = datas;
      final data = await apiService.put(
        UrlConstant.update_onboard,
        request.toJson(),
      );
      print("✅ update_onboard Update API Response >>>> $data");
      return MasterTempleListModal.fromJson(data);
    } catch (e) {
      print("❌ update_onboard Update service failed: $e");
      throw Exception('update_onboard update API failed: $e');
    }
  }

  Future<AdminTempleUpdateResponse> updateTemplebyAdmin(AddTemple datas) async {
    try {
      final request = datas;
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

  Future<TempleUpdateRequestListModel> fetchUpdateRequests({
    int page = 1,
    int limit = 10,
    required String status,
  }) async {
    try {
      final url =
          '${UrlConstant.updateTempleRequestUrl}?page=$page&limit=$limit$status';
      print('Fetching updateTemple: $url');
      dynamic data = await apiService.get(url);
      return TempleUpdateRequestListModel.fromJson(data);
    } catch (e) {
      print("updateTemple service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<UpdateTempleApprovalResponse> updateApproval(
    String requestId,
    Map<String, String> field_decisions,
    String admin_comments,
  ) async {
    try {
      final request = UpdateTempleApprovalModal(
        requestId: requestId,
        fieldDecisions: field_decisions,
        admin_comments: admin_comments,
      );
      final data = await apiService.put(
        UrlConstant.templeApprovalUrl,
        request.toJson(),
      );

      print("✅ Temple Update API Response >>>> $data");
      return UpdateTempleApprovalResponse.fromJson(data);
    } catch (e) {
      print("❌ Temple Update service failed: $e");
      throw Exception('Temple update API failed: $e');
    }
  }
}
