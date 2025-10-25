import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:provider/provider.dart';

class PujaBookingScreen extends StatefulWidget {
  const PujaBookingScreen({super.key});

  @override
  State<PujaBookingScreen> createState() => _PujaBookingScreenState();
}

class _PujaBookingScreenState extends State<PujaBookingScreen> {
  late PujaBookingViewmodel viewmodel;

  String? selectedSlot;
  DateTime? selectedDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  bool bookingCutoff = false;
  bool priestDakshina = false;
  bool specialReq = false;
  bool hideActive = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    viewmodel = Provider.of<PujaBookingViewmodel>(context);

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
                    CommonTextField(
                      hintText: StringConstant.addPuja,
                      labelText: StringConstant.addPuja,
                      controller: viewmodel.pujaName,
                      isFromPassword: false,
                    ),
                    const SizedBox(height: 12),
                    CommonTextField(
                      hintText: StringConstant.description,
                      labelText: StringConstant.description,
                      controller: viewmodel.description,
                      isFromPassword: false,
                    ),
                    SlotDropdown(
                      selectedSlot: selectedSlot,
                      onChanged: (value) => setState(() => selectedSlot = value),
                    ),
                    DatePickerField(
                      selectedDate: selectedDate,
                      onDatePicked: (date) => setState(() => selectedDate = date),
                    ),
                    TimePickerRow(
                      fromTime: fromTime,
                      toTime: toTime,
                      onFromPicked: (t) => setState(() => fromTime = t),
                      onToPicked: (t) => setState(() => toTime = t),
                    ),
                    SizedBox(height: 10,),
                    CommonTextField(
                      hintText: StringConstant.enterPuja,
                      labelText: StringConstant.duration,
                      controller: viewmodel.duration,
                      isFromPassword: false,
                    ),
                                        SizedBox(height: 10,),

                    CommonTextField(
                      hintText: StringConstant.cost,
                      labelText: StringConstant.fees,
                      controller: viewmodel.fee,
                      isFromPassword: false,
                    ),
                    SizedBox(height: 10,),
                    CommonTextField(
                      hintText: StringConstant.maxDevote,
                      labelText: StringConstant.maxNoDevote,
                      controller: viewmodel.maxDevotees,
                      isFromPassword: false,
                    ),
                    UploadImageBox(onTap: () {}),
                    CheckBoxRow(
                      label:StringConstant.cutOffText ,
                      value: bookingCutoff,
                      onChanged: (v) => setState(() => bookingCutoff = v!),
                    ),
                    CheckBoxRow(
                      label:StringConstant.priestText ,
                      value: priestDakshina,
                      onChanged: (v) => setState(() => priestDakshina = v!),
                    ),
                    CheckBoxRow(
                      label:
                        StringConstant.specialReq  ,
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
}
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
            hint: Text(StringConstant.selectSlot,style: TextStyle(fontFamily: font),),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(value: "Daily", child: Text("Daily")),
              DropdownMenuItem(
                  value: "Festival days", child: Text("Festival days")),
              DropdownMenuItem(
                  value: "Special Occasion", child: Text("Special Occasion")),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDatePicked;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringConstant.date, style: AppTextStyles.editTempleTitleStyle),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? "Select Date"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    style: TextStyle(fontFamily: font),
                  ),
                  Image.asset(ImageStrings.calendar, height: 22),
                ],
              ),
            ),
          ),
        ],
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
            child: _buildPicker(context, "From time", fromTime, onFromPicked),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPicker(context, "To time", toTime, onToPicked),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(BuildContext context, String label, TimeOfDay? time,
      ValueChanged<TimeOfDay> onPick) {
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
              style: TextStyle(fontFamily: font),
            ),
            const Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

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
          Text(StringConstant.uploadText,
              style: AppTextStyles.editTempleTitleStyle),
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
                  const Icon(Icons.upload_rounded,
                      size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    StringConstant.uploadImageSeva,
                    style: AppTextStyles.templeContactStyle,
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

  const ActiveFlagSwitch({super.key, required this.value, required this.onChanged});

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