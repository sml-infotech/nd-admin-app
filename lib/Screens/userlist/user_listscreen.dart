import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listviewModel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/model/login_model/edit_usermodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/user_listModel.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final Map<String, bool> expandedMap = {};

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async => await viewModel.getUsers(),
      child: Scaffold(
        backgroundColor:viewModel.isLoading?Colors.white : ColorConstant.buttonColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.buttonColor,
          elevation: 0,
          title: _nammaDaivaUserListAppBar(),
        ),
        body: viewModel.isLoading
            ?ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 9,
        itemBuilder: (context, index) => const ShimmerUserCard(),
      )
            : Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(child: _listUsers(viewModel)),
                ],
              ),
      ),
    );
  }

  Widget _listUsers(UserViewModel viewModel) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: viewModel.userData.length,
          itemBuilder: (context, index) {
            final user = viewModel.userData[index];
            final isExpanded = expandedMap[user.id] ?? false;

            return Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.white.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _userTile(user, isExpanded, viewModel),
                  if (isExpanded) _userDetails(user),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _userTile(UserModel user, bool isExpanded, UserViewModel viewModel) {
    return ListTile(
      title: Text(user.fullName, style: AppTextStyles.resendCodeStyle),
      subtitle: Text(user.email, style: AppTextStyles.unTabTextStyle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black54),
            onPressed: () => _showEditDialog(user, viewModel),
          ),
          IconButton(
            icon: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                expandedMap[user.id] = !isExpanded;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _userDetails(UserModel user) {
    return Align(alignment: Alignment.topLeft,child: 
    
     Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Role: ${user.role}", style: AppTextStyles.templeNameDetailsStyle),
          Text(
              "Associated Temple: ${user.associatedTempleId ?? 'N/A'}",
              style: AppTextStyles.templeNameDetailsStyle),
          Text("Active: ${user.isActive ? "Yes" : "No"}",
              style: AppTextStyles.templeNameDetailsStyle),
          Text("Created At: ${user.createdAt}",
              style: AppTextStyles.templeNameDetailsStyle),
        ],
      ),
      )  );
  }

  Widget _nammaDaivaUserListAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(StringConstant.userDetails, style: AppTextStyles.appBarTitleStyle),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  void _showEditDialog(UserModel user, UserViewModel viewModel) {
    final fullNameController = TextEditingController(text: user.fullName);
    final emailController = TextEditingController(text: user.email);
    bool isActive = user.isActive;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text("Edit User",
                  style: AppTextStyles.loginTitleStyle.copyWith(
                      fontSize: 18, color: Colors.black)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textField(fullNameController, "Full Name"),
                  const SizedBox(height: 12),
                  _textField(emailController, "Email"),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: 
                    CommonDropdownField(
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
                  )),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Is Active",
                          style: AppTextStyles.otpSubHeadingStyle
                              .copyWith(fontWeight: FontWeight.w600)),
                      StatefulBuilder(
                        builder: (context, setStateSB) {
                          return Switch(
                            value: isActive,
                            activeColor: ColorConstant.buttonColor,
                            onChanged: (val) => setStateSB(() => isActive = val),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel",
                      style: AppTextStyles.buttonTextStyle
                          .copyWith(color: Colors.grey.shade600)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final updatedUser = EditUsermodel(id:user.id , fullName: fullNameController.text
                  , role: user.role, isActive: true
                    );
                // await viewModel.updateUser(updatedUser);
                    Navigator.pop(context);
                  },
                  child: Text("Save",
                      style: AppTextStyles.buttonTextStyle.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextField _textField(TextEditingController controller, String label) {
    return TextField(
      style:AppTextStyles.resendCodeStyle ,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.otpEmailStyle,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstant.buttonColor),
            borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}





class ShimmerUserCard extends StatelessWidget {
  const ShimmerUserCard({super.key});

  @override
  Widget build (BuildContext context) {
    return   
    
    Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.black,
              ),
            ],
          ),
        ),
      
    );
  }
}
