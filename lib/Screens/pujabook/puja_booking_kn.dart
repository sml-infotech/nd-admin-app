import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/benefits.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_add_deities.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/puja_arguments.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PujaBookingKn extends StatefulWidget {
  final PujaArguments? pujaArgumrnts;

  const PujaBookingKn({super.key, required this.pujaArgumrnts});

  @override
  State<PujaBookingKn> createState() => _PujaBookingKnState();
}

class _PujaBookingKnState extends State<PujaBookingKn> {
  late CreatePujaViewmodel viewmodel;
  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<CreatePujaViewmodel>(context);
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
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildTempleDropdownforkn(),
                  const SizedBox(height: 15),
                  _buildDeitiesDropdownforkn(),
                  const SizedBox(height: 18),
                  _buildPujaDetails(),
                  const SizedBox(height: 80),
                ],
              ),
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

  Widget _buildPujaDetails() {
    return Column(
      children: [
        CommonTextField(
          hintText: AppLocalizations.of(context)!.addPuja,
          labelText: AppLocalizations.of(context)!.addPuja,
          controller: viewmodel.pujaNameInKannadam,
          isFromPassword: false,
        ),
        const SizedBox(height: 14),
        CommonTextField(
          hintText: AppLocalizations.of(context)!.description,
          labelText: AppLocalizations.of(context)!.description,
          controller: viewmodel.descriptionInKannadam,
          isFromDescription: true,
          isFromPassword: false,
        ),
        const SizedBox(height: 14),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: BenefitInputWidget(viewmodel: viewmodel, isKannada: true),
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
                FocusScope.of(context).unfocus();
                final isUpdate =
                    widget.pujaArgumrnts != null &&
                    widget.pujaArgumrnts!.puja_id.isNotEmpty;
                final isValid = await viewmodel.validateForm(isUpdate);
                if (viewmodel.pujaCreated) {
                  Fluttertoast.showToast(
                    msg: viewmodel.message ?? "Puja created successfully.",
                  );
                  Navigator.popUntil(
                    context,
                    (route) => route.settings.name == StringsRoute.pujaList,
                  );

                  viewmodel.pujaCreated = false;
                  viewmodel.resetForm();
                } else {
                  Fluttertoast.showToast(
                    msg: viewmodel.message ?? "Failed to create puja.",
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

  Widget _buildTempleDropdownforkn() {
    return CommonDropdownField(
      hintText: AppLocalizations.of(context)!.temple,
      labelText: AppLocalizations.of(context)!.temple,
      // Use the name from the translation, or fallback to English name
      items: viewmodel.templeData
          .map(
            (t) => (t.translations != null && t.translations!.isNotEmpty)
                ? t.translations!.first.name
                : t.name,
          )
          .toList(),
      // Correctly find the name of the currently selected temple in the ViewModel
      selectedValue:
          (viewmodel.selectedTemple?.translations != null &&
              viewmodel.selectedTemple!.translations!.isNotEmpty)
          ? viewmodel.selectedTemple!.translations!.first.name
          : viewmodel.selectedTemple?.name,
      paddingSize: 16,
      onChanged: (value) {
        if (value == null) return;
        final selectedTemple = viewmodel.templeData.firstWhere(
          (t) => (t.translations?.first.name == value || t.name == value),
        );
        viewmodel.setSelectedTemple(selectedTemple);
        setState(() {}); // Ensure the UI updates when temple changes
      },
    );
  }

  Widget _buildDeitiesDropdownforkn() {
    return DeitiesDropdown(
      items: viewmodel.deitiesOptionsKn,
      // selectedDeitiesKn contains only the specific deities chosen for this Puja
      selectedItems: viewmodel.selectedDeitiesKn,
      onSelectionChanged: (selected) {
        setState(() {
          viewmodel.selectedDeitiesKn = selected;
          // Map Kannada selections back to English for the backend API
          viewmodel.selectedDeitiesEn = selected.map((knName) {
            int index = viewmodel.deitiesOptionsKn.indexOf(knName);
            return (index != -1) ? viewmodel.deitiesOptionsEn[index] : knName;
          }).toList();
          viewmodel.deitiesList = viewmodel.selectedDeitiesEn;
        });
      },
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
            AppLocalizations.of(context)!.addPuja,
            style: AppTextStyles.appBarTitleStyle,
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
