import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/article_section.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/create_blog_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart'
    show ColorConstant, font;
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_model.dart';
import 'package:provider/provider.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/article_section_kannadam.dart'; // Import Kannada Screen

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  late CreateBlogViewmodel viewmodel;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<CreateBlogViewmodel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaAppBar(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          children: [
            CommonTextField(
              hintText: AppLocalizations.of(context)!.enterblogName,
              labelText: AppLocalizations.of(context)!.enterblogName,
              isFromPassword: false,
              controller: viewmodel.blogName,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              hintText: AppLocalizations.of(context)!.enterblogDescription,
              labelText: AppLocalizations.of(context)!.enterblogDescription,
              isFromPassword: false,
              isFromDescription: true,
              controller: viewmodel.blogDescription,
            ),
            const SizedBox(height: 16),
            blogImagePicker(),
            const SizedBox(height: 16),
            addSectionText(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Image picker logic
  Future<void> pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final imageFile = File(file.path);

      viewmodel.selectedImage = imageFile;
      setState(() {});

      await viewmodel.uploadImageToS3(imageFile);

      if (viewmodel.message != null && viewmodel.message!.isNotEmpty) {
        Fluttertoast.showToast(msg: viewmodel.message!);
        viewmodel.isImageUploading = false;
      }
    }
  }

  // Add section text
  Widget addSectionText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
      child: InkWell(
        onTap: () {
          _openArticleSectionBottomSheet(context);
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Add Section",
            style: TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.w600,
              fontFamily: font,
            ),
          ),
        ),
      ),
    );
  }

  void _openArticleSectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              // THE KEY: Nested Navigator
              child: Navigator(
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (navContext) => SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        const ArticleSectionUI(),
                        const SizedBox(height: 10),
                        createUserButton(viewmodel, navContext),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget createUserButton(CreateBlogViewmodel viewModel, navContext) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            onCreateENSectionButtonPressed(viewModel, context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstant.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.create,
            style: AppTextStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }

  // Image picker widget
  Widget blogImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black54),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: buildImageView(),
          ),
        ),
      ),
    );
  }

  // Image view widget
  Widget buildImageView() {
    if (viewmodel.selectedImage != null) {
      return Image.file(
        viewmodel.selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (viewmodel.uploadedImageUrl != null &&
        viewmodel.uploadedImageUrl!.isNotEmpty) {
      return Image.network(
        viewmodel.uploadedImageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, size: 50));
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Center(
      child: Text(
        "Tap to pick image",
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  // AppBar widget
  Widget nammaDaivaAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.create_blog,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const SizedBox(width: 48),
        const Spacer(),
      ],
    );
  }

  void onCreateENSectionButtonPressed(
    CreateBlogViewmodel viewModel,
    BuildContext navContext,
  ) {
    // Remove keyboard focus
    FocusScope.of(navContext).unfocus();

    // Validation: section title + at least one paragraph
    if (viewModel.sectionTitle.text.trim().isNotEmpty &&
        viewModel.paragraphControllers.isNotEmpty &&
        viewModel.paragraphControllers.every((c) => c.text.trim().isNotEmpty)) {
      // Create new English section
      final newSectionEN = ArticleSection(
        title: viewModel.sectionTitle.text.trim(),
        position: viewModel.articleSectionsEN.length + 1,
        paragraphs: viewModel.paragraphControllers.asMap().entries.map((entry) {
          return Paragraph(
            text: entry.value.text.trim(),
            position: entry.key + 1,
          );
        }).toList(),
        lists: viewModel.showListGroupEN
            ? [
                SectionList(
                  listType: viewModel.listTypeEN,
                  heading: viewModel.listHeadingControllerEN.text.trim(),
                  position: 1,
                  points: viewModel.listItemControllersEN.asMap().entries.map((
                    entry,
                  ) {
                    return Point(
                      text: entry.value.text.trim(),
                      position: entry.key + 1,
                    );
                  }).toList(),
                ),
              ]
            : [],
      );

      // Add to EN article sections
      viewModel.articleSectionsEN.add(newSectionEN);

      // Navigate to Kannada screen
      Navigator.push(
        navContext,
        MaterialPageRoute(
          builder: (context) => const CreateBlogScreenKannada(),
        ),
      );
    } else {
      // Show toast if fields are empty
      Fluttertoast.showToast(msg: "Fill the fields");
    }
  }
}
