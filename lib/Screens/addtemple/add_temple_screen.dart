
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:provider/provider.dart';

class AddTempleScreen extends StatefulWidget {
  const AddTempleScreen({super.key});

  @override
  State<AddTempleScreen> createState() => _AddTempleScreenState();
}

class _AddTempleScreenState extends State<AddTempleScreen> {
  late AddTempleViewmodel templeViewmodel;
  @override
  Widget build(BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
    templeViewmodel = Provider.of<AddTempleViewmodel>(context);
    return Scaffold(
              backgroundColor: ColorConstant.buttonColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: ColorConstant.buttonColor,
                elevation: 0,
                title: nammaDaivaCreateAppBar(),
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child:Column(children: [
                              CommonTextField(hintText: "", labelText: "labelText", isFromPassword: false, controller: templeViewmodel.templeName)

                              ],)))))])]));
  }

    Widget nammaDaivaCreateAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(
          StringConstant.addTemple,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }


}