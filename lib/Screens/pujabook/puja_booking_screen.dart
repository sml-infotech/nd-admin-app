import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/date_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/days_selector.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_add_deities.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_checkbox.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/time_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class PujaBookingScreen extends StatefulWidget {
  const PujaBookingScreen({super.key});

  @override
  State<PujaBookingScreen> createState() => _PujaBookingScreenState();
}

class _PujaBookingScreenState extends State<PujaBookingScreen> {
  late CreatePujaViewmodel viewmodel;
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

 Future<void> _pickImages( ) async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final imagePaths = pickedFiles.map((e) => e.path).toList();
      viewmodel.addImages(imagePaths);

    }
  }


  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<CreatePujaViewmodel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async => await viewmodel.getTemples(reset: true),
      child: Scaffold(
        backgroundColor: ColorConstant.buttonColor,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            _buildTempleDropdown(),
                            const SizedBox(height: 15),
                            _buildDeitiesDropdown(),
                            const SizedBox(height: 18),
                            _buildPujaDetails(),
                            const SizedBox(height: 18),
                            _buildSlotSection(),
                            const SizedBox(height: 10),
                            _buildDurationAndFee(),
                            const SizedBox(height: 10),
                            _buildImagePicker(),
                            const SizedBox(height: 10),
                            _buildCheckboxSection(),
                            const SizedBox(height: 10),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildResetButton(),
             if (viewmodel.isLoading)
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: ColorConstant.buttonColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: Image.asset(ImageStrings.backbutton),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(StringConstant.addPuja, style: AppTextStyles.appBarTitleStyle),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTempleDropdown() {
    return CommonDropdownField(
      hintText: StringConstant.temple,
      labelText: StringConstant.temple,
      items: viewmodel.templeData.map((t) => t.name).toList(),
      paddingSize: 16,
      onChanged: (value) {
        if (value == null) return;
        final selectedTemple = viewmodel.templeData.firstWhere(
          (t) => t.name == value,
        );
        setState(() {
          viewmodel.deities.clear();
          viewmodel.selectedDeityId = selectedTemple.id;
          viewmodel.setSelectedTemple(selectedTemple);
        });
      },
    );
  }

  Widget _buildDeitiesDropdown() {
    return DeitiesDropdown(
      items: viewmodel.deitiesList,
      selectedItems: viewmodel.deities,
      onSelectionChanged: (selected) =>
          setState(() => viewmodel.deities = selected),
    );
  }

  Widget _buildPujaDetails() {
    return Column(
      children: [
        CommonTextField(
          hintText: StringConstant.addPuja,
          labelText: StringConstant.addPuja,
          controller: viewmodel.pujaName,
          isFromPassword: false,
        ),
        const SizedBox(height: 14),
        CommonTextField(
          hintText: StringConstant.description,
          labelText: StringConstant.description,
          controller: viewmodel.description,
          isFromDescription: true,
          isFromPassword: false,
        ),
      ],
    );
  }

  Widget _buildSlotSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            StringConstant.slot,
            style: AppTextStyles.editTempleTitleStyle,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: DaysSelector(
            initialDays: viewmodel.selectedDays,
            onChanged: (value) =>
                setState(() => viewmodel.selectedDays = value),
          ),
        ),
       Row(
  children: [
    DatePickerField(
      title: "From Date",
      selectedDate: viewmodel.selectedStartDate,
      onDatePicked: (date) => setState(() {
        viewmodel.selectedStartDate = date;
        viewmodel.selectedEndDate = null; 
      }),
    ),
    DatePickerField(
      title: "To Date",
      selectedDate: viewmodel.selectedEndDate,
      fromDate: viewmodel.selectedStartDate, 
      onDatePicked: (date) => setState(() {
        viewmodel.selectedEndDate = date;
      }),
    ),
  ],
),

        TimePickerRow(
          fromTime: viewmodel.fromTime,
          toTime: viewmodel.toTime,
          fromDate: viewmodel.selectedStartDate,
          toDate: viewmodel.selectedEndDate,
          onFromPicked: (t) => setState(() => viewmodel.fromTime = t),
          onToPicked: (t) => setState(() => viewmodel.toTime = t),
        ),
      ],
    );
  }

  Widget _buildDurationAndFee() {
    return Column(
      children: [
        const SizedBox(height: 10),
        CommonTextField(
          hintText: StringConstant.cost,
          labelText: StringConstant.fees,
          controller: viewmodel.fee,
          isFromPassword: false,
          isFromPhone: true,
        ),
        const SizedBox(height: 10),
        CommonTextField(
          hintText: StringConstant.maxDevote,
          labelText: StringConstant.maxNoDevote,
          controller: viewmodel.maxDevotees,
          isFromPassword: false,
          isFromPhone: true,
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
  final images = viewmodel.selectedImages ?? [];

  return MultiImagePickerSection(
    imagePaths: images.map((img) => img.path).toList(),
     onAddImages: () => _pickImages(),
              onRemoveImage: (index) => viewmodel.removeImage(index),
  );
}



  Widget _buildCheckboxSection() {
    return Column(
      children: [
        CheckBoxRow(
          label: StringConstant.cutOffText,
          value: viewmodel.bookingCutoff,
          onChanged: (v) => setState(() => viewmodel.bookingCutoff = v!),
        ),
        CheckBoxRow(
          label: StringConstant.specialReq,
          value: viewmodel.specialReq,
          onChanged: (v) => setState(() => viewmodel.specialReq = v!),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
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
  final isValid =await viewmodel.validateForm();
  if (!isValid) {
    Fluttertoast.showToast(msg: "Form is not valid!");
    return;
  }
  if (viewmodel.pujaCreated) {
    print("Puja successfully created! Resetting form...");
    Navigator.pop(context);
  } else {
    Fluttertoast.showToast(msg: "Puja creation failed. Try again.");
  }
}
,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                StringConstant.addPuja,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
