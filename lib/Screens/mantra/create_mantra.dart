import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/update_mantra.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_model.dart';
import 'package:provider/provider.dart' show Provider;
import 'create_mantra_viewmodel.dart';

class CreateMantraScreen extends StatefulWidget {
  final UpdateMantraArguments? updateMantra;
  const CreateMantraScreen({super.key, required this.updateMantra});

  @override
  State<CreateMantraScreen> createState() => _CreateMantraScreenState();
}

class _CreateMantraScreenState extends State<CreateMantraScreen> {
  late CreateMantraViewmodel viewModel;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<CreateMantraViewmodel>(context, listen: false);
    loadData();
  }

  void loadData() {
    if (widget.updateMantra == null) return;

    viewModel.mantraName.text = widget.updateMantra!.mantraName;
    viewModel.mantra.text = widget.updateMantra!.mantra;
    viewModel.uploadedImageUrl = widget.updateMantra!.image;
    viewModel.selectedImage = null;

    final knTranslation = widget.updateMantra!.translations?.firstWhere(
      (t) => t.languageCode == 'kn',
      orElse: () =>
          MantraTranslation(languageCode: 'kn', mantraName: '', mantra: ''),
    );

    viewModel.mantraNameInKannadam.text = knTranslation?.mantraName ?? "";
    viewModel.mantraInKannadam.text = knTranslation?.mantra ?? "";
  }

  Future<void> pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final imageFile = File(file.path);

      viewModel.selectedImage = imageFile;
      setState(() {});

      await viewModel.uploadImageToS3(imageFile);

      if (viewModel.message != null && viewModel.message!.isNotEmpty) {
        Fluttertoast.showToast(msg: viewModel.message!);
        viewModel.isImageUploading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<CreateMantraViewmodel>(context);

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: appBarForCreateMantra(),
        automaticallyImplyLeading: false,
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

        child: Stack(
          children: [
            Column(
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

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        mantraTextField(),
                        const SizedBox(height: 16),
                        mantraNameTextField(),
                        const SizedBox(height: 16),
                        mantraImagePicker(),
                        const SizedBox(height: 30),
                        Spacer(),
                        createMantraButton(viewModel),
                      ],
                    ),
                  ),
                ),
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

  Widget mantraTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.enterMantraName,
      labelText: AppLocalizations.of(context)!.mantraName,
      controller: viewModel.mantraName,
      isFromPassword: false,
    );
  }

  Widget mantraNameTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.mantra,
      labelText: AppLocalizations.of(context)!.enterMantra,
      controller: viewModel.mantra,
      isFromPassword: false,
    );
  }

  Widget mantraImagePicker() {
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
    if (viewModel.selectedImage != null) {
      return Image.file(
        viewModel.selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (viewModel.uploadedImageUrl != null &&
        viewModel.uploadedImageUrl!.isNotEmpty) {
      return Image.network(
        viewModel.uploadedImageUrl!,
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
        "Tap to pick Mantra image",
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  Widget appBarForCreateMantra() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            viewModel.reset();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          widget.updateMantra!.mantra.isEmpty
              ? AppLocalizations.of(context)!.createMantra
              : "Update Mantra",
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        SizedBox(width: 30),
      ],
    );
  }

  Widget createMantraButton(CreateMantraViewmodel viewmodel) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(
                  context,
                  StringsRoute.createMantrainKn,
                  arguments: widget.updateMantra,
                );
                // if (await viewmodel.validateForm()) {
                //   if (widget.updateMantra!.mantra.isEmpty) {
                //     await viewmodel.createMantra();
                //   } else {
                //     await viewmodel.updateMantra(
                //       widget.updateMantra!.mantraID!,
                //     );
                //   }
                //   if (viewmodel.isCompleted) {
                //     Navigator.pop(context);
                //   }
                //   viewmodel.isLoading = false;
                // }

                // Fluttertoast.showToast(msg: viewmodel.message ?? "");
                viewmodel.message = "";
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                widget.updateMantra!.mantra.isEmpty
                    ? AppLocalizations.of(context)!.create
                    : AppLocalizations.of(context)!.update,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
