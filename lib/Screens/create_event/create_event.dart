import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/create_event/create_event_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/date_picker.dart';
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
                      padding: const EdgeInsets.all(16.0),

                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
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
}
