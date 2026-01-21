import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/temple_input_widget.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/temple_details_arguments.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UpdateTempleKn extends StatefulWidget {
  final TempleDetailsArguments arguments;
  const UpdateTempleKn({super.key, required this.arguments});

  @override
  State<UpdateTempleKn> createState() => _UpdateTempleKnState();
}

class _UpdateTempleKnState extends State<UpdateTempleKn> {
  late UpdateTempleViewmodel viewModel;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      viewModel = Provider.of<UpdateTempleViewmodel>(context, listen: false);
      _setInitialData();
      _isInitialized = true;
    }
  }

  void _setInitialData() {
    viewModel.originalTempleData = widget.arguments;

    // Fetch the Kannada translation
    final knTranslation = widget.arguments.translations.firstWhere(
      (t) => t.languageCode == 'kn',
      orElse: () => widget.arguments.translations.first,
    );

    // Log the full translation data to inspect what you have
    print("Full Translation Data: ${knTranslation.toJson()}");

    // Ensure deities is a List<String> and log to check the values
    List<String> deitiesList = knTranslation.deities ?? [];
    print("Deities List: $deitiesList");

    viewModel.prefilledTemplesInKannadam = deitiesList;

    // Set all other temple-related data
    viewModel.templeNameInKannadam.text = knTranslation.name ?? '';
    viewModel.templeLocationInKannadam.text = knTranslation.address ?? '';
    viewModel.templeDescriptionInKannadam.text =
        knTranslation.description ?? '';
    viewModel.templeCityInKannadam.text = knTranslation.city ?? '';
    viewModel.templeStateInKannadam.text = knTranslation.state ?? '';

    // Set the TextEditingController for Deities in Kannada
    viewModel.templeDeitiesInKannadam.text = viewModel
        .prefilledTemplesInKannadam
        .join(', ');

    // Log to confirm data is set correctly
    print(
      "Prefilled Deities in Kannada: ${viewModel.prefilledTemplesInKannadam}",
    );

    // Notify listeners to refresh the UI after data is set
    viewModel.notifyListeners();
    ;
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<UpdateTempleViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaDetailAppBar(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Column(
              children: [
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
                      padding: const EdgeInsets.all(0.0),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            titleTextWidget(
                              AppLocalizations.of(context)!.templeName,
                            ),
                            const SizedBox(height: 8),

                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeNameInKannadam,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.templelocation,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeLocationInKannadam,
                            ),
                            titleTextWidget(AppLocalizations.of(context)!.city),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeCityInKannadam,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.state,
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              hintText: "",
                              labelText: "",
                              isFromPassword: false,
                              controller: viewModel.templeStateInKannadam,
                            ),
                            titleTextWidget(
                              AppLocalizations.of(context)!.deitiestemple,
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TempleInputWidget(
                                list: viewModel.prefilledTemplesInKannadam,
                                onAdd: (val) =>
                                    viewModel.addTempleInKannadam(val),
                                onRemove: (idx) =>
                                    viewModel.removeTempleInKannadam(idx),
                                hintText: "ದೇವಸ್ಥಾನವನ್ನು ಸೇರಿಸಿ",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (viewModel.isLoading)
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

  Widget titleTextWidget(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(title, style: AppTextStyles.editTempleTitleStyle),
    );
  }

  Widget nammaDaivaDetailAppBar() {
    return Center(
      child: Row(
        children: [
          IconButton(
            icon: Image.asset(ImageStrings.backbutton),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.templeDetail,
            style: AppTextStyles.appBarTitleStyle,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus();
              if (viewModel.validateUpdateTemple()) {
                await viewModel.updateTemple(widget.arguments.templeId);
                Fluttertoast.showToast(msg: viewModel.message);
                if (viewModel.templeUpdated) {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(StringsRoute.templeScreen),
                  );
                  viewModel.reset();
                  viewModel.templeUpdated = false;
                }
              } else {
                Fluttertoast.showToast(msg: viewModel.message);
              }
            },
            child: Text(
              AppLocalizations.of(context)!.save,
              style: AppTextStyles.appBarTitleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
