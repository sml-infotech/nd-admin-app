import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_detail_res_model.dart'
    hide ArticleSection;
import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_model.dart';
import 'package:nammadaiva_dashboard/service/blog_service.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class CreateBlogViewmodel extends ChangeNotifier {
  // -------------------- BLOG CONTROLLERS --------------------
  TextEditingController blogName = TextEditingController();
  TextEditingController blogDescription = TextEditingController();
  TextEditingController blogNameKN = TextEditingController();
  TextEditingController blogDescriptionKN = TextEditingController();

  Map<TextEditingController, int> paragraphPositions = {};
  TextEditingController sectionTitle = TextEditingController();
  TextEditingController sectionTitleKn = TextEditingController();

  List<TextEditingController> paragraphControllers = [TextEditingController()];
  // List<TextEditingController> paragraphControllersKN = [
  //   TextEditingController(),
  // ];

  bool isOnlyListEditing = false; // Add this variable
  bool showListGroupEN = false;
  bool showListGroupKN = false;

  String listTypeEN = 'Numbered';
  String listTypeKN = 'Numbered';

  TextEditingController listHeadingControllerEN = TextEditingController();
  TextEditingController listHeadingControllerKN = TextEditingController();

  List<TextEditingController> listItemControllersEN = [TextEditingController()];
  List<TextEditingController> listItemControllersKN = [TextEditingController()];

  // -------------------- DATA --------------------
  List<ArticleSection> articleSectionsEN = [];
  List<ArticleSection> articleSectionsKN = [];

  // -------------------- IMAGE --------------------
  File? selectedImage;
  String? uploadedImageUrl;
  bool isImageUploading = false;

  Map<TextEditingController, int> paragraphPositionsKN = {};

  List<TextEditingController> paragraphControllersKN = [];
  UserService userService = UserService();
  BlogService blogService = BlogService();

  bool isLoading = false;
  String? message;
  List<ArticleSection> addedSectionsEN = [];
  List<ArticleSection> addedSectionsKN = [];
  void finalizeSection() {
    // Check if we have data to save
    if (articleSectionsEN.isNotEmpty && articleSectionsKN.isNotEmpty) {
      final enSection = articleSectionsEN.last;
      final knSection = articleSectionsKN.last;

      if (editingIndex != null) {
        // EDIT MODE: Overwrite the existing item at this index
        addedSectionsEN[editingIndex!] = enSection;
        addedSectionsKN[editingIndex!] = knSection;

        // Reset the index so the next one isn't accidentally treated as an edit
        editingIndex = null;
      } else {
        // ADD MODE: Only if index is null
        addedSectionsEN.add(enSection);
        addedSectionsKN.add(knSection);
      }

      // Clean up temporary working data
      articleSectionsEN.clear();
      articleSectionsKN.clear();
      // resetEverything();

      notifyListeners();
    }
  }

  void removeSection(int index) {
    if (index >= 0 && index < addedSectionsEN.length) {
      addedSectionsEN.removeAt(index);
      addedSectionsKN.removeAt(index);
      notifyListeners(); // Refresh the UI
    }
  }

  void saveFullSectionKN(List<TextEditingController> paragraphCtrls) {
    // Build paragraphs
    final paragraphs = paragraphCtrls
        .where((c) => c.text.trim().isNotEmpty)
        .map(
          (c) => Paragraph(
            text: c.text.trim(),
            position: paragraphCtrls.indexOf(c),
          ),
        )
        .toList();

    // Build lists (if shown)
    List<SectionList> lists = [];
    if (showListGroupKN) {
      lists.add(
        SectionList(
          listType: listTypeKN,
          heading: listHeadingControllerKN.text.trim(),
          position: 0,
          points: listItemControllersKN
              .where((c) => c.text.trim().isNotEmpty)
              .map(
                (c) => Point(
                  text: c.text.trim(),
                  position: listItemControllersKN.indexOf(c),
                ),
              )
              .toList(),
        ),
      );
    }

    // Save section
    articleSectionsKN
      ..clear()
      ..add(
        ArticleSection(
          title: sectionTitleKn.text.trim(),
          position: 0,
          paragraphs: paragraphs,
          lists: lists,
        ),
      );

    notifyListeners();
  }

  SectionList _mapList(SectionList res) {
    return SectionList(
      listType: res.listType,
      heading: res.heading,
      position: res.position,
      points: res.points
          .map((p) => Point(text: p.text, position: p.position))
          .toList(),
    );
  }

  void addParagraphKN() {
    final newController = TextEditingController();

    // 1. Add to the controller list
    paragraphControllersKN.add(newController);

    // 2. Track the position (use current length as the position)
    paragraphPositionsKN[newController] = paragraphControllersKN.length;

    // 3. Refresh the UI
    notifyListeners();
  }

  void prefillBlogData(BlogDetails blog) {
    // 1. Basic Blog Info (English)
    blogName.text = blog.name;
    blogDescription.text = blog.description;
    uploadedImageUrl = blog.image;
    sectionTitle.text = blog.name;

    // 2. Find Kannada Translation safely
    final knTranslation = blog.translations.firstWhere(
      (t) => t.languageCode == 'kn',
      orElse: () => Translation(
        languageCode: 'kn',
        name: '',
        description: '',
        articleSections: [],
      ),
    );
    addedSectionsEN = List<ArticleSection>.from(blog.articleSections);
    addedSectionsKN = List<ArticleSection>.from(knTranslation.articleSections);
    blogNameKN.text = knTranslation.name ?? '';
    blogDescriptionKN.text = knTranslation.description ?? '';
    sectionTitleKn.text =
        knTranslation.name ?? ''; // Or a specific field if available

    // 3. Setup Article Sections
    articleSectionsEN = List<ArticleSection>.from(blog.articleSections);
    articleSectionsKN = List<ArticleSection>.from(
      knTranslation.articleSections,
    );

    // 4. Prefill Paragraphs (EN)
    _prefillParagraphs(
      articleSectionsEN,
      paragraphControllers,
      paragraphPositions,
    );

    // 5. Prefill Paragraphs (KN)
    _prefillParagraphs(
      articleSectionsKN,
      paragraphControllersKN,
      paragraphPositionsKN,
    );

    // 6. Prefill Lists (EN)
    _prefillLists(
      articleSectionsEN,
      (show) => showListGroupEN = show,
      (type) => listTypeEN = type,
      listHeadingControllerEN,
      listItemControllersEN,
    );

    // 7. Prefill Lists (KN)
    _prefillLists(
      articleSectionsKN,
      (show) => showListGroupKN = show,
      (type) => listTypeKN = type,
      listHeadingControllerKN,
      listItemControllersKN,
    );

    notifyListeners();
  }

  // Helper for Paragraphs to keep code clean and sorted
  void _prefillParagraphs(
    List<ArticleSection> sections,
    List<TextEditingController> controllers,
    Map<TextEditingController, int> positions,
  ) {
    isOnlyListEditing = false;

    controllers.clear();
    positions.clear();
    for (var section in sections) {
      if (section.paragraphs != null) {
        // Sort by position
        section.paragraphs!.sort(
          (a, b) => (a.position ?? 0).compareTo(b.position ?? 0),
        );
        for (var p in section.paragraphs!) {
          final ctrl = TextEditingController(text: p.text ?? '');
          controllers.add(ctrl);
          positions[ctrl] = p.position ?? 0;
        }
      }
    }
  }

  void _prefillLists(
    List<ArticleSection> sections,
    Function(bool) setShow,
    Function(String) setType,
    TextEditingController headingCtrl,
    List<TextEditingController> itemCtrls,
  ) {
    isOnlyListEditing = true;
    setShow(false);
    itemCtrls.clear();
    headingCtrl.text = '';
    notifyListeners();
    for (final section in sections) {
      if (section.lists != null && section.lists!.isNotEmpty) {
        final list = section.lists!.first;
        setShow(true);

        String rawType = (list.listType ?? 'ordered').toLowerCase();

        if (rawType == 'ordered' || rawType == 'numbered') {
          setType('Numbered');
        } else if (rawType == 'unordered' ||
            rawType == 'bulleted' ||
            rawType == 'bullet') {
          setType('Bulleted');
        } else {
          setType('Numbered');
        }

        headingCtrl.text = list.heading ?? '';

        if (list.points != null) {
          list.points!.sort(
            (a, b) => (a.position ?? 0).compareTo(b.position ?? 0),
          );
          for (var point in list.points!) {
            itemCtrls.add(TextEditingController(text: point.text ?? ''));
          }
        }
      }
    }
  }

  Future<void> uploadImageToS3(File file) async {
    try {
      isImageUploading = true;
      notifyListeners();

      selectedImage = file;
      final fileName = path.basename(file.path);
      final presigned = await userService.presignedUrl(fileName, file.path);

      if (presigned == null) return;

      final bytes = await file.readAsBytes();
      final mime = lookupMimeType(file.path) ?? 'image/jpeg';

      final res = await http.put(
        Uri.parse(presigned.url),
        body: bytes,
        headers: {'Content-Type': mime},
      );

      if (res.statusCode == 200) {
        uploadedImageUrl = presigned.url.split('?').first;
      }
    } finally {
      isImageUploading = false;
      notifyListeners();
    }
  }

  // Add this variable to track if we are editing
  int? editingIndex;

  void resetEverything() {
    // 1. Reset Top-Level Blog Info (EN & KN)
    blogName.clear();
    blogDescription.clear();
    blogNameKN.clear();
    blogDescriptionKN.clear();

    // 2. Reset Image State
    selectedImage = null;
    uploadedImageUrl = null;
    isImageUploading = false;

    // 3. Clear all stored sections
    addedSectionsEN.clear();
    addedSectionsKN.clear();
    articleSectionsEN.clear();
    articleSectionsKN.clear();

    // 4. Reset Editing State
    editingIndex = null;

    // 5. Reset Working Section Controllers
    sectionTitle.clear();
    sectionTitleKn.clear();

    // Reset Paragraphs to a single empty field
    paragraphControllers = [TextEditingController()];
    paragraphControllersKN = [TextEditingController()];
    paragraphPositions.clear();
    paragraphPositionsKN.clear();

    // 6. Reset List Group State
    showListGroupEN = false;
    showListGroupKN = false;
    listTypeEN = 'Numbered';
    listTypeKN = 'Numbered';
    listHeadingControllerEN.clear();
    listHeadingControllerKN.clear();
    listItemControllersEN = [TextEditingController()];
    listItemControllersKN = [TextEditingController()];

    // 7. Reset Loading/Messages
    isLoading = false;
    message = null;

    notifyListeners();
  }

  // Inside CreateBlogViewmodel

  void prefillSectionForEdit(int index) {
    editingIndex = index;
    final en = addedSectionsEN[index];
    final kn = addedSectionsKN[index];

    // --- English Prefill ---
    sectionTitle.text = en.title ?? '';

    // Paragraphs
    paragraphControllers = en.paragraphs?.isNotEmpty == true
        ? en.paragraphs!
              .map((p) => TextEditingController(text: p.text))
              .toList()
        : [TextEditingController()];

    // Lists (EN)
    if (en.lists != null && en.lists!.isNotEmpty) {
      final list = en.lists!.first;
      showListGroupEN = true;
      listTypeEN = list.listType ?? 'Numbered';
      listHeadingControllerEN.text = list.heading ?? '';

      // Crucial: Clear and Map points to new controllers
      listItemControllersEN = list.points?.isNotEmpty == true
          ? list.points!
                .map((p) => TextEditingController(text: p.text))
                .toList()
          : [TextEditingController()];
    } else {
      showListGroupEN = false;
      listHeadingControllerEN.clear();
      listItemControllersEN = [TextEditingController()];
    }

    // --- Kannada Prefill ---
    sectionTitleKn.text = kn.title ?? '';

    // Paragraphs
    paragraphControllersKN = kn.paragraphs?.isNotEmpty == true
        ? kn.paragraphs!
              .map((p) => TextEditingController(text: p.text))
              .toList()
        : [TextEditingController()];

    // Lists (KN)
    if (kn.lists != null && kn.lists!.isNotEmpty) {
      final listKn = kn.lists!.first;
      showListGroupKN = true;
      listTypeKN = listKn.listType ?? 'Numbered';
      listHeadingControllerKN.text = listKn.heading ?? '';

      listItemControllersKN = listKn.points?.isNotEmpty == true
          ? listKn.points!
                .map((p) => TextEditingController(text: p.text))
                .toList()
          : [TextEditingController()];
    } else {
      showListGroupKN = false;
      listHeadingControllerKN.clear();
      listItemControllersKN = [TextEditingController()];
    }

    notifyListeners();
  }

  Future<void> saveBlog(String? slug, String? blog_id) async {
    try {
      isLoading = true;
      notifyListeners();

      final payload = BlogModel(
        blogId: blog_id,
        name: blogName.text.trim(),
        description: blogDescription.text.trim(),
        image: uploadedImageUrl ?? '',
        isActive: true,
        articleSections: addedSectionsEN,
        translations: [
          Translation(
            languageCode: 'kn',
            name: blogNameKN.text.trim(),
            description: blogDescriptionKN.text.trim(),
            articleSections: addedSectionsKN,
          ),
        ],
      );

      dynamic res;
      if (slug != null && slug.isNotEmpty) {
        res = await blogService.updateBlog(payload);
      } else {
        res = await blogService.createBlog(payload);
      }

      message = res.message;
      if (res.code == 200 || res.code == 201) {
        Fluttertoast.showToast(msg: message ?? "");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
