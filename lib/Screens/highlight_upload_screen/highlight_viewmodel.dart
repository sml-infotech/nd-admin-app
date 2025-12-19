import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'package:nammadaiva_dashboard/model/login_model/highlight_model/active_list_responsemodel.dart';
import 'package:nammadaiva_dashboard/service/highlight_service.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class HighlightViewmodel extends ChangeNotifier {
  final UserService userService = UserService();
  final HighlightService highlightService = HighlightService();

  bool isLoading = false;
  String message = '';

  /// Upload state
final List<XFile> _uploadQueue = [];
  final List<String> uploadedImageUrls = [];

  /// Highlights
  List<HighlightItem> highlightList = [];
  

 List<HighlightItem> get activeHighlights =>
    List.from(highlightList)
      ..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));

List<HighlightItem> get inactiveHighlights =>
    List.from(highlightList)
      ..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));
  Future<void> fetchHighlights({bool refresh = false}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await highlightService.getHighlights();

      if (response.data != null) {
        highlightList = response.data; 
      }
    } catch (e) {
      debugPrint("❌ fetchHighlights error: $e");
      message = "Failed to fetch highlights";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInactiveHighlights() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await highlightService.getInactiveHighlights();

      if (response.data != null) {
        highlightList = response.data; 
      }
    } catch (e) {
      debugPrint("❌ fetchInactiveHighlights error: $e");
      message = "Failed to fetch highlights";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }




  Future<void> addMedia(List<String> filePaths, bool isVideo) async {
    try {
      isLoading = true;
      notifyListeners();

print("Adding media: $filePaths, isVideo: $isVideo");
      for (final path in filePaths) {
        if (_uploadQueue.any((e) => e.path == path)) continue;
        _uploadQueue.add(XFile(path));
      }

      for (final file in List<XFile>.from(_uploadQueue)) {
        await _processUpload(file, isVideo);
        _uploadQueue.remove(file);
      }
    } catch (e) {
      debugPrint("❌ addMedia error: $e");
      message = "Upload failed";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> _processUpload(XFile file, bool isVideo) async {
    final presignedResponse =
        await userService.presignedUrl("highlights/${file.name}", file.path);

    if (presignedResponse.url == null) {
      throw Exception("Failed to get presigned URL");
    }

  print("Presigned URL: ${presignedResponse.url?.split('?').first.trim()}");


    final uploadedUrl =
        await _uploadToS3(presignedResponse.url!, file, isVideo);

    if (uploadedUrl != null) {
      uploadedImageUrls.add(uploadedUrl);
      await _createHighlight(presignedResponse.url?.split('?').first.trim()??"", isVideo);

      await fetchHighlights(refresh: true);
    }
  }

  Future<String?> _uploadToS3(
    String presignedUrl,
    XFile file,
    bool isVideo,
  ) async {
    final bytes = await file.readAsBytes();
    final mimeType =
        isVideo ? 'video/mp4' : lookupMimeType(file.path) ?? 'image/jpeg';

    final response = await http.put(
      Uri.parse(presignedUrl),
      headers: {
        'Content-Type': mimeType,
        'Content-Length': bytes.length.toString(),
      },
      body: bytes,
    );

    return response.statusCode == 200 ? presignedUrl : null;
  }

  Future<void> _createHighlight(String url, bool isVideo) async {
    final response = await highlightService.createHighlight(
      url,
      isVideo ? 'video' : 'image',
      url,
    );

    if (response.code != 200) {
      throw Exception("Failed to create highlight");
    }
  }

  // /* ===================== REORDER ===================== */

  // Future<void> updateHighlightOrder(List<HighlightItem> items) async {
  //   try {
  //     // update local positions
  //     for (int i = 0; i < items.length; i++) {
  //       items[i].position = i + 1;
  //     }

  //     await highlightService.updateHighlightOrder(
  //       items
  //           .map(
  //             (e) => {
  //               "id": e.id,
  //               "position": e.position,
  //             },
  //           )
  //           .toList(),
  //     );

  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint("❌ reorder error: $e");
  //   }
  // }

  /* ===================== TOGGLE ACTIVE / INACTIVE ===================== */

  // Future<void> toggleHighlightStatus(
  //   List<String> ids, {
  //   required bool makeActive,
  // }) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();

  //     await highlightService.updateHighlightStatus(ids, makeActive);

  //     await fetchHighlights(refresh: true);
  //   } catch (e) {
  //     debugPrint("❌ toggle status error: $e");
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
