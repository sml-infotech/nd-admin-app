import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:provider/provider.dart';

import 'package:nammadaiva_dashboard/arguments/puja_arguments.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_viewmodel.dart';

import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/date_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/days_selector.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_add_deities.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_checkbox.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/time_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class PujaBookingScreen extends StatefulWidget {
  final PujaArguments? pujaArgumrnts;
  const PujaBookingScreen({super.key, this.pujaArgumrnts});

  @override
  State<PujaBookingScreen> createState() => _PujaBookingScreenState();
}

class _PujaBookingScreenState extends State<PujaBookingScreen> {
  late CreatePujaViewmodel viewmodel;
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isPrefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPrefilled) {
      viewmodel = Provider.of<CreatePujaViewmodel>(context, listen: false);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await viewmodel.getTemples(reset: true);
        await prefillData(); // ✅ Wait for temples before filling data
        setState(() {});
      });

      _isPrefilled = true;
    }
  }

  Future<void> prefillData() async {
    final args = widget.pujaArgumrnts;
    if (args == null || args.puja_id.isEmpty) return;

    viewmodel.pujaName.text = args.puja_name ?? "";
    viewmodel.description.text = args.description ?? "";
    viewmodel.maxDevotees.text = args.maximumNoOfDevotees?.toString() ?? "";
    viewmodel.fee.text = args.fee?.toString() ?? "";
    viewmodel.specialReq = args.allows_special_requirements ?? false;
    viewmodel.bookingCutoff = args.booking_cutoff_notice != null;

    if (args.sample_images != null && args.sample_images!.isNotEmpty) {
      viewmodel.uploadedImageUrls = List<String>.from(args.sample_images!);
    }

    if (args.from_date != null) {
      viewmodel.selectedStartDate = DateTime.tryParse(args.from_date!);
    }
    if (args.to_date != null) {
      viewmodel.selectedEndDate = DateTime.tryParse(args.to_date!);
    }

    if (args.days != null && args.days!.isNotEmpty) {
      for (final key in viewmodel.selectedDays.keys) {
        viewmodel.selectedDays[key] = args.days!.contains(key);
      }
    }

    // ✅ Prefill Temple and Deities
    if (args.templeId != null && args.templeId!.isNotEmpty) {
      final matchedTemple = viewmodel.templeData.firstWhere(
        (t) => t.id == args.templeId,
        orElse: () => Temple(
          id: '',
          name: '',
          address: '',
          city: '',
          state: '',
          pincode: '',
          architecture: '',
          phoneNumber: '',
          email: '',
          description: '',
          createdAt: '',
          updatedAt: '',
        ),
      );

      if (matchedTemple.id.isNotEmpty) {
        viewmodel.selectedTempleId = matchedTemple.id;
        viewmodel.setSelectedTemple(matchedTemple); // updates deitiesList
      }

      if (args.deities_name != null && args.deities_name!.isNotEmpty) {
        viewmodel.deities = List<String>.from(args.deities_name!);
      }
      print("?????>>>>>>?????${widget.pujaArgumrnts?.templeId}");
    }
  }

  @override
  void dispose() {
    viewmodel.resetForm();
    super.dispose();
  }

  Future<void> _pickImages() async {
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

    return Scaffold(
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
      selectedValue: viewmodel.selectedTemple?.name,
      paddingSize: 16,
      onChanged: (value) {
        if (value == null) return;
        final selectedTemple = viewmodel.templeData.firstWhere(
          (t) => t.name == value,
        );
        setState(() {
          viewmodel.deities.clear();
          viewmodel.selectedTempleId = selectedTemple.id; // ✅ fixed key name
          viewmodel.setSelectedTemple(selectedTemple); // updates deitiesList
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
          child: Text(StringConstant.slot, style: AppTextStyles.editTempleTitleStyle),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: DaysSelector(
            key: ValueKey(viewmodel.selectedDays.hashCode),
            initialDays: Map.from(viewmodel.selectedDays),
            onChanged: (value) => setState(() {
              viewmodel.selectedDays = Map.from(value);
            }),
          ),
        ),
        Row(
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
              title: StringConstant.toTime,
              selectedDate: viewmodel.selectedEndDate,
              fromDate: viewmodel.selectedStartDate,
              onDatePicked: (date) => setState(() {
                viewmodel.selectedEndDate = date;
              }),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: TimeSlotSelector(
            initialSlots: viewmodel.timeSlots,
            onChanged: (updatedSlots) {
              setState(() => viewmodel.timeSlots = updatedSlots);
            },
          ),
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
    final allImages = [
      ...viewmodel.uploadedImageUrls,
      ...viewmodel.selectedImages.map((e) => e.path),
    ];

    return MultiImagePickerSection(
      imagePaths: allImages,
      onAddImages: _pickImages,
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
                final isValid = await viewmodel.validateForm();
                if (!isValid) {
                  Fluttertoast.showToast(msg: "Form is not valid!");
                  return;
                }
                if (viewmodel.pujaCreated) {
                  Fluttertoast.showToast(msg: "Puja created successfully!");
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(
                    msg: "Puja creation failed. Try again.",
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
