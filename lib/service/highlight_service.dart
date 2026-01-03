
import 'package:nammadaiva_dashboard/generated/l10n.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/active_list_responsemodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/edit_highlight.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/edit_highlight_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/highlight_create_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/highlight_response_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/reorder_request_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/update_highlight_model.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';
class HighlightService {
  final HttpApiService apiService = HttpApiService();
Future<HighlightResponse> createHighlight(String thumbnailUrl, String mediaType, String mediaUrl) async {
    try {
      final loginRequest = HighlightCreateModel(
        thumbnail_url: thumbnailUrl,
        media_type: mediaType,
        media_url: mediaUrl,
      );

      final data = await apiService.post(
        UrlConstant.create_highlight,
        loginRequest.toJson(),
      );

      return HighlightResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

    Future<ActiveHighlightsResponse> getHighlights() async {
    try {
      final url =
          UrlConstant.list_active_highlights;
      print('Fetching highlights: $url');
      dynamic data = await apiService.get(url);
      return ActiveHighlightsResponse.fromJson(data);
    } catch (e) {
      print("Highlight service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

    Future<ActiveHighlightsResponse> getInactiveHighlights() async {
    try {
      final url =
          UrlConstant.list_inactive_highlights;
      print('Fetching highlights: $url');
      dynamic data = await apiService.get(url);
      return ActiveHighlightsResponse.fromJson(data);
    } catch (e) {
      print("Highlight service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<ReorderResponse> reOrderHighlights(
    String id,
    int from_position,
    int to_position,
   
  ) async {
    try {
      final updatePuja = ReorderRequestModel(
        id: id,
        from_position: from_position,
        to_position: to_position,
      );

      print("-------------------------------------------------------------");

      final data = await apiService.put(
        UrlConstant.reorderHighlight,
        updatePuja.toJson(),
      );


      return ReorderResponse.fromJson(data);
    } catch (e) {
      print("❌  API request failed -> $e");
      throw Exception('API failed: $e');
    }
  }

   Future<HighlightStatusUpdateResponse> updateHighlight(
List<String> ids,
    bool isActive,
   
  ) async {
    try {
      final updateHighlight = HighlightStatusUpdate(ids: ids, isActive: isActive);
        
   

      print("-------------------------------------------------------------");

      final data = await apiService.put(
        UrlConstant.updateHighlight,
        updateHighlight.toJson(),
      );


      return HighlightStatusUpdateResponse.fromJson(data);
    } catch (e) {
      print("❌  API request failed -> $e");
      throw Exception('API failed: $e');
    }
  }

   Future<EditHighlightResponse> EditHighlight(
String id,
    String title,
    String description,
   
  ) async {
    try {
      final updateHighlight = EditHighlightRequest(title: title, description: description);
        print(">>>>>>>>>>>>>><>>>>>>>>${updateHighlight.toJson()}");
   

      print("-------------------------------------------------------------");

      final data = await apiService.put(
        UrlConstant.editHighlight + "/$id",
        updateHighlight.toJson(),
      );


      return EditHighlightResponse.fromJson(data);
    } catch (e) {
      print("❌  API request failed -> $e");
      throw Exception('API failed: $e');
    }
  }
}