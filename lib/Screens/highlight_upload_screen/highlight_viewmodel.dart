import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:nammadaiva_dashboard/generated/l10n.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/highlight_create_model.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/active_list_responsemodel.dart';
import 'package:nammadaiva_dashboard/service/highlight_service.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class HighlightViewmodel extends ChangeNotifier {
  final UserService userService = UserService();
  final HighlightService highlightService = HighlightService();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleControllerInKannadam = TextEditingController();
  TextEditingController descriptionControllerInKannadam =
      TextEditingController();
  XFile? pickedFile;

  bool isLoading = false;
  String message = '';

  final List<XFile> _uploadQueue = [];
  final List<String> uploadedImageUrls = [];

  List<HighlightItem> highlightList = [];
  List<HighlightItem> inActiveList = [];

  List<HighlightItem> get activeHighlights =>
      List.from(highlightList)
        ..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));

  List<HighlightItem> get inactiveHighlights =>
      List.from(inActiveList)
        ..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));

  VideoPlayerController? videoController;
  bool isVideo(String path) {
    String cleanPath = path.split('?').first.toLowerCase();
    return cleanPath.endsWith('.mp4') || cleanPath.endsWith('.mov');
  }

  void setPickedFile(XFile? file) {
    pickedFile = file;
    notifyListeners();
  }

  // Initialize and manage video
  Future<void> initializeVideo(String path) async {
    await disposeVideo(); // Clear existing
    videoController = VideoPlayerController.file(File(path));
    try {
      await videoController!.initialize();
      videoController!.play();
      videoController!.setLooping(true);
      notifyListeners();
    } catch (e) {
      debugPrint("Video Init Error: $e");
    }
  }

  Future<void> disposeVideo() async {
    if (videoController != null) {
      await videoController!.pause();
      await videoController!.dispose();
      videoController = null;
      notifyListeners();
    }
  }

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
        inActiveList = response.data;
      }
    } catch (e) {
      debugPrint("❌ fetchInactiveHighlights error: $e");
      message = "Failed to fetch highlights";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMedia(List<String> filePaths, bool isVideo) async {
    try {
      isLoading = true;
      notifyListeners();

      for (final path in filePaths) {
        if (_uploadQueue.any((e) => e.path == path)) continue;
        _uploadQueue.add(XFile(path));
      }

      for (final file in List<XFile>.from(_uploadQueue)) {
        await _processUpload(file, isVideo);
        _uploadQueue.remove(file);
      }

      return true; // ✅ SUCCESS
    } catch (e) {
      debugPrint("❌ addMedia error: $e");
      message = "Upload failed";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearUploadData() {
    // Clear Text Controllers
    titleController.clear();
    descriptionController.clear();
    titleControllerInKannadam.clear();
    descriptionControllerInKannadam.clear();

    // Clear Media State
    pickedFile = null;

    // Dispose and nullify video controller if it exists
    if (videoController != null) {
      videoController!.dispose();
      videoController = null;
    }

    // Notify listeners so the UI updates (e.g., hides the preview)
    notifyListeners();
  }

  Future<void> _processUpload(XFile file, bool isVideo) async {
    // 1️⃣ Upload main file (video / image)
    final presignedResponse = await userService.presignedUrl(
      "highlights/${file.name}",
      file.path,
    );

    if (presignedResponse.url == null) {
      throw Exception("Failed to get presigned URL");
    }

    final uploadedUrl = await _uploadToS3(
      presignedResponse.url!,
      file,
      isVideo,
    );

    if (uploadedUrl == null) return;

    String? thumbnailUrl;

    // 2️⃣ If video → generate + upload thumbnail
    if (isVideo) {
      final thumbnailFile = await generateVideoThumbnail(file);

      final thumbPresigned = await userService.presignedUrl(
        "highlights/thumb_${file.name}.jpg",
        thumbnailFile.path,
      );

      if (thumbPresigned.url != null) {
        await _uploadToS3(
          thumbPresigned.url!,
          XFile(thumbnailFile.path),
          false,
        );

        thumbnailUrl = thumbPresigned.url!.split('?').first.trim();
      }
    }

    // 3️⃣ Create highlight
    await _createHighlight(
      presignedResponse.url!.split('?').first.trim(),
      isVideo,
      thumbnailUrl ?? presignedResponse.url!.split('?').first.trim(),
    );

    await fetchHighlights(refresh: true);
    resetAfterCreate();
  }

  Future<String?> _uploadToS3(
    String presignedUrl,
    XFile file,
    bool isVideo,
  ) async {
    final bytes = await file.readAsBytes();
    final mimeType = isVideo
        ? 'video/mp4'
        : lookupMimeType(file.path) ?? 'image/jpeg';

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

  Future<void> _createHighlight(
    String url,
    bool isVideo,
    String? thumbnailUrl,
  ) async {
    final response = await highlightService.createHighlight(
      thumbnailUrl ?? url,
      isVideo ? 'video' : 'image',
      url,
      titleController.text.trim(),
      descriptionController.text.trim(),
      titleControllerInKannadam.text.isNotEmpty ||
              descriptionControllerInKannadam.text.isNotEmpty
          ? [
              HighLightTranslateModel(
                languageCode: "kn",
                title: titleControllerInKannadam.text.trim(),
                description: descriptionControllerInKannadam.text.trim(),
              ),
            ]
          : null,
    );

    if (response.code != 200) {
      throw Exception("Failed to create highlight");
    }
  }

  Future<void> reorderHighlights(
    String id,
    int fromPosition,
    int toPosition,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await highlightService.reOrderHighlights(
        id,
        fromPosition,
        toPosition,
      );

      if (response.code == 200) {
        await fetchHighlights(refresh: true);
      } else {
        throw Exception("Failed to reorder highlights");
      }
    } catch (e) {
      debugPrint("❌ reorderHighlights error: $e");
      message = "Reorder failed";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetAfterCreate() {
    _uploadQueue.clear();
    uploadedImageUrls.clear();
    message = '';
    isLoading = false;
    titleController.clear();
    descriptionController.clear();
    notifyListeners();
  }

  Future<void> updateHighlight(List<String> ids, bool isActive) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await highlightService.updateHighlight(ids, isActive);

      if (response.code == 200) {
        print("✅ Highlights updated successfully");
      } else {
        throw Exception("Failed to reorder highlights");
      }
    } catch (e) {
      debugPrint("❌ reorderHighlights error: $e");
      message = "Reorder failed";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editHighlight(
    String id,
    String title,
    String description,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await highlightService.EditHighlight(
        id,
        title,
        description,
        titleControllerInKannadam.text.isNotEmpty ||
                descriptionControllerInKannadam.text.isNotEmpty
            ? [
                HighLightTranslateModel(
                  languageCode: "kn",
                  title: titleControllerInKannadam.text.trim(),
                  description: descriptionControllerInKannadam.text.trim(),
                ),
              ]
            : null,
      );

      if (response.code == 200) {
        print("✅ Highlights updated successfully${response}");
        resetAfterCreate();
      } else {
        throw Exception("Failed to reorder highlights");
      }
    } catch (e) {
      debugPrint("❌ reorderHighlights error: $e");
      message = "Reorder failed";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

Future<File> generateVideoThumbnail(XFile videoFile) async {
  final tempDir = await getTemporaryDirectory();

  final thumbnailPath = await VideoThumbnail.thumbnailFile(
    video: videoFile.path,
    thumbnailPath: tempDir.path,
    imageFormat: ImageFormat.JPEG,
    quality: 75,
    timeMs: 7, 
  );

  if (thumbnailPath == null) {
    throw Exception("Thumbnail generation failed");
  }

  return File(thumbnailPath);
}
