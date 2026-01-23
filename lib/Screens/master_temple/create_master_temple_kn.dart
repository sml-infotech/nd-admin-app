import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/master_temple/create_master_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/post_master_temple_model.dart';
import 'package:provider/provider.dart';

class CreateMasterTempleKn extends StatefulWidget {
  const CreateMasterTempleKn({super.key});

  @override
  State<CreateMasterTempleKn> createState() => _CreateMasterTempleKnState();
}

class _CreateMasterTempleKnState extends State<CreateMasterTempleKn> {
  late CreateMasterViewmodel vm;

  @override
  Widget build(BuildContext context) {
    vm = Provider.of<CreateMasterViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaCreateAppBar(context),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),

                CommonTextField(
                  hintText:
                      "${AppLocalizations.of(context)!.templeName} in Kannada",
                  labelText:
                      "${AppLocalizations.of(context)!.templeName} in Kannada",
                  controller: vm.templeNameInKannadam,
                  isFromPassword: false,
                ),
                const SizedBox(height: 20),

                CommonTextField(
                  hintText:
                      "${AppLocalizations.of(context)!.address} in Kannada",
                  labelText:
                      "${AppLocalizations.of(context)!.address} in Kannada",
                  controller: vm.addressInKannadam,
                  isFromPassword: false,
                ),
                const SizedBox(height: 20),

                CommonTextField(
                  hintText: "${AppLocalizations.of(context)!.city} in Kannada",
                  labelText: "${AppLocalizations.of(context)!.city} in Kannada",
                  controller: vm.cityInKannadam,
                  isFromPassword: false,
                ),
                const SizedBox(height: 20),

                CommonTextField(
                  hintText: "${AppLocalizations.of(context)!.state} in Kannada",
                  labelText:
                      "${AppLocalizations.of(context)!.state} in Kannada",
                  controller: vm.stateInKannadam,
                  isFromPassword: false,
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 20),

                Expanded(child: buildForm(vm)),
                buildBottomButtons(context, vm),
              ],
            ),

            if (vm.isExcelLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),

            if (vm.showExcelPopup) excelOverlayPopup(context, vm),
            if (vm.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.buttonColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget excelOverlayPopup(BuildContext context, CreateMasterViewmodel vm) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              loadedTempleTextAndCloseIcon(vm),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: vm.excelTemples.length,
                  itemBuilder: (context, index) {
                    final item = vm.excelTemples[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          "${item.templeName},${item.city}",
                          style: TextStyle(fontFamily: font),
                        ),
                        subtitle: Text(
                          style: TextStyle(fontFamily: font),
                          "${item.translations.first.address}, ${item.translations.first.city}, ${item.translations.first.state}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            vm.removeTemple(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              createUserButton(context, vm),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadedTempleTextAndCloseIcon(CreateMasterViewmodel vm) {
    return Row(
      children: [
        Text(
          "Loaded Temples",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: font,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () => vm.closeExcelPopup(),
        ),
      ],
    );
  }

  Widget createUserButton(BuildContext context, CreateMasterViewmodel vm) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (vm.excelTemples.isNotEmpty) {
            await vm.createMasterTemple();
            Fluttertoast.showToast(msg: vm.message);
          } else {
            Fluttertoast.showToast(msg: "Add Temples");
          }
          vm.message = "";
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonColor,
        ),
        child: Text(
          AppLocalizations.of(context)!.create,
          style: AppTextStyles.buttonTextStyle,
        ),
      ),
    );
  }

  Widget buildForm(CreateMasterViewmodel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(children: const [SizedBox(height: 20)]),
    );
  }

  Widget buildBottomButtons(BuildContext context, CreateMasterViewmodel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // if (vm.excelTemples.isNotEmpty) viewLoadedTemple(vm),
          // const SizedBox(height: 10),
          addTempleButton(context, vm),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget viewLoadedTemple(CreateMasterViewmodel vm) {
    return GestureDetector(
      onTap: () {
        vm.openExcelPopup();
      },
      child: RichText(
        text: TextSpan(
          text: "View Loaded Temples & Create",
          style: TextStyle(
            fontFamily: font,
            fontSize: 13,
            color: ColorConstant.buttonColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget nammaDaivaCreateAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.addMasterTemple,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget addTempleButton(BuildContext context, CreateMasterViewmodel vm) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (vm.templeName.text.isNotEmpty &&
              vm.templeNameInKannadam.text.isNotEmpty) {
            final knTranslation = MasterTranslation(
              languageCode: "kn",
              templeName: vm.templeNameInKannadam.text,
              address: vm.addressInKannadam.text,
              city: vm.cityInKannadam.text,
              state: vm.stateInKannadam.text,
            );

            vm.excelTemples.add(
              MasterTemple(
                templeName: vm.templeName.text,
                address: vm.address.text,
                city: vm.city.text,
                state: vm.state.text,
                pincode: vm.pincode.text,
                translations: [knTranslation],
              ),
            );

            vm.notifyListeners();
            // vm.openExcelPopup();

            vm.reset();
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(
              msg: "Please fill both English and Kannada fields",
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonColor,
        ),
        child: Text(
          AppLocalizations.of(context)!.addTemple,
          style: AppTextStyles.buttonTextStyle,
        ),
      ),
    );
  }
}
