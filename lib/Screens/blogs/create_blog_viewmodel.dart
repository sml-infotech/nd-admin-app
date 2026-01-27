import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_model.dart';
import 'package:nammadaiva_dashboard/service/blog_service.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

class CreateBlogViewmodel extends ChangeNotifier {
  TextEditingController blogName = TextEditingController();
  TextEditingController blogDescription = TextEditingController();
  TextEditingController blogNameKN = TextEditingController();
  TextEditingController blogDescriptionKN = TextEditingController();
  TextEditingController sectionTitle = TextEditingController();
  TextEditingController sectionTitleKn = TextEditingController();
  List<TextEditingController> paragraphControllers = [TextEditingController()];

  UserService userService = UserService();
  BlogService blogService = BlogService();
  File? selectedImage;
  String? uploadedImageUrl;
  String? message;
  bool isImageUploading = false;
  bool showListGroupEN = false;
  bool showListGroupKN = false;
  String listTypeEN = 'Numbered';
  String listTypeKN = 'Numbered';
  final TextEditingController listHeadingControllerEN = TextEditingController();
  final TextEditingController listHeadingControllerKN = TextEditingController();

  final List<TextEditingController> listItemControllersEN = [
    TextEditingController(),
  ];
  final List<TextEditingController> listItemControllersKN = [
    TextEditingController(),
  ];
  bool isLoading = false;

  List<ArticleSection> articleSectionsEN = [];
  List<ArticleSection> articleSectionsKN = [];

  void addArticleSection(List<TextEditingController> para) {
    List<String> paragraphs = para
        .map((controller) => controller.text.trim())
        .toList();

    if (sectionTitle.text.trim().isEmpty) {
      return;
    }

    if (paragraphs.isEmpty || paragraphs.any((p) => p.isEmpty)) {
      return;
    }

    // articleSections.add(
    //   ArticleSection(
    //     sectionTitle: sectionTitle.text.trim(),
    //     paragraphs: paragraphs,
    //     listType: listType,
    //     listHeading: listHeadingController.text.trim(),
    //     listItems: listItemControllers.map((c) => c.text.trim()).toList(),
    //   ),
    // );
  }

  void saveFullSectionKN(List<TextEditingController> knParagraphs) {
    final kannadaSection = ArticleSection(
      title: sectionTitleKn.text.trim(),
      position: articleSectionsKN.length + 1,
      paragraphs: knParagraphs.asMap().entries.map((entry) {
        return Paragraph(
          text: entry.value.text.trim(),
          position: entry.key + 1,
        );
      }).toList(),
      lists: showListGroupKN
          ? [
              SectionList(
                listType: listTypeKN,
                heading: listHeadingControllerKN.text.trim(),
                position: 1,
                points: listItemControllersKN.asMap().entries.map((entry) {
                  return Point(
                    text: entry.value.text.trim(),
                    position: entry.key + 1,
                  );
                }).toList(),
              ),
            ]
          : [],
    );

    articleSectionsKN.add(kannadaSection);
    notifyListeners();
  }

  void resetForm() {
    // Blog fields
    blogName.clear();
    blogDescription.clear();
    blogNameKN.clear();
    blogDescriptionKN.clear();

    // Section fields
    sectionTitle.clear();
    sectionTitleKn.clear();

    // Paragraphs
    for (final c in paragraphControllers) {
      c.dispose();
    }
    paragraphControllers = [TextEditingController()];

    // List section
    listHeadingControllerEN.clear();
    for (final c in listItemControllersEN) {
      c.dispose();
    }
    listHeadingControllerEN.clear();
    listItemControllersEN.add(TextEditingController());

    showListGroupEN = false;
    showListGroupKN = false;

    // Image
    selectedImage = null;
    uploadedImageUrl = null;
    isImageUploading = false;

    // Article sections
    articleSectionsEN.clear();
    articleSectionsKN.clear();

    message = null;
    isLoading = false;

    notifyListeners();
  }

  Future<void> uploadImageToS3(File file) async {
    try {
      isImageUploading = true;
      notifyListeners();

      selectedImage = file;
      final fileName = path.basename(file.path);

      final presignedUrl = await userService.presignedUrl(fileName, file.path);
      if (presignedUrl == null) {
        message = "Failed to get upload URL";
        return;
      }

      final imageUrl = await uploadToS3(presignedUrl.url, file);
      if (imageUrl == null) {
        message = "Image upload failed";
        return;
      }

      uploadedImageUrl = imageUrl;
      message = "File uploaded successfully";
    } catch (e) {
      message = "Upload error: $e";
    } finally {
      isImageUploading = false;
      notifyListeners();
    }
  }

  Future<String?> uploadToS3(String presignedUrl, File imageFile) async {
    try {
      final fileBytes = await imageFile.readAsBytes();

      final mimeType =
          lookupMimeType(imageFile.path) ?? 'application/octet-stream';

      final response = await http.put(
        Uri.parse(presignedUrl),
        body: fileBytes,
        headers: {'Content-Type': mimeType},
      );

      if (response.statusCode == 200) {
        final imageUrl = presignedUrl.split('?').first;
        print("✅ Uploaded successfully: $imageUrl");
        return imageUrl;
      } else {
        print("❌ Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error uploading to S3: $e");
      return null;
    }
  }

  Future<void> addBlog() async {
    try {
      isLoading = true;
      notifyListeners();

      final request = BlogModel(
        name: blogName.text.trim(),
        description: blogDescription.text.trim(),
        image: uploadedImageUrl ?? "",
        isActive: true,
        articleSections: articleSectionsEN,
        translations: [
          Translation(
            languageCode: "kn",
            name: blogNameKN.text.trim(),
            description: blogDescriptionKN.text.trim(),
            articleSections: articleSectionsKN,
          ),
        ],
      );

      print("Payload: ${request.toJson()}");

      final response = await blogService.createBlog(request);
      if (response.code == 201) {
        message = response.message ?? "Blog created successfully";
        resetForm();
      }
    } catch (e) {
      message = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
