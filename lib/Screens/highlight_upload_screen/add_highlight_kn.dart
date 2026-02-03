import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/highlight_upload_screen/highlight_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AddHighlightInKannadam extends StatefulWidget {
  const AddHighlightInKannadam({super.key});

  @override
  State<AddHighlightInKannadam> createState() => _AddHighlightInKannadamState();
}

class _AddHighlightInKannadamState extends State<AddHighlightInKannadam> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HighlightViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: nammaDaivaCreateAppBar(),
        backgroundColor: ColorConstant.buttonColor,
        centerTitle: true,
      ),
      body: FocusDetector(
        onFocusGained: () async {
        },
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 15),
                uploadContentWidget(viewModel),
              ],
            ),
            if (viewModel.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.buttonColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget nammaDaivaCreateAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.addHighlights,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget uploadContentWidget(HighlightViewmodel viewModel) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            CommonTextField(
              hintText: "Tap to select HighLights",
              labelText: "Title",
              isFromPassword: false,
              controller: viewModel.titleControllerInKannadam,
            ),
            SizedBox(height: 15),
            CommonTextField(
              hintText: "Tap to select HighLights",
              labelText: "Description",
              isFromPassword: false,
              controller: viewModel.descriptionControllerInKannadam,
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(16),
              child: uploadButton(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadButton(HighlightViewmodel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonColor,
        ),
        onPressed: viewModel.isLoading ? null : _handleUpload,
        child: viewModel.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Upload ",
                style: TextStyle(fontFamily: font, color: Colors.white),
              ),
      ),
    );
  }
Future<void> _handleUpload() async {
  final viewModel = Provider.of<HighlightViewmodel>(context, listen: false);

  if (viewModel.pickedFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No media selected from previous screen"))
    );
    return;
  }

  // Use the helper from ViewModel
  final bool isVideo = viewModel.isVideo(viewModel.pickedFile!.path);

  // Call the upload logic
  final bool success = await viewModel.addMedia(
    [viewModel.pickedFile!.path], 
    isVideo
  );

  if (success) {
    viewModel.clearUploadData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Upload Successful!"))
    );
    // Go back to the main list
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
}
