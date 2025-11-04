import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/create_event/create_event_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/date_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/time_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart'
    show ColorConstant, StringConstant;
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  late CreateEventViewmodel viewmodel;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<CreateEventViewmodel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async {
        await viewmodel.getTemples(reset: true);
      },

      child: Stack(
        children: [
          Scaffold(
            backgroundColor: ColorConstant.buttonColor,
            appBar: AppBar(
              backgroundColor: ColorConstant.buttonColor,
              elevation: 0,
              title: nammaDaivaAppBar(),
            ),
            body: Column(
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
                            _buildTempleDropdown(),
                            SizedBox(height: screenHeight * 0.02),
                            eventNameTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            descriptionTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            locationTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            contactNameTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            contactNumberTextField(),
                            SizedBox(height: 8),
                            dateWidget(),
                            timePickerWidget(),
                            SizedBox(height: screenHeight * 0.02),
                            _buildImagePicker(),
                            SizedBox(height: screenHeight * 0.06),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

          eventButton(),
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
      onRemoveImage: (index) {
        if (index >= uploadedCount) {
          // Removing from selectedImages
          final localIndex = index - uploadedCount;
          viewmodel.removeImage(localIndex);
        } else {
          // Removing from uploadedImageUrls
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
      padding: EdgeInsetsGeometry.fromLTRB(16, 10, 16, 0),
      child: TimeSlotSelector(
        key: ValueKey(viewmodel.timeSlots.hashCode),
        initialSlots: viewmodel.timeSlots,
        onChanged: (updatedSlots) {
          setState(() => viewmodel.timeSlots = updatedSlots);
        },
      ),
    );
  }

  Widget dateWidget() {
    return Row(
      children: [
        DatePickerField(
          title: StringConstant.fromDate,
          selectedDate: viewmodel.selectedStartDate,
          onDatePicked: (date) => setState(() {
            viewmodel.selectedStartDate = date;
            viewmodel.selectedEndDate = null;
          }),
        ),
        DatePickerField(
          title: StringConstant.toDate,
          selectedDate: viewmodel.selectedEndDate,
          fromDate: viewmodel.selectedStartDate,
          onDatePicked: (date) => setState(() {
            viewmodel.selectedEndDate = date;
          }),
        ),
      ],
    );
  }

  Widget _buildTempleDropdown() {
    return CommonDropdownField(
      hintText: StringConstant.temple,
      labelText: StringConstant.temple,
      items: viewmodel.templeData.map((t) => t.name).toList(),
      selectedValue: viewmodel.selectedTemple?.name,
      paddingSize: 16,
      onChanged: (value) {
        if (value == null) return;

        final selectedTemple = viewmodel.templeData.firstWhere(
          (t) => t.name == value,
        );

        setState(() {
          viewmodel.selectedTempleId = selectedTemple.id;
          viewmodel.setSelectedTemple(selectedTemple);
          viewmodel.notifyListeners();
        });
      },
    );
  }

  Widget eventNameTextField() {
    return CommonTextField(
      hintText: StringConstant.event,
      labelText: StringConstant.event,
      isFromPassword: false,
      controller: viewmodel.eventController,
    );
  }

  Widget descriptionTextField() {
    return CommonTextField(
      hintText: StringConstant.description,
      labelText: StringConstant.description,
      isFromDescription: true,
      controller: viewmodel.descriptionContoller,
      isFromPassword: false,
    );
  }

  Widget locationTextField() {
    return CommonTextField(
      hintText: StringConstant.location,
      labelText: StringConstant.location,
      isFromPassword: false,
      controller: viewmodel.locationController,
    );
  }

  Widget contactNameTextField() {
    return CommonTextField(
      hintText: StringConstant.contactName,
      labelText: StringConstant.contactName,
      isFromPassword: false,
      isFromPhone: false,
      controller: viewmodel.contactNameController,
    );
  }

  Widget contactNumberTextField() {
    return CommonTextField(
      hintText: StringConstant.phone,
      labelText: StringConstant.phone,
      isFromPassword: false,
      isFromPhone: true,
      controller: viewmodel.contactNumberController,
    );
  }

  Widget nammaDaivaAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(StringConstant.createEvent, style: AppTextStyles.appBarTitleStyle),
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
                final isValid = await viewmodel.validateEvent(false);
                if (!isValid) {
                  Fluttertoast.showToast(msg: viewmodel.message ?? "");
                  return;
                }

             await viewmodel.createEvent();
                if (viewmodel.eventCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event created successfully')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewmodel.message)),
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
                StringConstant.createEvent,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
