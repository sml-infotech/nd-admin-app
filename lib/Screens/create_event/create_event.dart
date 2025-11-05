import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Common/time_picker.dart';
import 'package:nammadaiva_dashboard/Screens/create_event/create_event_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/date_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/time_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart'
    show ColorConstant, StringConstant;
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';
import 'package:provider/provider.dart';

import '../../model/login_model/createpuja/create_pujamodel.dart';

class CreateEvent extends StatefulWidget {
  final EventItem? event;
  const CreateEvent({super.key, required this.event});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  late CreateEventViewmodel viewmodel;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewmodel.getTemples(reset: true);

      if (widget.event != null) {
        final selectedTempleId = widget.event!.templeId;
        final selectedTemple = viewmodel.templeData.firstWhere(
          (temple) => temple.id == selectedTempleId,
          orElse: () => viewmodel.templeData.first,
        );
        if (widget.event!.startTime != null && widget.event!.endTime != null) {
          viewmodel.timeSlots = [
            TimeSlot(
              fromTime: _formatForDisplay(widget.event!.startTime!),
              toTime: _formatForDisplay(widget.event!.endTime!),
            ),
          ];
        }

        viewmodel.selectedTemple = selectedTemple;
        viewmodel.selectedTempleId = selectedTemple.id;
        viewmodel.eventController.text = widget.event!.name;
        viewmodel.descriptionContoller.text = widget.event!.description!;
        viewmodel.locationController.text = widget.event!.location!;
        viewmodel.contactNameController.text = widget.event!.contactName!;
        viewmodel.contactNumberController.text = widget.event!.contactPhone!;
        if (widget.event!.startDate != null) {
          viewmodel.selectedStartDate = DateTime.parse(
            widget.event!.startDate!,
          );
        }
        if (widget.event!.endDate != null) {
          viewmodel.selectedEndDate = DateTime.parse(widget.event!.endDate!);
        }

        if (widget.event!.images != null) {
         
          viewmodel.uploadedImageUrls = widget.event!.images!;
        }
      }
    });
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
    viewmodel = Provider.of<CreateEventViewmodel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorConstant.buttonColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
          final localIndex = index - uploadedCount;
          viewmodel.removeImage(localIndex);
        } else {
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
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          widget.event?.id == null
              ? StringConstant.createEvent
              : StringConstant.updateEvent,
          style: AppTextStyles.appBarTitleStyle,
        ),
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
                if (widget.event?.id != null) {
                  await viewmodel.updateEvent(widget.event!.id);
                } else {
                  await viewmodel.createEvent();
                }
                if (viewmodel.eventUpdated || viewmodel.eventCreated) {
                  Fluttertoast.showToast(msg: viewmodel.message ?? "");
                  Navigator.pop(context);
                  viewmodel.eventCreated = false;
                  viewmodel.eventUpdated = false;
                } else {
                  Fluttertoast.showToast(msg: viewmodel.message ?? "");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                widget.event?.id == null
                    ? StringConstant.createEvent
                    : StringConstant.updateEvent,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
