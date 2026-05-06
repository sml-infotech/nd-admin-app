import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Common/time_picker.dart';
import 'package:nammadaiva_dashboard/Screens/create_event/create_event_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/date_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart' show ColorConstant;
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';
import 'package:provider/provider.dart';

class CreateEventKn extends StatefulWidget {
  final EventItem? event;
  const CreateEventKn({super.key, required this.event});

  @override
  State<CreateEventKn> createState() => _CreateEventKnState();
}

class _CreateEventKnState extends State<CreateEventKn> {
  late CreateEventViewmodel viewmodel;
  @override
  void initState() {
    super.initState();
    
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
                            eventNameTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            descriptionTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            locationTextField(),
                            SizedBox(height: screenHeight * 0.02),
                            contactNameTextField(),
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
      hintText: AppLocalizations.of(context)!.event,
      labelText: AppLocalizations.of(context)!.event,
      isFromPassword: false,
      controller: viewmodel.knEventNameController,
    );
  }

  Widget descriptionTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.description,
      labelText: AppLocalizations.of(context)!.description,
      isFromDescription: true,
      controller: viewmodel.knDescriptionContoller,
      isFromPassword: false,
    );
  }

  Widget locationTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.location,
      labelText: AppLocalizations.of(context)!.location,
      isFromPassword: false,
      controller: viewmodel.knLocationController,
    );
  }

  Widget contactNameTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.contactName,
      labelText: AppLocalizations.of(context)!.contactName,
      isFromPassword: false,
      isFromPhone: false,
      controller: viewmodel.knContactNameController,
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
                final isValid = await viewmodel.validateKNnEvent();
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
                    ? AppLocalizations.of(context)!.createEvent
                    : AppLocalizations.of(context)!.updateEvent,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
