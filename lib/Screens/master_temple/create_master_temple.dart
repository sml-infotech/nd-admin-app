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
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:provider/provider.dart';

class CreateMasterTemple extends StatelessWidget {
  const CreateMasterTemple({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => CreateMasterViewmodel(),
      child: Consumer<CreateMasterViewmodel>(
        builder: (context, vm, _) {
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

                        Expanded(child: buildForm(vm, context)),

                        buildBottomButtons(context, vm),
                      ],
                    ),

                    if (vm.isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.4),
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
        },
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
          StringConstant.addMasterTemple,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget buildForm(CreateMasterViewmodel vm, context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          SizedBox(height: 10),
          CommonTextField(
            hintText: StringConstant.templeName,
            labelText: StringConstant.templeName,
            controller: vm.templeName,
            isFromPassword: false,
          ),
          const SizedBox(height: 20),

          CommonTextField(
            hintText: StringConstant.addresss,
            labelText: StringConstant.addresss,
            controller: vm.address,
            isFromPassword: false,
          ),
          const SizedBox(height: 20),

          CommonTextField(
            hintText: StringConstant.cityy,
            labelText: StringConstant.cityy,
            controller: vm.city,
            isFromPassword: false,
          ),
          const SizedBox(height: 20),

          CommonTextField(
            hintText: StringConstant.statee,
            labelText: StringConstant.statee,
            controller: vm.state,
            isFromPassword: false,
          ),
          const SizedBox(height: 20),

          CommonTextField(
            hintText: StringConstant.pincode,
            labelText: StringConstant.pincode,
            controller: vm.pincode,
            isFromPassword: false,
            isFromPhone: true,
          ),
          const SizedBox(height: 20),
          addTempleButton(context, vm),
          excelTempleCards(vm),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget excelTempleCards(CreateMasterViewmodel vm) {
    return vm.excelTemples.isEmpty
        ? const SizedBox() // nothing to show
        : ListView.builder(
            itemCount: vm.excelTemples.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = vm.excelTemples[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                    side: BorderSide(color: Colors.black12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      item.templeName,
                      style: TextStyle(fontFamily: font),
                    ),
                    subtitle: Text(
                      style: TextStyle(fontFamily: font),
                      "${item.address}, ${item.city}\n${item.state} - ${item.pincode}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        vm.excelTemples.removeAt(index);
                        vm.notifyListeners(); 
                      },
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget buildBottomButtons(BuildContext context, CreateMasterViewmodel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          uploadExcelTempleButton(context),
          const SizedBox(height: 10),
          createUserButton(context, vm),
        ],
      ),
    );
  }

  Widget createUserButton(BuildContext context, CreateMasterViewmodel vm) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          // bool ok = await vm.validateUser();

          // if (!ok && vm.message.isNotEmpty) {
          //   Fluttertoast.showToast(msg: vm.message);
          //   return;
          // }

          // Success Action Here
          Fluttertoast.showToast(msg: "Validated Successfully!");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonColor,
        ),
        child: Text(
          StringConstant.create,
          style: AppTextStyles.buttonTextStyle,
        ),
      ),
    );
  }

  Widget addTempleButton(BuildContext context, CreateMasterViewmodel vm) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            if (vm.templeName.text.isNotEmpty&&vm.address.text.isNotEmpty) {
              vm.excelTemples.add(
                TempleModelExcel(
                  templeName: vm.templeName.text,
                  address: vm.address.text,
                  city: vm.city.text,
                  state: vm.state.text,
                  pincode: vm.pincode.text,
                ),
              );
              vm.notifyListeners(); // <--- Required
              vm.reset();
            }
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: ColorConstant.buttonColor),
            backgroundColor: Colors.white,
          ),
          child: Text(
            StringConstant.addMasterTemple,

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: font,
            ),
          ),
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
          backgroundColor: ColorConstant.buttonColor,
        ),
        child: Text(
          StringConstant.uploadFromExcel,
          style: AppTextStyles.buttonTextStyle,
        ),
      ),
    );
  }

  Future<void> _pickAndReadExcelFile(BuildContext context) async {
    final vm = Provider.of<CreateMasterViewmodel>(context, listen: false);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null) return;

      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      String sheet = excel.tables.keys.first;
      var rows = excel.tables[sheet]!.rows;

      List<TempleModelExcel> list = [];

      for (int i = 1; i < rows.length; i++) {
        var row = rows[i];
        vm.excelTemples.add(
          TempleModelExcel(
            templeName: row[0]?.value.toString() ?? "",
            address: row[1]?.value.toString() ?? "",
            city: row[2]?.value.toString() ?? "",
            state: row[3]?.value.toString() ?? "",
            pincode: row[4]?.value.toString() ?? "",
          ),
        );
      }

      vm.notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
