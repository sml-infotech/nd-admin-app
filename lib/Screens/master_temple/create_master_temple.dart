import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/create_user_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/master_temple/create_master_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:provider/provider.dart';

class CreateMasterTemple extends StatefulWidget {
  const CreateMasterTemple({super.key});

  @override
  State<CreateMasterTemple> createState() => _CreateMasterTempleState();
}

class _CreateMasterTempleState extends State<CreateMasterTemple> {
  late CreateMasterViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => CreateMasterViewmodel(),
      child: Consumer<CreateMasterViewmodel>(
        builder: (context, viewModel, _) {
          return FocusDetector(
            onFocusGained: () async {},
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: ColorConstant.buttonColor,
                elevation: 0,
                title: nammaDaivaCreateAppBar(),
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
                              padding: const EdgeInsets.all(0.0),
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 10),
                                    CommonTextField(
                                      hintText: StringConstant.templeName,
                                      labelText: StringConstant.templeName,
                                      isFromPassword: false,
                                      controller: viewModel.templeName,
                                    ),
                                    const SizedBox(height: 20),
                                    CommonTextField(
                                      hintText: StringConstant.addresss,
                                      labelText: StringConstant.addresss,
                                      isFromPassword: false,
                                      controller: viewModel.address,
                                    ),
                                    const SizedBox(height: 20),
                                    CommonTextField(
                                      hintText: StringConstant.cityy,
                                      labelText: StringConstant.cityy,
                                      isFromPassword: false,
                                      controller: viewModel.city,
                                    ),
                                    const SizedBox(height: 20),
                                    CommonTextField(
                                      hintText: StringConstant.statee,
                                      labelText: StringConstant.statee,
                                      isFromPassword: false,
                                      isFromPhone: false,
                                      controller: viewModel.state,
                                    ),
                                    const SizedBox(height: 20),

                                    CommonTextField(
                                      hintText: StringConstant.pincode,
                                      labelText: StringConstant.pincode,
                                      isFromPassword: false,
                                      isFromPhone: true,
                                      controller: viewModel.pincode,
                                    ),
                                    const SizedBox(height: 20),
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: SafeArea(
                            top: false,
                            child: createUserButton(viewModel),
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
            ),
          );
        },
      ),
    );
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
          StringConstant.addMasterTemple,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget createUserButton(CreateMasterViewmodel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();

          await viewModel.validateUser();

          if (viewModel.message.isNotEmpty) {
            Fluttertoast.showToast(
              msg: viewModel.message,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_SHORT,
            );
            viewModel.message = "";
          }
          if (viewModel.isCreateUserSuccess) {
            Navigator.pop(context);
          }
          setState(() {
            viewModel.isCreateUserSuccess = false;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          StringConstant.create,
          style: AppTextStyles.buttonTextStyle,
        ),
      ),
    );
  }
}
