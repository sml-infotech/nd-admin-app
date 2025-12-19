
import 'package:nammadaiva_dashboard/generated/l10n.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/highlight_create_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/highlight_response_model.dart';
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
}