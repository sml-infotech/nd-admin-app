import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/article_section.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/create_blog_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart' show ColorConstant;
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
    return Stack(
      children: [
        Scaffold(
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
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),

                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CommonTextField(
                              hintText: AppLocalizations.of(
                                context,
                              )!.enterblogName,
                              labelText: AppLocalizations.of(
                                context,
                              )!.enterblogName,
                              isFromPassword: false,
                              controller: viewmodel.blogName,
                            ),
                            SizedBox(height: 16),
                            CommonTextField(
                              hintText: AppLocalizations.of(
                                context,
                              )!.enterblogDescription,
                              labelText: AppLocalizations.of(
                                context,
                              )!.enterblogDescription,
                              isFromPassword: false,
                              isFromDescription: true,
                              controller: viewmodel.blogDescription,
                            ),
                            SizedBox(height: 16),
                            blogImagePicker(),
                            SizedBox(height: 16),
                            ArticleSectionUI(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        SizedBox(width: 48),
        const Spacer(),
      ],
    );
  }
}
