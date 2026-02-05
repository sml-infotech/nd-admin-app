import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Common/benefits.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/temple_input_widget.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:provider/provider.dart';
import 'package:nammadaiva_dashboard/arguments/puja_arguments.dart';
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
import '../../model/login_model/createpuja/create_pujamodel.dart';

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
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.pujaArgumrnts?.timeSlots != null &&
          widget.pujaArgumrnts!.timeSlots!.isNotEmpty) {
        setState(() {
          viewmodel.timeSlots = widget.pujaArgumrnts!.timeSlots!.map((slot) {
            return TimeSlot(fromTime: slot.fromTime, toTime: slot.toTime);
          }).toList();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPrefilled) {
      viewmodel = Provider.of<CreatePujaViewmodel>(context, listen: false);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        viewmodel.resetForm();

        await viewmodel.getTemples(reset: true);
        await prefillData();
        setState(() {});
      });

      _isPrefilled = true;
    }
  }

  Future<void> prefillData() async {
    final args = widget.pujaArgumrnts;
    if (args == null || args.puja_id.isEmpty) return;

    if (viewmodel.templeData.isEmpty) {
      await viewmodel.getTemples(reset: true);
    }

    viewmodel.pujaId = args.puja_id;
    viewmodel.selectedTempleId = args.templeId;
    viewmodel.pujaName.text = args.puja_name ?? "";
    viewmodel.description.text = args.description ?? "";
    viewmodel.maxDevotees.text = args.maximumNoOfDevotees?.toString() ?? "";
    viewmodel.fee.text = args.fee?.toString() ?? "";
    viewmodel.specialReq = args.allows_special_requirements ?? false;

    final knTranslation = args.translations!.firstWhere(
      (t) => t.languageCode == 'kn',
      orElse: () => Translation(
        languageCode: 'kn',
        pujaName: '',
        description: '',
        deityNames: [],
        benefits: [],
      ),
    );

    viewmodel.pujaNameInKannadam.text = knTranslation.pujaName;
    viewmodel.descriptionInKannadam.text = knTranslation.description;
    viewmodel.benefitsEn = List<String>.from(args.benefits);
    viewmodel.benefitsKn = List<String>.from(knTranslation.benefits);

    if (args.templeId != null && args.templeId!.isNotEmpty) {
      try {
        final matchedTemple = viewmodel.templeData.firstWhere(
          (t) => t.id == args.templeId,
        );

        viewmodel.setSelectedTemple(
          matchedTemple,
          initialDeitiesEn: List<String>.from(args.deities_name),
        );
      } catch (e) {
        debugPrint("Temple ID ${args.templeId} not found in templeData list.");
      }
    }

    if (args.from_date != null) {
      viewmodel.selectedStartDate = DateTime.tryParse(args.from_date!);
    }
    if (args.to_date != null) {
      viewmodel.selectedEndDate = DateTime.tryParse(args.to_date!);
    }

    if (args.days != null) {
      viewmodel.selectedDays.updateAll((key, value) => false);
      for (var day in args.days!) {
        if (viewmodel.selectedDays.containsKey(day)) {
          viewmodel.selectedDays[day] = true;
        }
      }
    }

    if (args.timeSlots != null) {
      viewmodel.timeSlots = args.timeSlots!
          .map((slot) => TimeSlot(fromTime: slot.fromTime, toTime: slot.toTime))
          .toList();
    }

    setState(() {});
  }

  @override
  void dispose() {
    viewmodel.resetForm();
    viewmodel.selectedDays = {
      "Mon": true,
      "Tue": true,
      "Wed": true,
      "Thu": true,
      "Fri": true,
      "Sat": true,
      "Sun": true,
    };
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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
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
          Text(
            widget.pujaArgumrnts!.puja_name.isEmpty
                ? AppLocalizations.of(context)!.addPuja
                : AppLocalizations.of(context)!.updatePuja,
            style: AppTextStyles.appBarTitleStyle,
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTempleDropdown() {
    final bool isKannada = Localizations.localeOf(context).languageCode == 'kn';

    return CommonDropdownField(
      hintText: AppLocalizations.of(context)!.temple,
      labelText: AppLocalizations.of(context)!.temple,
      items: viewmodel.templeData
          .map(
            (t) => isKannada ? (t.translations?.first.name ?? t.name) : t.name,
          )
          .toList(),
      selectedValue: isKannada
          ? viewmodel.selectedTemple?.translations?.first.name
          : viewmodel.selectedTemple?.name,
      paddingSize: 16,
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          viewmodel.deitiesOptionsEn = [];
          viewmodel.deitiesOptionsKn = [];
          viewmodel.selectedDeitiesEn = [];
          viewmodel.selectedDeitiesKn = [];
        });

        final selectedTemple = viewmodel.templeData.firstWhere(
          (t) => t.name == value || (t.translations?.first.name == value),
        );

        viewmodel.setSelectedTemple(selectedTemple);

        setState(() {});
      },
    );
  }

  Widget _buildDeitiesDropdown() {
    final bool isKannada = Localizations.localeOf(context).languageCode == 'kn';

    return DeitiesDropdown(
      items: isKannada
          ? viewmodel.deitiesOptionsKn
          : viewmodel.deitiesOptionsEn,

      selectedItems: isKannada
          ? viewmodel.selectedDeitiesKn
          : viewmodel.selectedDeitiesEn,

      onSelectionChanged: (selected) {
        setState(() {
          if (isKannada) {
            viewmodel.selectedDeitiesKn = selected;
          } else {
            viewmodel.selectedDeitiesEn = selected;
          }
          viewmodel.deitiesList = viewmodel.selectedDeitiesEn;
        });
      },
    );
  }

  Widget _buildPujaDetails() {
    return Column(
      children: [
        CommonTextField(
          hintText: AppLocalizations.of(context)!.addPuja,
          labelText: AppLocalizations.of(context)!.addPuja,
          controller: viewmodel.pujaName,
          isFromPassword: false,
        ),
        const SizedBox(height: 14),
        CommonTextField(
          hintText: AppLocalizations.of(context)!.description,
          labelText: AppLocalizations.of(context)!.description,
          controller: viewmodel.description,
          isFromDescription: true,
          isFromPassword: false,
        ),
        const SizedBox(height: 14),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: BenefitInputWidget(viewmodel: viewmodel, isKannada: false),
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
            AppLocalizations.of(context)!.slot,
            style: AppTextStyles.editTempleTitleStyle,
          ),
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
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: TimeSlotSelector(
            key: ValueKey(viewmodel.timeSlots.hashCode),
            initialSlots: viewmodel.timeSlots,
            onChanged: (updatedSlots) {
              setState(() => viewmodel.timeSlots = updatedSlots);
            },
            startTime: viewmodel.selectedStartDate,
            endTime: viewmodel.selectedEndDate,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationAndFee() {
    return Row(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: CommonTextField(
            hintText: AppLocalizations.of(context)!.cost,
            labelText: AppLocalizations.of(context)!.fees,
            controller: viewmodel.fee,
            isFromPassword: false,
            isFromPhone: true,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: CommonTextField(
            hintText: AppLocalizations.of(context)!.maxDevote,
            labelText: AppLocalizations.of(context)!.maxNoDevote,
            controller: viewmodel.maxDevotees,
            isFromPassword: false,
            isFromPhone: true,
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

  Widget _buildCheckboxSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [cutOffText(), cutOffDropDown()],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(8, 0, 20, 0),
          child: CheckBoxRow(
            label: AppLocalizations.of(context)!.specialReq,
            value: viewmodel.specialReq,
            onChanged: (v) => setState(() => viewmodel.specialReq = v!),
          ),
        ),
      ],
    );
  }

  Widget cutOffText() {
    return Text(
      AppLocalizations.of(context)!.cutOffText,
      style: TextStyle(
        fontFamily: font,
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget cutOffDropDown() {
    return GestureDetector(
      onTap: () => _showCutOffBottomSheet(context),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              viewmodel.selectedCutoffOption,
              style: TextStyle(
                fontFamily: font,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
          ],
        ),
      ),
    );
  }

  void _showCutOffBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.5;
        return SafeArea(
          child: SizedBox(
            height: height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    cutOffBar(),
                    const SizedBox(height: 16),
                    cutOffBarSelectCutOffNoticeText(),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewmodel.cutOffDays.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey.shade300),
                      itemBuilder: (context, index) {
                        final option = viewmodel.cutOffDays[index];
                        viewmodel.cutOffDay = int.parse(option);
                        final isSelected =
                            viewmodel.selectedCutoffOption == option;
                        return ListTile(
                          title: Text(
                            option,
                            style: TextStyle(
                              fontFamily: font,
                              color: Colors.black,
                              fontWeight: isSelected ? FontWeight.w600 : null,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: ColorConstant.primaryColor,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              viewmodel.selectedCutoffOption = option;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget cutOffBar() {
    return Container(
      height: 5,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget cutOffBarSelectCutOffNoticeText() {
    return Text(
      AppLocalizations.of(context)!.cutOffNoticeText,
      style: TextStyle(
        fontFamily: font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
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
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(
                  context,
                  StringsRoute.addPujaInkn,
                  arguments: widget.pujaArgumrnts,
                );
                final isUpdate =
                    widget.pujaArgumrnts != null &&
                    widget.pujaArgumrnts!.puja_id.isNotEmpty;
                // final isValid = await viewmodel.validateForm(isUpdate);

                // if (viewmodel.pujaCreated) {
                //   Fluttertoast.showToast(
                //     msg: viewmodel.message ?? "Puja created successfully.",
                //   );
                //   Navigator.pop(context);
                // } else {
                //   Fluttertoast.showToast(
                //     msg: viewmodel.message ?? "Failed to create puja.",
                //   );
                // }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                widget.pujaArgumrnts!.puja_name.isEmpty
                    ? AppLocalizations.of(context)!.addPuja
                    : AppLocalizations.of(context)!.updatePuja,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
