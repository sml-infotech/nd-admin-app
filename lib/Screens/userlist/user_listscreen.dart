import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listviewModel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/user_listModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final Map<String, bool> expandedMap = {};
  final ScrollController _scrollController = ScrollController();
  late UserViewModel viewModel;

  bool _isLoadingMore = false;
  String? token;
  String? role;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<UserViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserData();
      // await viewModel.getTemples();
      // await viewModel.getUsers(reset: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          viewModel.hasMore) {
        _loadMoreUsers(viewModel);
      }
    });

    // if (!viewModel.searchController.hasListeners) {
    //   viewModel.searchController.addListener(() {
    //     viewModel.onSearchChanged();
    //   });
    // }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('authToken');
      role = prefs.getString('userRole');
    });
  }

  Future<void> _loadMoreUsers(UserViewModel viewModel) async {
    setState(() => _isLoadingMore = true);
    await viewModel.fetchMoreUsers();
    setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    viewModel.searchController.text = "";
    viewModel.resetData();
    debugPrint("🧹 User screen disposed & ViewModel reset.");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<UserViewModel>(
      builder: (context, viewModel, _) {
        return FocusDetector(
          onFocusGained: () async {
            // viewModel.resetData();
            viewModel.resetData();
            await viewModel.getTemples(reset: true);
            await viewModel.getUsers(reset: true);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ColorConstant.buttonColor,
              elevation: 0,
              title: _buildAppBar(viewModel),
            ),
            body: Column(
              children: [
                SizedBox(height: 10),
                userSearchBar(),
                SizedBox(height: 10),
                Expanded(
                  child: viewModel.isLoading && viewModel.page == 1
                      ? _buildFullShimmerList()
                      : _buildUserList(viewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(UserViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () {
            viewModel.resetData();
            Navigator.pop(context);
          },
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.users,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        if (role != "Admin")
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, StringsRoute.createUser);
              viewModel.resetData();
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
      ],
    );
  }

  Widget _buildFullShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 9,
      itemBuilder: (context, index) => const ShimmerUserCard(),
    );
  }

  Widget _buildUserList(UserViewModel viewModel) {
    if (viewModel.userData.isEmpty && !viewModel.isLoading) {
      return Center(
        child: Text(
          "No Users Found",
          style: AppTextStyles.resendCodeStyle.copyWith(color: Colors.black54),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: viewModel.userData.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < viewModel.userData.length) {
            final user = viewModel.userData[index];
            final isExpanded = expandedMap[user.id] ?? false;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Column(
                  children: [
                    _buildUserTile(user, isExpanded, viewModel),
                    if (isExpanded)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                        child: _buildUserDetails(user),
                      ),
                  ],
                ),
              ),
            );
          }

          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ShimmerUserCard(),
          );
        },
      ),
    );
  }

  Widget _buildUserTile(
    UserModel user,
    bool isExpanded,
    UserViewModel viewModel,
  ) {
    final bool canEdit = role != "Admin" && user.role != "Super Admin";
    final bool isActive = user.isActive;
    final Color statusColor = isActive ? Colors.green : Colors.redAccent;

    return Stack(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text(
            user.fullName,
            style: AppTextStyles.resendCodeStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppLocalizations.of(context)!.role} : ${user.role}",
                style: AppTextStyles.unTabTextStyle.copyWith(
                  fontSize: 13,
                  color: isActive ? Colors.black54 : Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "${AppLocalizations.of(context)!.email} : ${user.email}",
                style: AppTextStyles.unTabTextStyle.copyWith(
                  fontSize: 13,
                  color: isActive ? Colors.black54 : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${AppLocalizations.of(context)!.phone} : ${user.phoneNumber}",
                style: AppTextStyles.unTabTextStyle.copyWith(
                  fontSize: 13,
                  color: isActive ? Colors.black54 : Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontFamily: font,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (canEdit)
          Positioned(
            top: 6,
            right: 8,
            child: GestureDetector(
              onTap: () => _showEditBottomSheet(user, viewModel),
              child: Container(
                height: 30,
                width: 30,
                child: Center(child: Image.asset(ImageStrings.edit)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserDetails(UserModel user) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact: ${user.phoneNumber}",
              style: AppTextStyles.templeNameDetailsStyle,
            ),
            if (user.role.toLowerCase() == 'agent' ||
                user.role.toLowerCase() == 'temple')
              Text(
                "Associated Temple: ${user.associatedTemples.map((t) => t.name).join(', ')}",
                style: AppTextStyles.templeNameDetailsStyle,
              ),
          ],
        ),
      ),
    );
  }

  Widget userSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: viewModel.searchController,
        onChanged: (value) {
          viewModel.onSearchChanged();
        },
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchUser,
          hintStyle: TextStyle(fontFamily: font),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return "Invalid Date";
    }
  }

  void _showEditBottomSheet(UserModel user, UserViewModel viewModel) {
    final fullNameController = TextEditingController(text: user.fullName);
    final emailController = TextEditingController(text: user.email);

    viewModel.setTempActive(user.id, user.isActive);
    viewModel.selectedTempleIds = user.associatedTemples
        .map((t) => t.id)
        .toList();
    viewModel.role.text = user.role;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;

        return SizedBox(
          height: screenHeight / 1.5,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 12,
            ),
            child: _buildAlertDialog(
              user,
              viewModel,
              fullNameController,
              emailController,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlertDialog(
    UserModel user,
    UserViewModel viewModel,
    TextEditingController fullNameController,
    TextEditingController emailController,
  ) {
    return StatefulBuilder(
      builder: (context, setStateSB) {
        final String currentRole = viewModel.role.text.isNotEmpty
            ? viewModel.role.text
            : user.role;

        final bool isAgentOrTemple = currentRole.toLowerCase() == 'temple';

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            AppLocalizations.of(context)!.editUser,
                            style: AppTextStyles.loginTitleStyle.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(fullNameController, "Full Name"),
                      const SizedBox(height: 16),
                      // _buildTextField(emailController, "Email"),
                      const SizedBox(height: 16),
                      CommonDropdownField(
                        paddingSize: 0,
                        hintText: AppLocalizations.of(context)!.selectedRole,
                        labelText: AppLocalizations.of(context)!.role,
                        items: StringConstant.roles,
                        selectedValue: currentRole,
                        onChanged: (value) {
                          viewModel.role.text = value ?? user.role;
                          setStateSB(() {});
                        },
                      ),
                      const SizedBox(height: 16),

                      if (isAgentOrTemple)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Associated Temples",
                              style: AppTextStyles.otpSubHeadingStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: viewModel.templeList.map<Widget>((
                                  temple,
                                ) {
                                  final String templeId = (temple['id'] ?? '')
                                      .toString();
                                  final String templeName =
                                      (temple['name'] ??
                                              temple['temple_name'] ??
                                              '')
                                          .toString();

                                  final bool isSelected = viewModel
                                      .selectedTempleIds
                                      .contains(templeId);

                                  return CheckboxListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      templeName,
                                      style:
                                          AppTextStyles.templeNameDetailsStyle,
                                    ),
                                    value: isSelected,
                                    activeColor: ColorConstant.buttonColor,
                                    onChanged: (bool? value) {
                                      if (value == true) {
                                        viewModel.selectedTempleIds.add(
                                          templeId,
                                        );
                                      } else {
                                        viewModel.selectedTempleIds.remove(
                                          templeId,
                                        );
                                      }
                                      setStateSB(() {});
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Is Active",
                            style: AppTextStyles.otpSubHeadingStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Switch(
                            value: viewModel.getTempActive(user.id),
                            activeColor: Colors.green,
                            onChanged: (val) {
                              viewModel.setTempActive(user.id, val);
                              setStateSB(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: ColorConstant.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final isValid = await viewModel.updateValidate(
                            fullNameController.text,
                          );
                          if (viewModel.message.isNotEmpty) {
                            Fluttertoast.showToast(msg: viewModel.message);
                            viewModel.message = "";
                          }
                          if (isValid) {
                            final isActive = viewModel.getTempActive(user.id);
                            setStateSB(() {
                              FocusScope.of(context).unfocus();
                              viewModel.editLoading = true;
                            });
                            await viewModel.editUser(
                              user.id,
                              fullNameController.text,
                              isActive,
                              selectedTemples: viewModel.selectedTempleIds,
                            );

                            setStateSB(() {
                              viewModel.editLoading = false;
                            });
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Save",
                          style: AppTextStyles.buttonTextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (viewModel.editLoading)
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
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: AppTextStyles.resendCodeStyle,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.otpEmailStyle,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstant.buttonColor),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class ShimmerUserCard extends StatelessWidget {
  const ShimmerUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
