import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/mantra/create_mantra_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/update_mantra.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CreateMantraInKannadam extends StatefulWidget {
  final UpdateMantraArguments updateMantra;
  const CreateMantraInKannadam({super.key, required this.updateMantra});

  @override
  State<CreateMantraInKannadam> createState() => _CreateMantraInKannadamState();
}

class _CreateMantraInKannadamState extends State<CreateMantraInKannadam> {
  late CreateMantraViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<CreateMantraViewmodel>(context);

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: appBarForCreateMantra(),
        automaticallyImplyLeading: false,
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

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

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        mantraTextField(),
                        const SizedBox(height: 16),
                        mantraNameTextField(),
                        const SizedBox(height: 16),

                        const SizedBox(height: 30),
                        Spacer(),
                        createMantraButton(viewModel),
                      ],
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

  Widget mantraTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.mantra_name_kn,
      labelText: AppLocalizations.of(context)!.mantra_name_kn,
      controller: viewModel.mantraNameInKannadam,
      isFromPassword: false,
    );
  }

  Widget mantraNameTextField() {
    return CommonTextField(
      hintText: AppLocalizations.of(context)!.mantra_kn,
      labelText: AppLocalizations.of(context)!.mantra_kn,
      controller: viewModel.mantraInKannadam,
      isFromPassword: false,
    );
  }

  Widget appBarForCreateMantra() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          widget.updateMantra!.mantra.isEmpty
              ? AppLocalizations.of(context)!.create_mantra_inKannadam
              : "Update Mantra",
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        SizedBox(width: 30),
      ],
    );
  }

  Widget createMantraButton(CreateMantraViewmodel viewmodel) {
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
                if (await viewmodel.validateForm()) {
                  if (widget.updateMantra!.mantra.isEmpty) {
                    await viewmodel.createMantra();
                  } else {
                    await viewmodel.updateMantra(
                      widget.updateMantra!.mantraID!,
                    );
                  }
                  if (viewmodel.isCompleted) {
                    Navigator.popUntil(
                      context,
                      (route) => route.settings.name == StringsRoute.mantraList,
                    );
                  }
                  viewmodel.isLoading = false;
                }

                viewmodel.message = "";
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                widget.updateMantra!.mantra.isEmpty
                    ? AppLocalizations.of(context)!.create
                    : AppLocalizations.of(context)!.update,
                style: AppTextStyles.buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
