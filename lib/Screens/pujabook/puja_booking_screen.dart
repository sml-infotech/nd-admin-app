import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
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
  late PujaBookingViewmodel viewmodel;

  String? selectedSlot;
  String? selectedCutOff;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  bool bookingCutoff = false;
  bool priestDakshina = false;
  bool specialReq = false;
  bool hideActive = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;

  Future<void> _pickImages() async {
    try {
      final images = await _picker.pickMultiImage(imageQuality: 80);
      if (images != null && images.isNotEmpty) {
        setState(() => _selectedImages = images);
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<PujaBookingViewmodel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _buildAppBar(),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Puja Name
                    CommonTextField(
                      hintText: StringConstant.addPuja,
                      labelText: StringConstant.addPuja,
                      controller: viewmodel.pujaName,
                      isFromPassword: false,
                    ),
                    const SizedBox(height: 12),

                    // Description
                    CommonTextField(
                      hintText: StringConstant.description,
                      labelText: StringConstant.description,
                      controller: viewmodel.description,
                      isFromPassword: false,
                    ),
                    const SizedBox(height: 12),

                    // Slot Dropdown
                    SlotDropdown(
                      selectedSlot: selectedSlot,
                      onChanged: (value) =>
                          setState(() => selectedSlot = value),
                    ),

                    // Cutoff Checkbox + Dropdown

                    // Date Pickers
                    Row(
                      children: [
                        DatePickerField(
                          title: StringConstant.fromDate,
                          selectedDate: selectedStartDate,
                          onDatePicked: (date) =>
                              setState(() => selectedStartDate = date),
                        ),
                        DatePickerField(
                          title: StringConstant.toDate,
                          selectedDate: selectedEndDate,
                          onDatePicked: (date) =>
                              setState(() => selectedEndDate = date),
                        ),
                      ],
                    ),

                    // Time Pickers
                    TimePickerRow(
                      fromTime: fromTime,
                      toTime: toTime,
                      onFromPicked: (t) => setState(() => fromTime = t),
                      onToPicked: (t) => setState(() => toTime = t),
                    ),

                    const SizedBox(height: 10),
                    CommonTextField(
                      hintText: StringConstant.enterPuja,
                      labelText: StringConstant.duration,
                      controller: viewmodel.duration,
                      isFromPassword: false,
                    ),
                    const SizedBox(height: 10),
                    CommonTextField(
                      hintText: StringConstant.cost,
                      labelText: StringConstant.fees,
                      controller: viewmodel.fee,
                      isFromPassword: false,
                    ),
                    const SizedBox(height: 10),
                    CommonTextField(
                      hintText: StringConstant.maxDevote,
                      labelText: StringConstant.maxNoDevote,
                      controller: viewmodel.maxDevotees,
                      isFromPassword: false,
                    ),

                    // Upload Image Box
                    UploadImageBox(onTap: _pickImages),
                    const SizedBox(height: 10),

                    if (_selectedImages != null && _selectedImages!.isNotEmpty)
                      Padding(padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 0),child: 
                      
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages!.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return 
                            
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedImages![index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      )),

                    Row(
                      children: [
                        Expanded(
                          child: CheckBoxRow(
                            label: StringConstant.cutOffText,
                            value: bookingCutoff,
                            onChanged: (v) =>
                                setState(() => bookingCutoff = v!),
                          ),
                        ),
                        // Expanded(
                        //   child: IgnorePointer(
                        //     ignoring: !bookingCutoff,
                        //     child: Opacity(
                        //       opacity: bookingCutoff ? 1 : 0.5,
                        //       child: CutOffDropDown(
                        //         selectedCutOff: selectedCutOff,
                        //         onChanged: (v) =>
                        //             setState(() => selectedCutOff = v),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    CheckBoxRow(
                      label: StringConstant.priestText,
                      value: priestDakshina,
                      onChanged: (v) => setState(() => priestDakshina = v!),
                    ),
                    CheckBoxRow(
                      label: StringConstant.specialReq,
                      value: specialReq,
                      onChanged: (v) => setState(() => specialReq = v!),
                    ),
                    ActiveFlagSwitch(
                      value: hideActive,
                      onChanged: (v) => setState(() => hideActive = v),
                    ),

              
                  ],
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
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
    );
  }


  Widget _resetButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 0),
        child: ElevatedButton(
          onPressed: () async {               
                }
           ,
          style: ElevatedButton.styleFrom(
            backgroundColor:  ColorConstant.buttonColor
              ,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            StringConstant.reset,
            style: AppTextStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}

// -------------------------
// Dropdowns & Pickers
// -------------------------

class SlotDropdown extends StatelessWidget {
  final String? selectedSlot;
  final ValueChanged<String?> onChanged;

  const SlotDropdown({super.key, this.selectedSlot, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringConstant.slot, style: AppTextStyles.editTempleTitleStyle),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: selectedSlot,
            hint: Text(
              StringConstant.selectSlot,
              style: TextStyle(fontFamily: font, color: Colors.grey),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              DropdownMenuItem(
                value: "Daily",
                child: Text("Daily", style: TextStyle(fontFamily: font)),
              ),
              DropdownMenuItem(
                value: "Festival days",
                child: Text(
                  "Festival days",
                  style: TextStyle(fontFamily: font),
                ),
              ),
              DropdownMenuItem(
                value: "Special Occasion",
                child: Text(
                  "Special Occasion",
                  style: TextStyle(fontFamily: font),
                ),
              ),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class CutOffDropDown extends StatelessWidget {
  final String? selectedCutOff;
  final ValueChanged<String?> onChanged;

  const CutOffDropDown({
    super.key,
    this.selectedCutOff,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringConstant.slot, style: AppTextStyles.editTempleTitleStyle),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: selectedCutOff,
            hint: Text(
              StringConstant.selectSlot,
              style: TextStyle(fontFamily: font, color: Colors.grey),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              DropdownMenuItem(
                value: "1",
                child: Text("1", style: TextStyle(fontFamily: font)),
              ),
              DropdownMenuItem(
                value: "2",
                child: Text("2", style: TextStyle(fontFamily: font)),
              ),
              DropdownMenuItem(
                value: "3",
                child: Text("3", style: TextStyle(fontFamily: font)),
              ),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// -------------------------
// Date & Time Pickers
// -------------------------

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDatePicked;
  final String title;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDatePicked,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) onDatePicked(picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? title
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: TextStyle(
                        fontFamily: font,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Image.asset(ImageStrings.calendar, height: 22),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimePickerRow extends StatelessWidget {
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final ValueChanged<TimeOfDay> onFromPicked;
  final ValueChanged<TimeOfDay> onToPicked;

  const TimePickerRow({
    super.key,
    required this.fromTime,
    required this.toTime,
    required this.onFromPicked,
    required this.onToPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildPicker(
              context,
              StringConstant.fromTime,
              fromTime,
              onFromPicked,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPicker(
              context,
              StringConstant.toTime,
              toTime,
              onToPicked,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(
    BuildContext context,
    String label,
    TimeOfDay? time,
    ValueChanged<TimeOfDay> onPick,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time == null ? label : time.format(context),
              style: TextStyle(
                fontFamily: font,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// -------------------------
// Upload Image Box
// -------------------------

class UploadImageBox extends StatelessWidget {
  final VoidCallback onTap;

  const UploadImageBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringConstant.uploadText,
            style: AppTextStyles.editTempleTitleStyle,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Image.asset(ImageStrings.uploadImg),
                  const SizedBox(height: 8),
                  Text(
                    StringConstant.uploadImageSeva,
                    style: TextStyle(fontFamily: font, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------
// Checkboxes & Switch
// -------------------------

class CheckBoxRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CheckBoxRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: ColorConstant.buttonColor,
        ),
        Expanded(child: Text(label, style: AppTextStyles.templeContactStyle)),
      ],
    );
  }
}

class ActiveFlagSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ActiveFlagSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Hide Active Flag", style: AppTextStyles.editTempleTitleStyle),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ColorConstant.buttonColor,
          ),
        ],
      ),
    );
  }
}
