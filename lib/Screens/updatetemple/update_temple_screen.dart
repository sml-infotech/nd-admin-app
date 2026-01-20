import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/temple_input_widget.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/temple_details_arguments.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TempleUpdateScreen extends StatefulWidget {
  final TempleDetailsArguments arguments;
  const TempleUpdateScreen({super.key, required this.arguments});

  @override
  State<TempleUpdateScreen> createState() => _TempleUpdateScreenState();
}

class _TempleUpdateScreenState extends State<TempleUpdateScreen> {
  late UpdateTempleViewmodel viewModel;
  bool _isDataLoaded = false; // ensure data sets only once
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      viewModel = Provider.of<UpdateTempleViewmodel>(context, listen: false);
      _setInitialData();
      _isDataLoaded = true;
    }
  }

  void _setInitialData() {
    viewModel.originalTempleData = widget.arguments;

    viewModel.templeName.text = widget.arguments.name ?? '';
    viewModel.templeLocation.text = widget.arguments.address ?? '';
    viewModel.templeDescription.text = widget.arguments.description ?? '';
    viewModel.templePhoneNumber.text = widget.arguments.phoneNumber ?? '';
    viewModel.templeEmail.text = widget.arguments.email ?? '';
    viewModel.templeArchitecture.text = widget.arguments.architecture ?? '';
    viewModel.templeDeities.text = widget.arguments.deities.join(', ');
    viewModel.templeCity.text = widget.arguments.city ?? "";
    viewModel.templeState.text = widget.arguments.state ?? "";
    viewModel.templePincode.text = widget.arguments.pincode ?? "";
    viewModel.images = List<String>.from(widget.arguments.images ?? []);

    viewModel.prefilledTemples = List<String>.from(widget.arguments.deities);
    print(
      "Prefilled Deities: ${widget.arguments.translations.firstWhere((t) => t.languageCode == 'en', orElse: () => widget.arguments.translations.first).deities}",
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    viewModel = Provider.of<UpdateTempleViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaDetailAppBar(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
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
                      padding: const EdgeInsets.all(0.0),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            titleTextWidget(
                              AppLocalizations.of(context)!.templeName,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeName,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.templelocation,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeLocation,
                            ),
                            titleTextWidget(AppLocalizations.of(context)!.city),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeCity,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.state,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeState,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.pincode,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              isFromPhone: true,
                              controller: viewModel.templePincode,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.templedescription,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeDescription,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.templephonenumber,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              isFromPhone: true,
                              controller: viewModel.templePhoneNumber,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.templeemail,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeEmail,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.deitiestemple,
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TempleInputWidget(
                                list:
                                    viewModel.prefilledTemples, // English list
                                onAdd: (val) => viewModel.addTemple(val),
                                onRemove: (idx) => viewModel.removeTemple(idx),
                                hintText: "Add Deity",
                              ),
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.templearchitecture,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeArchitecture,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.editImages,
                            ),
                            const SizedBox(height: 8),
                            UpdateImagepickerWidget(),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
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

  Widget _buildImagePicker() {
    final uploadedCount = viewModel.uploadedImageUrls.length;

    final allImages = [
      ...viewModel.uploadedImageUrls,
      ...viewModel.selectedImages.map((e) => e.path),
    ];

    return MultiImagePickerSection(
      imagePaths: allImages,
      onAddImages: _pickImages,
      onRemoveImage: (index) {
        if (index >= uploadedCount) {
          // Removing from selectedImages
          final localIndex = index - uploadedCount;
          viewModel.removeImage(localIndex);
        } else {
          // Removing from uploadedImageUrls
          viewModel.uploadedImageUrls.removeAt(index);
          viewModel.notifyListeners();
        }
      },
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final imagePaths = pickedFiles.map((e) => e.path).toList();
      viewModel.addImages(imagePaths);
    }
  }

  Widget nammaDaivaDetailAppBar() {
    return Center(
      child: Row(
        children: [
          IconButton(
            icon: Image.asset(ImageStrings.backbutton),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.templeDetail,
            style: AppTextStyles.appBarTitleStyle,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus();
              if (viewModel.validateUpdateTemple()) {
                Navigator.pushNamed(
                  context,
                  StringsRoute.updateTempleKn,
                  arguments: widget.arguments,
                );
              } else {
                Fluttertoast.showToast(msg: viewModel.message);
              }
            },
            child: Text(
              AppLocalizations.of(context)!.save,
              style: AppTextStyles.appBarTitleStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget titleTextWidget(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(title, style: AppTextStyles.editTempleTitleStyle),
    );
  }
}
