import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/article_section.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/create_blog_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart'
    show ColorConstant, font;
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_detail_res_model.dart'
    hide ArticleSection;
import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_model.dart';
import 'package:provider/provider.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/article_section_kannadam.dart'; // Import Kannada Screen

class CreateBlogScreen extends StatefulWidget {
  BlogDetails? blogs;
  CreateBlogScreen({super.key, this.blogs});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  late CreateBlogViewmodel viewmodel;
  final ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<CreateBlogViewmodel>(context, listen: false);
    viewmodel.resetEverything();
    if (widget.blogs != null) {
      viewmodel.prefillBlogData(widget.blogs!);
    }
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<CreateBlogViewmodel>(context);

    print(">>>>>>>>>>>>${widget.blogs?.slug ?? ""}");
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
            Consumer<CreateBlogViewmodel>(
              builder: (context, vm, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.addedSectionsEN.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // 1. Prefill data
                        vm.prefillSectionForEdit(index);
                        // 2. Open Bottom Sheet
                        _openArticleSectionBottomSheet(context);
                      },
                      child: _buildSectionPreviewTile(
                        vm.addedSectionsEN[index],
                        index,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionPreviewTile(ArticleSection section, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ColorConstant.buttonColor,
          child: Text(
            "${index + 1}",
            style: TextStyle(color: Colors.white, fontFamily: font),
          ),
        ),
        title: Text(
          section.title ?? "Untitled Section",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: font),
        ),
        subtitle: Text(
          "${section.paragraphs?.length ?? 0} Paragraphs",
          style: TextStyle(fontFamily: font),
        ),
        // Replaced check with Delete button
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            // Trigger delete logic
            _showDeleteConfirmation(index);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Section?"),
        content: const Text("Are you sure you want to remove this section?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              viewmodel.removeSection(index);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

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

  Widget addSectionText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              viewmodel.resetEverything();
              _openArticleSectionBottomSheet(context);
            },
            child: const Text(
              "Add Section",
              style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 16),

          if (viewmodel.addedSectionsEN.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await viewmodel.saveBlog(
                    widget.blogs?.slug,
                    widget.blogs?.id,
                  );
                  viewmodel.resetEverything();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: viewmodel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : viewmodel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.blogs != null ? "Update Blog" : "Create Blog",
                        style: AppTextStyles.buttonTextStyle,
                      ),
              ),
            ),
        ],
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
          child: viewmodel.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  widget.blogs != null ? "Update Blog" : "Create Blog",
                  style: AppTextStyles.buttonTextStyle,
                ),
        ),
      ),
    );
  }

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
          widget.blogs != null ? "Update Blog" : "Create Blog", // Dynamic Title
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
    FocusScope.of(navContext).unfocus();

    if (viewModel.sectionTitle.text.trim().isNotEmpty &&
        viewModel.paragraphControllers.isNotEmpty &&
        viewModel.paragraphControllers.every((c) => c.text.trim().isNotEmpty)) {
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
      viewModel.articleSectionsEN.clear();
      viewModel.articleSectionsEN.add(newSectionEN);
      Navigator.push(
        navContext,
        MaterialPageRoute(
          builder: (context) => const CreateBlogScreenKannada(),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Fill the fields");
    }
  }
}
