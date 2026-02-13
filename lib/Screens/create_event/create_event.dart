import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Common/time_picker.dart';
import 'package:nammadaiva_dashboard/Screens/create_event/create_event_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/date_picker.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/image_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart' show ColorConstant;
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';
import 'package:provider/provider.dart';

import '../../Utills/string_routes.dart';
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
        if (widget.event?.translations.isNotEmpty == true) {
          viewmodel.knLocationController.text =
              widget.event!.translations.first.location;
          viewmodel.knContactNameController.text =
              widget.event!.translations.first.contactName;
          viewmodel.knEventNameController.text =
              widget.event!.translations.first.name;
          viewmodel.knDescriptionContoller.text =
              widget.event!.translations.first.description;
        }
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

  Widget _buildTempleDropdown() {
  return CommonDropdownField(
    // ✅ Pass the viewmodel as the listener
    refreshListenable: viewmodel, 
    hintText: AppLocalizations.of(context)!.optional_temple,
    labelText: AppLocalizations.of(context)!.optional_temple,
    items: viewmodel.templeData.map((t) => t.name).toList(),
    selectedValue: viewmodel.selectedTemple?.name,
    paddingSize: 16,
    // ✅ Pass the actual boolean loading state
    isLoadingMore: viewmodel.isFetchingNextPage, 
    onLoadMore: () {
      if (!viewmodel.isFetchingNextPage && viewmodel.hasNextPage) {
        viewmodel.getTemples(reset: false);
      }
    },
    onChanged: (value) {
      if (value == null) return;
      final selectedTemple = viewmodel.templeData.firstWhere(
        (t) => t.name == value,
      );
      // Logic to update selection
      viewmodel.setSelectedTemple(selectedTemple);
    },
  );
}

  Widget eventNameTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.event,
      labelText: AppLocalizations.of(context)!.event,
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
          widget.event?.id == null
              ? AppLocalizations.of(context)!.createEvent
              : AppLocalizations.of(context)!.updateEvent,
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
                final isValid = await viewmodel.validateEvent();
                if (!isValid) {
                  Fluttertoast.showToast(msg: viewmodel.message ?? "");
                  return;
                }
                Navigator.pushNamed(
                  context,
                  StringsRoute.createEventInKn,
                  arguments: widget.event,
                );
                // if (widget.event?.id != null) {
                //   await viewmodel.updateEvent(widget.event!.id);
                // } else {
                //   await viewmodel.createEvent();
                // }
                // if (viewmodel.eventUpdated || viewmodel.eventCreated) {
                //   Fluttertoast.showToast(msg: viewmodel.message ?? "");
                //   Navigator.pop(context);
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
