import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Common/time_picker.dart';
import 'package:nammadaiva_dashboard/Screens/festivals/create_festival_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/date_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/image_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/festival_argument.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart'
    show TimeSlot;
import 'package:provider/provider.dart';

import '../../Utills/string_routes.dart';
import '../addtemple/temple_input_widget.dart';

class CreateFestival extends StatefulWidget {
  final FestivalArgument? arguments;
  const CreateFestival({super.key, this.arguments});

  @override
  State<CreateFestival> createState() => _CreateFestivalState();
}

class _CreateFestivalState extends State<CreateFestival> {
  late CreateFestivalViewmodel viewmodel;
  final ImagePicker _picker = ImagePicker();
  bool _isPrefilled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    viewmodel = Provider.of<CreateFestivalViewmodel>(context);

    if (widget.arguments != null && !_isPrefilled) {
      _prefillData(widget.arguments!);
      _isPrefilled = true;
    }
  }

  void _prefillData(FestivalArgument args) {
    viewmodel.eventController.text = args.name ?? "";
    viewmodel.descriptionContoller.text = args.description ?? "";
    if (args.translation?.isNotEmpty == true) {
      viewmodel.knEventNameController.text = args.translation?.first.name ?? "";
      viewmodel.knDescriptionContoller.text =
          args.translation?.first.description ?? "";
      viewmodel.deitiesKn = args.translation?.first.deities ?? [];
    }

    viewmodel.deities = args.deities;

    viewmodel.selectedStartDate = args.startDate != null
        ? DateTime.parse(args.startDate!)
        : null;
    viewmodel.selectedEndDate = args.endDate != null
        ? DateTime.parse(args.endDate!)
        : null;

    if (args.startTime != null && args.endTime != null) {
      viewmodel.timeSlots = [
        TimeSlot(fromTime: args.startTime!, toTime: args.endTime!),
      ];
    }

    viewmodel.uploadedImageUrls = List<String>.from(args.imageUrls ?? []);

    viewmodel.notifyListeners();
  }

  String _formatForDisplay(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsed);
    } catch (_) {
      return time;
    }
  }

  @override
  void dispose() {
    super.dispose();
    viewmodel.reset();
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<CreateFestivalViewmodel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

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
                      padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),

                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.02),

                            eventNameTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            descriptionTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TempleInputWidget(
                                list: viewmodel.deities,
                                onAdd: (String p1) {
                                  viewmodel.addDeity(p1);
                                },
                                onRemove: (int p1) {
                                  viewmodel.removeDeity(p1);
                                },
                                hintText: "Add Deity",
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            dateWidget(),
                            timePickerWidget(),
                            SizedBox(height: screenHeight * 0.02),
                            _buildImagePicker(),
                            SizedBox(height: screenHeight * 0.01),
                            isActiveCheckbox(),
                            SizedBox(height: screenHeight * 0.10),
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

        eventButton(),
        if (viewmodel.isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.buttonColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget isActiveCheckbox() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            activeColor: ColorConstant.buttonColor,
            value: viewmodel.isActive,
            onChanged: (value) {
              setState(() {
                viewmodel.isActive = value ?? false;
              });
            },
          ),
          Text(
            "Active or Inactive",
            style: TextStyle(
              fontFamily: font,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    final uploadedCount = viewmodel.uploadedImageUrls.length;

    final allImages = [
      ...viewmodel.uploadedImageUrls,
      ...viewmodel.selectedImages.map((e) => e.path),
    ];

    return MultiImagePickerSection(
      imagePaths: allImages,
      onAddImages: _pickImages,
      onRemoveImage: (index) async {
        if (index >= uploadedCount) {
          final localIndex = index - uploadedCount;
          viewmodel.removeImage(localIndex);
        } else {
          await viewmodel.removeS3(viewmodel.uploadedImageUrls[index]);
          viewmodel.uploadedImageUrls.removeAt(index);
          viewmodel.notifyListeners();
        }
      },
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final imagePaths = pickedFiles.map((e) => e.path).toList();
      viewmodel.addImages(imagePaths);
    }
  }

  Widget timePickerWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleTimePicker(
        initialValue: viewmodel.timeSlots.isNotEmpty
            ? viewmodel.timeSlots.first
            : null,
        onChanged: (selectedSlot) {
          setState(() {
            viewmodel.timeSlots = [selectedSlot];
          });
        },
        startDate: viewmodel.selectedStartDate,
        endDate: viewmodel.selectedEndDate,
      ),
    );
  }

  Widget dateWidget() {
    return Row(
      children: [
        DatePickerField(
          title: AppLocalizations.of(context)!.fromDate,
          selectedDate: viewmodel.selectedStartDate,
          onDatePicked: (date) => setState(() {
            viewmodel.selectedStartDate = date;
            viewmodel.selectedEndDate = null;
          }),
        ),
        DatePickerField(
          title: AppLocalizations.of(context)!.toDate,
          selectedDate: viewmodel.selectedEndDate,
          fromDate: viewmodel.selectedStartDate,
          onDatePicked: (date) => setState(() {
            viewmodel.selectedEndDate = date;
          }),
        ),
      ],
    );
  }

  Widget eventNameTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.festivalname,
      labelText: AppLocalizations.of(context)!.festivalname,
      isFromPassword: false,
      controller: viewmodel.eventController,
    );
  }

  Widget descriptionTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.description,
      labelText: AppLocalizations.of(context)!.description,
      isFromDescription: true,
      controller: viewmodel.descriptionContoller,
      isFromPassword: false,
    );
  }

  Widget locationTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.location,
      labelText: AppLocalizations.of(context)!.location,
      isFromPassword: false,
      controller: viewmodel.locationController,
    );
  }

  Widget contactNameTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.contactName,
      labelText: AppLocalizations.of(context)!.contactName,
      isFromPassword: false,
      isFromPhone: false,
      controller: viewmodel.contactNameController,
    );
  }

  Widget contactNumberTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.phone,
      labelText: AppLocalizations.of(context)!.phone,
      isFromPassword: false,
      isFromPhone: true,
      controller: viewmodel.contactNumberController,
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
          widget.arguments != null
              ? AppLocalizations.of(context)!.updateFestival
              : AppLocalizations.of(context)!.addfestival,

          style: AppTextStyles.appBarTitleStyle,
        ),
        SizedBox(width: 48),
        const Spacer(),
      ],
    );
  }

  Widget eventButton() {
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
                final isValid = await viewmodel.validateFestival(false);
                if (!isValid) {
                  Fluttertoast.showToast(msg: viewmodel.message ?? "");
                  return;
                }
                Navigator.pushNamed(
                  context,
                  StringsRoute.createFestivalKn,
                  arguments: widget.arguments,
                );
                // if (widget.arguments != null) {
                //   await viewmodel.updateFestival(widget.arguments!.festivalId!);
                // } else {
                //   await viewmodel.createFestival();
                // }
                //
                // if (viewmodel.eventUpdated || viewmodel.eventCreated) {
                //   Fluttertoast.showToast(msg: viewmodel.message ?? "");
                //   Navigator.pop(context);
                //   viewmodel.reset();
                //   viewmodel.eventCreated = false;
                //   viewmodel.eventUpdated = false;
                // } else {
                //   Fluttertoast.showToast(msg: viewmodel.message ?? "");
                // }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.next,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
