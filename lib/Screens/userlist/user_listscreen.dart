import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listviewModel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
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
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<UserViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewModel.getTemples();
      await viewModel.getUsers(reset: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          viewModel.hasMore) {
        _loadMoreUsers(viewModel);
      }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async {
        if (viewModel.userData.isEmpty) {}
      },
      child: Scaffold(
        backgroundColor: viewModel.isLoading
            ? Colors.white
            : ColorConstant.buttonColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.buttonColor,
          elevation: 0,
          title: _buildAppBar(),
        ),
        body: viewModel.isLoading && viewModel.page == 1
            ? _buildFullShimmerList()
            : Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(child: _buildUserList(viewModel)),
                ],
              ),
      ),
    );
  }

  Widget _buildAppBar() {
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

  Widget _buildFullShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 9,
      itemBuilder: (context, index) => const ShimmerUserCard(),
    );
  }

  Widget _buildUserList(UserViewModel viewModel) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: viewModel.userData.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < viewModel.userData.length) {
            final user = viewModel.userData[index];
            final isExpanded = expandedMap[user.id] ?? false;
            return Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildUserTile(user, isExpanded, viewModel),
                  if (isExpanded) _buildUserDetails(user),
                ],
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

  Widget _buildUserDetails(UserModel user) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Role: ${user.role}",
              style: AppTextStyles.templeNameDetailsStyle,
            ),
            if (user.role.toLowerCase() == 'agent' ||
                user.role.toLowerCase() == 'temple')
              Text(
                "Associated Temple: ${user.associatedTemples.map((temple) => temple.name).join(', ') ?? 'N/A'}",
                style: AppTextStyles.templeNameDetailsStyle,
              ),
            Text(
              "Active: ${user.isActive ? "Yes" : "No"}",
              style: TextStyle(
                fontFamily: font,
                fontSize: 16,
                color: user.isActive ? Colors.green : Colors.red,
              ),
            ),
            Text(
              "Created At: ${user.createdAt ?? user.updatedAt}",
              style: AppTextStyles.templeNameDetailsStyle,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _showEditDialog(UserModel user, UserViewModel viewModel) async {
    final fullNameController = TextEditingController(text: user.fullName);
    final emailController = TextEditingController(text: user.email);

    viewModel.setTempActive(user.id, user.isActive);
    List<String> associatedIds = [];
    associatedIds = user.associatedTemples.map((t) => t.id).toList();
    viewModel.selectedTempleIds = associatedIds;
    viewModel.selectedTempleIds = associatedIds;
    print(">>>>>>>>>>>><<<<<<<<<<<,${viewModel.selectedTempleIds}");
    viewModel.role.text = user.role;
    await Future.delayed(const Duration(milliseconds: 50));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AnimatedBuilder(
          animation: viewModel,
          builder: (context, _) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Stack(
                  children: [
                    _buildAlertDialog(
                      user,
                      viewModel,
                      fullNameController,
                      emailController,
                    ),
                    if (viewModel.editLoading) _buildLoadingIndicator(),
                  ],
                ),
              ),
            );
          },
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
    List<String> associatedIds = user.associatedTemples
        .map((temple) => temple.id)
        .toList();

    if (viewModel.selectedTempleIds.isEmpty) {
      viewModel.selectedTempleIds = List.from(associatedIds);
    }

    return StatefulBuilder(
      builder: (context, setStateSB) {
        final String currentRole = viewModel.role.text.isNotEmpty
            ? viewModel.role.text
            : user.role;

        final bool isAgentOrTemple =
            currentRole.toLowerCase() == 'agent' ||
            currentRole.toLowerCase() == 'temple';

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            StringConstant.editUser,
            style: AppTextStyles.loginTitleStyle.copyWith(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildTextField(fullNameController, "Full Name"),
                const SizedBox(height: 16),
                _buildTextField(emailController, "Email"),
                const SizedBox(height: 16),

                CommonDropdownField(
                  paddingSize: 0,
                  hintText: StringConstant.selectedRole,
                  labelText: StringConstant.role,
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
                          children: viewModel.templeList.map((temple) {
                            final String templeId = temple['id'];
                            final bool isSelected = viewModel.selectedTempleIds
                                .contains(templeId);

                            return CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                temple['name'] ?? '',
                                style: AppTextStyles.templeNameDetailsStyle,
                              ),
                              value: isSelected,
                              activeColor: ColorConstant.buttonColor,
                              onChanged: (bool? value) {
                                if (value == true) {
                                  viewModel.selectedTempleIds.add(templeId);
                                } else {
                                  viewModel.selectedTempleIds.remove(templeId);
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: viewModel.editLoading
                  ? null
                  : () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: AppTextStyles.buttonTextStyle.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: viewModel.editLoading
                  ? null
                  : () async {
                      final isActive = viewModel.getTempActive(user.id);
                      final selectedTemples = viewModel.selectedTempleIds;
                      await viewModel.editUser(
                        user.id,
                        fullNameController.text,
                        isActive,
                        selectedTemples: selectedTemples,
                      );
                      if (!viewModel.editLoading) Navigator.pop(context);
                    },
              child: Text(
                "Save",
                style: AppTextStyles.buttonTextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
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
        padding: const EdgeInsets.symmetric(vertical: 8),
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
