import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/create_user_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/otp_arguments.dart';
import 'package:provider/provider.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  late CreateUserViewmodel viewModel;

  @override
  void initState() {
    super.initState();
    // Initialize ViewModel here if needed
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => CreateUserViewmodel(),
      child: Consumer<CreateUserViewmodel>(
        builder: (context, viewModel, _) {
          return FocusDetector(
            onFocusGained: () async {
              await viewModel.getTemples(reset: true);
            },
            child: Scaffold(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CommonTextField(
                                    hintText: StringConstant.enterName,
                                    labelText: StringConstant.userName,
                                    isFromPassword: false,
                                    controller: viewModel.nameController,
                                  ),
                                  const SizedBox(height: 20),
                                  CommonTextField(
                                    hintText: StringConstant.email,
                                    labelText: StringConstant.email,
                                    isFromPassword: false,
                                    controller: viewModel.emailController,
                                  ),
                                  const SizedBox(height: 20),
                                  CommonTextField(
                                    hintText: StringConstant.password,
                                    labelText: StringConstant.password,
                                    isFromPassword: true,
                                    controller: viewModel.passwordController,
                                  ),
                                  const SizedBox(height: 20),
                                 CommonDropdownField(
                                  paddingSize: 20,
                                  hintText: StringConstant.selectedRole,
                                  labelText: StringConstant.role,
                                  items: StringConstant.roles,
                                  selectedValue: StringConstant.roles.contains(viewModel.role.text)
                                   ? viewModel.role.text
                                 : null,
                                 onChanged: (value) {
                                 viewModel.role.text = value ?? "";
                                 viewModel.notifyListeners();
                                  },
                                  ),
                                  if (viewModel.role.text  == "Temple"|| viewModel.role.text  == "Agent") ...[
                                    const SizedBox(height: 20),
                                    CommonDropdownField(
                                      paddingSize: 20,
                                      hintText: StringConstant.selectTemples,
                                      labelText: StringConstant.temples,
                                      items: viewModel.templeList,
                                      selectedValue: viewModel.selectedTempleName,
                                      onChanged: (value) {
                                        viewModel.selectTemple(value);
                                      },
                                    ),
                                  ],
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
          StringConstant.createAcc,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget createUserButton(CreateUserViewmodel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
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
          if(viewModel.isCreateUserSuccess){
              Navigator.pushReplacementNamed(context, StringsRoute.userDetails);
          }
          setState(() {
            viewModel.isCreateUserSuccess=false;
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
