import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/image_picker.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/temple_input_widget.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class AddTempleScreen extends StatefulWidget {
  const AddTempleScreen({super.key});

  @override
  State<AddTempleScreen> createState() => _AddTempleScreenState();
}

class _AddTempleScreenState extends State<AddTempleScreen> {
  late AddTempleViewmodel templeViewmodel;
  final ImagePicker _picker = ImagePicker();
 @override
  void dispose() {
   
    templeViewmodel.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    templeViewmodel = Provider.of<AddTempleViewmodel>(context);



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaCreateAppBar(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    CommonTextField(
                      hintText:   AppLocalizations.of(context)!.templeName,
                      labelText:  AppLocalizations.of(context)!.templeName,
                      isFromPassword: false,
                      controller: templeViewmodel.templeName,
                    ),
                    CommonTextField(
                      hintText:  AppLocalizations.of(context)!.address,
                      labelText: AppLocalizations.of(context)!.address,
                      isFromPassword: false,
                      controller: templeViewmodel.address,
                    ),
                    CommonTextField(
                      hintText: AppLocalizations.of(context)!.city,
                      labelText:AppLocalizations.of(context)!.city,
                      isFromPassword: false,
                      controller: templeViewmodel.city,
                    ),
                    CommonTextField(
                      hintText: AppLocalizations.of(context)!.state,
                      labelText: AppLocalizations.of(context)!.state,
                      isFromPassword: false,
                      controller: templeViewmodel.state,
                    ),
                    CommonTextField(
                      hintText: AppLocalizations.of(context)!.pincode,
                      labelText: AppLocalizations.of(context)!.pincode,
                      isFromPassword: false,
                      controller: templeViewmodel.pincode,
                    ),
                    CommonTextField(
                      hintText: AppLocalizations.of(context)!.architecture,
                      labelText: AppLocalizations.of(context)!.architecture,
                      isFromPassword: false,
                      controller: templeViewmodel.architecture,
                    ),
                    CommonTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      labelText: AppLocalizations.of(context)!.email,
                      isFromPassword: false,
                      controller: templeViewmodel.email,
                    ),
                    CommonTextField(
                      hintText: AppLocalizations.of(context)!.phone,
                      labelText: AppLocalizations.of(context)!.phone,
                      isFromPassword: false,
                      controller: templeViewmodel.phone,
                      isFromPhone: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TempleInputWidget(viewmodel: templeViewmodel),
                    ),
                    _buildImagePicker(),
                    CommonTextField(
                      hintText: AppLocalizations.of(context)!.description,
                      labelText: AppLocalizations.of(context)!.description,
                      isFromPassword: false,
                      controller: templeViewmodel.description,
                      isFromDescription: true,
                    ),
                    addTempleButton(),
                  ],
                ),
              ),
            ),
            if (templeViewmodel.isLoading)
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

  Widget _buildImagePicker() {
    final uploadedCount = templeViewmodel.uploadedImageUrls.length;

    final allImages = [
      ...templeViewmodel.uploadedImageUrls,
      ...templeViewmodel.selectedImages.map((e) => e.path),
    ];

    return MultiImagePickerSection(
      imagePaths: allImages,
      onAddImages: _pickImages,
      onRemoveImage: (index) {
        if (index >= uploadedCount) {
          final localIndex = index - uploadedCount;
          templeViewmodel.removeImage(localIndex);
        } else {
          templeViewmodel.uploadedImageUrls.removeAt(index);
          templeViewmodel.notifyListeners();
        }
      },
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final imagePaths = pickedFiles.map((e) => e.path).toList();
      templeViewmodel.addImages(imagePaths);
    }
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
    Text(  AppLocalizations.of(context)!.addTemple, style: AppTextStyles.appBarTitleStyle),
    const Spacer(),
    const SizedBox(width: 48),
  ],
);
}

  Widget addTempleButton() {
    return Consumer<AddTempleViewmodel>(
      builder: (context, templeViewmodel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                if (templeViewmodel.validateAddTemple()) {
                  templeViewmodel.isLoading = true;
                  await templeViewmodel.presignedUrl();
                  Fluttertoast.showToast(msg: templeViewmodel.message ?? "");

                  if (templeViewmodel.templeAdded == true) {
                    Navigator.pushNamed(context, StringsRoute.templeScreen);
                    setState(() {
                      templeViewmodel.templeAdded = false;
                    });
                    templeViewmodel.message = "";
                    templeViewmodel.dispose();
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: templeViewmodel.message,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,

                    textColor: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.addTemple,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        );
      },
    );
  }
}
