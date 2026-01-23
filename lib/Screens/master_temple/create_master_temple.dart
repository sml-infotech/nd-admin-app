import 'dart:io' show File;
import 'package:excel/excel.dart' show Excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/master_temple/create_master_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/post_master_temple_model.dart';
import 'package:provider/provider.dart';

class CreateMasterTemple extends StatefulWidget {
  const CreateMasterTemple({super.key});

  @override
  State<CreateMasterTemple> createState() => _CreateMasterTempleState();
}

class _CreateMasterTempleState extends State<CreateMasterTemple> {
  late CreateMasterViewmodel vm;
  @override
  Widget build(BuildContext context) {
    vm = Provider.of<CreateMasterViewmodel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async {},
      child: Scaffold(
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
                  SizedBox(height: screenHeight * 0.02),
                  CommonTextField(
                    hintText: AppLocalizations.of(context)!.templeName,
                    labelText: AppLocalizations.of(context)!.templeName,
                    controller: vm.templeName,
                    isFromPassword: false,
                  ),
                  const SizedBox(height: 20),

                  CommonTextField(
                    hintText: AppLocalizations.of(context)!.address,
                    labelText: AppLocalizations.of(context)!.address,
                    controller: vm.address,
                    isFromPassword: false,
                  ),
                  const SizedBox(height: 20),

                  CommonTextField(
                    hintText: AppLocalizations.of(context)!.city,
                    labelText: AppLocalizations.of(context)!.city,
                    controller: vm.city,
                    isFromPassword: false,
                  ),
                  const SizedBox(height: 20),

                  CommonTextField(
                    hintText: AppLocalizations.of(context)!.state,
                    labelText: AppLocalizations.of(context)!.state,
                    controller: vm.state,
                    isFromPassword: false,
                  ),
                  const SizedBox(height: 20),

                  CommonTextField(
                    hintText: AppLocalizations.of(context)!.pincode,
                    labelText: AppLocalizations.of(context)!.pincode,
                    controller: vm.pincode,
                    isFromPassword: false,
                    isFromPhone: true,
                  ),
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

  Widget buildForm(CreateMasterViewmodel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(children: const [SizedBox(height: 20)]),
    );
  }

  Widget excelOverlayPopup(BuildContext context, CreateMasterViewmodel vm) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.6,
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
                          item.templeName,
                          style: TextStyle(fontFamily: font),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // English Details
                            Text(
                              "${item.address}, ${item.city}\n${item.state} - ${item.pincode}",
                              style: TextStyle(fontFamily: font),
                            ),
                            const Divider(),
                            // Kannada Details (Safe Check)
                            if (item.translations.isNotEmpty) ...[
                              Text(
                                item.translations.first.templeName,
                                style: TextStyle(
                                  fontFamily: font,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              Text(
                                "${item.translations.first.address}, ${item.translations.first.city}, ${item.translations.first.state}",
                                style: TextStyle(
                                  fontFamily: font,
                                  height: 1.5,
                                ), // height for Kannada glyphs
                              ),
                            ] else
                              const Text(
                                "No Translation added",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                          ],
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

  // Widget loaded

  Widget buildBottomButtons(BuildContext context, CreateMasterViewmodel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (vm.excelTemples.isNotEmpty) viewLoadedTemple(vm),
          const SizedBox(height: 15),

          uploadExcelTempleButton(context),
          const SizedBox(height: 10),
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

  Widget addTempleButton(BuildContext context, CreateMasterViewmodel vm) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (vm.templeName.text.isNotEmpty &&
              vm.address.text.isNotEmpty &&
              vm.city.text.isNotEmpty &&
              vm.state.text.isNotEmpty &&
              vm.pincode.text.isNotEmpty) {
            // vm.excelTemples.add(
            //   MasterTemple(
            //     templeName: vm.templeName.text ?? "",
            //     address: vm.address.text ?? "",
            //     city: vm.city.text ?? "",
            //     state: vm.state.text ?? "",
            //     pincode: vm.pincode.text ?? "",
            //   ),
            // );

            Navigator.pushNamed(
              context,
              StringsRoute.create_master_temple_in_kn,
            );
            vm.notifyListeners();
            // vm.openExcelPopup();
            // vm.reset();
          } else {
            Fluttertoast.showToast(msg: "Fill The All Fields");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonColor,
        ),
        child: Text(
          AppLocalizations.of(context)!.next,
          style: AppTextStyles.buttonTextStyle,
        ),
      ),
    );
  }

  Widget uploadExcelTempleButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _pickAndReadExcelFile(context),
        style: ElevatedButton.styleFrom(
          side: const BorderSide(color: ColorConstant.buttonColor),
          backgroundColor: Colors.white,
        ),
        child: Text(
          AppLocalizations.of(context)!.uploadFromExcel,
          style: TextStyle(
            fontSize: 16,
            fontFamily: font,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndReadExcelFile(BuildContext context) async {
    final vm = Provider.of<CreateMasterViewmodel>(context, listen: false);

    try {
      vm.setExcelLoading(true);

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null) {
        vm.setExcelLoading(false);
        return;
      }

      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      String sheet = excel.tables.keys.first;
      var rows = excel.tables[sheet]!.rows;

      for (int i = 1; i < rows.length; i++) {
        var row = rows[i];

        // vm.excelTemples.add(
        //   MasterTemple(
        //     templeName: row[0]?.value.toString() ?? "",
        //     address: row[1]?.value.toString() ?? "",
        //     city: row[2]?.value.toString() ?? "",
        //     state: row[3]?.value.toString() ?? "",
        //     pincode: row[4]?.value.toString() ?? "",

        //   ),
        // );
      }

      vm.setExcelLoading(false);
      vm.openExcelPopup();
    } catch (e) {
      vm.setExcelLoading(false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload a Valid Excel ")));
    }
  }
}
