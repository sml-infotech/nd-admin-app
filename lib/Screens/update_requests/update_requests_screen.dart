import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/update_requests/update_request_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_request_templemodel/update_request_temple_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class UpdateRequests extends StatefulWidget {
  const UpdateRequests({super.key});

  @override
  State<UpdateRequests> createState() => _UpdateRequestsState();
}

class _UpdateRequestsState extends State<UpdateRequests> {
  late UpdateRequestViewModel viewmodel;
  final ScrollController _scrollController = ScrollController();
  String? _token;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
    _role = prefs.getString('userRole');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewmodel = Provider.of<UpdateRequestViewModel>(context, listen: false);

    // Fetch data initially
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_role != null) {
        viewmodel.setUserRole(_role!);
      }
      await viewmodel.fetchUpdateRequests(reset: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !viewmodel.isLoadingMore &&
          viewmodel.hasMore) {
        viewmodel.fetchUpdateRequests();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    viewmodel.reset();
    viewmodel.expandedIndex = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateRequestViewModel>(
      builder: (context, vm, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        List<TempleRequest> visibleRequests = [];
        if (_role == "Super Admin" || _role == "Admin") {
          visibleRequests = vm.requests
              .where(
                (r) =>
                    r.status != 'PartiallyReviewed' && r.status != 'Completed',
              )
              .toList();
        } else {
          visibleRequests = vm.requests.toList();
        }

        return FocusDetector(
          onFocusGained: () async {
            await vm.fetchUpdateRequests(reset: true);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(context),
            body: Stack(
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
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: vm.isLoading
                            ? _buildShimmer()
                            : visibleRequests.isNotEmpty
                            ? RefreshIndicator(
                                color: ColorConstant.buttonColor,
                                onRefresh: () =>
                                    vm.fetchUpdateRequests(reset: true),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(16),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount:
                                      visibleRequests.length +
                                      (vm.isLoadingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index < visibleRequests.length) {
                                      final originalIndex = vm.requests.indexOf(
                                        visibleRequests[index],
                                      );
                                      return _buildUpdateRequestCard(
                                        vm,
                                        originalIndex,
                                      );
                                    } else {
                                      return _buildLoadingMoreIndicator();
                                    }
                                  },
                                ),
                              )
                            : Container(
                                child: Center(
                                  child: Text(
                                    "No Requests Found",
                                    style: TextStyle(fontFamily: font),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                if (vm.isLoadingForApproval)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorConstant.buttonColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorConstant.buttonColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: Image.asset(ImageStrings.backbutton),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.updateRequests,
            style: AppTextStyles.appBarTitleStyle,
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator(color: Colors.grey)),
    );
  }

  Widget _buildUpdateRequestCard(UpdateRequestViewModel vm, int index) {
    final request = vm.requests[index];
    final isExpanded = vm.expandedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(
            AppLocalizations.of(context)!.templeName,
            request.templeDetails.name,
          ),
          _infoRow(
            AppLocalizations.of(context)!.email,
            request.templeDetails.email,
          ),
          _infoRow(
            AppLocalizations.of(context)!.address,
            request.templeDetails.address,
          ),
          _infoRow(
            AppLocalizations.of(context)!.pincode,
            request.templeDetails.pincode,
          ),
          _infoRow(AppLocalizations.of(context)!.status, request.status),
          if (_role == "Temple") ...[
            if (request.reviewStatus != null) ...[
              Text(
                "Review Status",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: font,
                ),
              ),
              const SizedBox(height: 8),
              _buildReviewStatusSection(request.reviewStatus!),
            ],
          ],
          if (_role == "Super Admin" || _role == "Admin")
            _expandSection(vm, isExpanded, index, request),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: subtitle == "Completed"
                    ? Colors.green
                    : subtitle == "Pending"
                    ? Colors.red
                    : Colors.black,
                fontFamily: font,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expandSection(
    UpdateRequestViewModel vm,
    bool isExpanded,
    int index,
    TempleRequest request,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              vm.expandedIndex = isExpanded ? null : index;
            });
          },
          child: Text(
            isExpanded
                ? AppLocalizations.of(context)!.hideDetails
                : AppLocalizations.of(context)!.viewAndApprove,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 16),
          _buildDataSection(vm, request, index),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildDataSection(
    UpdateRequestViewModel vm,
    TempleRequest request,
    int requestIndex,
  ) {
    final previousData = Map.fromEntries(
      request.templeDetails.toJson().entries.where(
        (e) => request.changes.keys.contains(e.key),
      ),
    );
    final changedData = Map.fromEntries(
      request.changes.entries.where(
        (e) => request.templeDetails.toJson().keys.contains(e.key),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...previousData.entries.map((entry) {
          final key = entry.key;
          final oldValue = entry.value?.toString() ?? '';
          final newValue = changedData[key]?.toString() ?? '';
          final reason = vm.rejectedReasons[requestIndex]?[key];
          final bool isRejected = reason != null;
          final bool isApproved =
              vm.approvedFields[requestIndex]?.contains(key) ?? false;

          return _buildFieldComparison(
            vm,
            key,
            oldValue,
            newValue,
            isApproved,
            isRejected,
            requestIndex,
          );
        }),
        const SizedBox(height: 16),
        _buildGlobalReasonSection(vm, requestIndex),
      ],
    );
  }

  Widget _buildFieldComparison(
    UpdateRequestViewModel vm,
    String key,
    String oldValue,
    String newValue,
    bool isApproved,
    bool isRejected,
    int requestIndex,
  ) {
    final bool isImageField = key.toLowerCase().contains('image');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppLocalizations.of(context)!.currentStatus} $key",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            isImageField
                ? _buildImageSection(_formatValue(oldValue))
                : _dataBox(_formatValue(oldValue), const Color(0xFFECCBDD)),
            const SizedBox(height: 8),
            Text(
              "${AppLocalizations.of(context)!.requested} $key",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            isImageField
                ? _buildImageSection(_formatValue(newValue))
                : _dataBox(_formatValue(newValue), Colors.greenAccent.shade100),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _approveCheckbox(vm, isApproved, requestIndex, key),
                const SizedBox(width: 12),
                _rejectCheckbox(vm, isRejected, requestIndex, key),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataBox(String value, Color color) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.only(top: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: Text(
      value.isEmpty ? '-' : value,
      style: const TextStyle(fontSize: 14),
    ),
  );

  Widget _approveCheckbox(
    UpdateRequestViewModel vm,
    bool isApproved,
    int requestIndex,
    String key,
  ) {
    return Row(
      children: [
        Checkbox(
          value: isApproved,
          activeColor: Colors.greenAccent,
          onChanged: (value) {
            setState(() {
              vm.approvedFields[requestIndex] ??= {};
              if (value == true) {
                vm.approvedFields[requestIndex]!.add(key);
                vm.rejectedReasons[requestIndex]?.remove(key);
              } else {
                vm.approvedFields[requestIndex]!.remove(key);
              }
            });
          },
        ),
         Text(AppLocalizations.of(context)!.approve),
      ],
    );
  }

  Widget _rejectCheckbox(
    UpdateRequestViewModel vm,
    bool isRejected,
    int requestIndex,
    String key,
  ) {
    return Row(
      children: [
        Checkbox(
          value: isRejected,
          activeColor: Colors.redAccent,
          onChanged: (value) {
            setState(() {
              vm.rejectedReasons[requestIndex] ??= {};
              if (value == true) {
                vm.rejectedReasons[requestIndex]![key] = "";
                vm.approvedFields[requestIndex]?.remove(key);
              } else {
                setState(() {
                  vm.rejectedReasons[requestIndex]?.remove(key);
                });
              }
            });
          },
        ),
         Text(AppLocalizations.of(context)!.reject),
      ],
    );
  }

  Widget _buildGlobalReasonSection(
    UpdateRequestViewModel vm,
    int requestIndex,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (vm.rejectedReasons[requestIndex]?.isNotEmpty ?? false) ...[
           Text(
            AppLocalizations.of(context)!.rejectionComment,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4, right: 8),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  vm.rejectedReasons[requestIndex]!["global_reason"] = val;
                });
              },
              maxLines: 3,
              decoration:  InputDecoration(
                hintText: AppLocalizations.of(context)!.reason,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _submitAllButton(vm),
            SizedBox(height: 10),
            _cancelButton(vm),
          ],
        ),
      ],
    );
  }

  Widget _cancelButton(UpdateRequestViewModel vm) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            vm.expandedIndex = null;
          });
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        child: Text(
          AppLocalizations.of(context)!.cancel,
          style: TextStyle(color: Colors.black, fontFamily: font),
        ),
      ),
    );
  }

  Widget _submitAllButton(UpdateRequestViewModel vm) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (!_validateBeforeSubmit(vm)) {
            Fluttertoast.showToast(
              msg:
                  "Please approve or reject all changed fields before submitting.",
              backgroundColor: Colors.red,
            );
            return;
          }

          await vm.approvalTempleUpdate(
            vm.requests[vm.expandedIndex!].id,
            vm.expandedIndex!,
          );

          if (vm.isUpdated) {
            Fluttertoast.showToast(
              msg: vm.message.isNotEmpty
                  ? vm.message
                  : "Update approved successfully",
              backgroundColor: Colors.green,
            );
            vm.expandedIndex = null;
            await vm.fetchUpdateRequests(reset: true);
          } else {
            Fluttertoast.showToast(msg: vm.message);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonColor,
        ),
        child: Text(
          AppLocalizations.of(context)!.submitAllApprovals,
          style: TextStyle(color: Colors.white, fontFamily: font),
        ),
      ),
    );
  }

  bool _validateBeforeSubmit(UpdateRequestViewModel vm) {
    final int? requestIndex = vm.expandedIndex;
    if (requestIndex == null) return false;

    final request = vm.requests[requestIndex];
    final changedData = request.changes;
    final approved = vm.approvedFields[requestIndex] ?? {};
    final rejected = vm.rejectedReasons[requestIndex] ?? {};
    final allChangedKeys = changedData.keys.toList();
    final allMarkedKeys = {
      ...approved,
      ...rejected.keys.where((k) => k != "global_reason"),
    };

    return allChangedKeys.every(allMarkedKeys.contains);
  }

  Widget _buildImageSection(String imageUrl) {
    final imageUrls = imageUrl
        .split(',')
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList();

    if (imageUrls.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "No images available",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final img = imageUrls[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                img,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.red, size: 40),
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is List) return value.join(', ');
    if (value is Map)
      return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    return value.toString().replaceAll('[', '').replaceAll(']', '').trim();
  }

  Widget _buildReviewStatusSection(Map<String, dynamic> reviewStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviewStatus.entries.map((entry) {
        final key = entry.key;
        final value = entry.value.toString();

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  key[0].toUpperCase() + key.substring(1),
                  style: TextStyle(
                    fontFamily: font,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 14,
                    color: value == "Approved"
                        ? Colors.green
                        : value == "Rejected"
                        ? Colors.red
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
