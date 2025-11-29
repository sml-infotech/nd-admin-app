import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:provider/provider.dart' show Provider;
import 'create_mantra_viewmodel.dart';

class CreateMantraScreen extends StatefulWidget {
  const CreateMantraScreen({super.key});

  @override
  State<CreateMantraScreen> createState() => _CreateMantraScreenState();
}

class _CreateMantraScreenState extends State<CreateMantraScreen> {
  late CreateMantraViewmodel viewModel;

  final ImagePicker picker = ImagePicker();

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
      hintText: StringConstant.enterMantraName,
      labelText: StringConstant.mantraName,
      controller: viewModel.mantraName,
      isFromPassword: false,
    );
  }

  Widget mantraNameTextField() {
    return CommonTextField(
      hintText: StringConstant.mantra,
      labelText: StringConstant.enterMantra,
      controller: viewModel.mantra,
      isFromPassword: false,
    );
  }

  Widget mantraImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 0),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black54),
          ),
          child: viewModel.selectedImage == null
              ? Center(
                  child: Text(
                    "Tap to pick Mantra image",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: font,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    viewModel.selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
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
          StringConstant.createMantra,
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
                if (await viewmodel.validateForm()) {
                  await viewmodel.createMantra();
                  viewmodel.isLoading = false;
                }

                Fluttertoast.showToast(msg: viewmodel.message ?? "");
                viewmodel.message = "";
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                StringConstant.create,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
