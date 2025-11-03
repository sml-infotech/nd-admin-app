import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/update_requests/update_request_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_request_templemodel/update_request_temple_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UpdateRequests extends StatefulWidget {
  const UpdateRequests({super.key});

  @override
  State<UpdateRequests> createState() => _UpdateRequestsState();
}

class _UpdateRequestsState extends State<UpdateRequests> {
  late UpdateRequestViewModel viewmodel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

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
    super.dispose();
    viewmodel.reset();
    viewmodel.expandedIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<UpdateRequestViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async {
        await viewmodel.fetchUpdateRequests(reset: true);
      },
      child: Scaffold(
        backgroundColor: ColorConstant.buttonColor,
        appBar: _buildAppBar(),
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
                    child: viewmodel.isLoading
                        ? _buildShimmer()
                        : RefreshIndicator(
                            onRefresh: () =>
                                viewmodel.fetchUpdateRequests(reset: true),
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount:
                                  viewmodel.requests.length +
                                  (viewmodel.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < viewmodel.requests.length) {
                                  final request = viewmodel.requests[index];

                                  return request.status == 'PartiallyReviewed'||
                                          request.status == 'Completed'
                                      ?  SizedBox.shrink()
                                      :_buildUpdateRequestCard(index)  ;
                                } else {
                                  return _buildLoadingMoreIndicator();
                                }
                              },
                            ),
                          ),
                  ),
                ),
              ],
            ),
            if (viewmodel.isLoadingForApproval)
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
  }

  AppBar _buildAppBar() {
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
            StringConstant.updateRequests,
            style: AppTextStyles.appBarTitleStyle,
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
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

  Widget _buildUpdateRequestCard(int index) {
    final request = viewmodel.requests[index];
    final isExpanded = viewmodel.expandedIndex == index;

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
          _infoRow(StringConstant.templeName, request.templeDetails.name),
          _infoRow(StringConstant.email, request.templeDetails.email),
          _infoRow(StringConstant.addresss, request.templeDetails.address),
          _infoRow(StringConstant.pincode, request.templeDetails.pincode),
          const SizedBox(height: 8),
          _expandSection(isExpanded, index, request),
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
              style: AppTextStyles.templeNameDetailsStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _expandSection(bool isExpanded, int index, TempleRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              viewmodel.expandedIndex = isExpanded ? null : index;
            });
          },
          child: Text(
            isExpanded
                ? StringConstant.hideDetails
                : StringConstant.viewAndApprove,
            style: TextStyle(
              color: Colors.blue,
              fontFamily: font,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 16),
          _buildDataSection(
            Map.fromEntries(
              request.templeDetails.toJson().entries.where(
                (e) => request.changes.keys.contains(e.key),
              ),
            ),
            changedData: Map.fromEntries(
              request.changes.entries.where(
                (e) => request.templeDetails.toJson().keys.contains(e.key),
              ),
            ),
            requestIndex: index,
            isExpanded: isExpanded,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildDataSection(
    Map<String, dynamic> previousData, {
    required Map<String, dynamic> changedData,
    required int requestIndex,
    bool isExpanded = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...previousData.entries.map((entry) {
          final key = entry.key;
          final oldValue = entry.value?.toString() ?? '';
          final newValue = changedData[key]?.toString() ?? '';
          final reason = viewmodel.rejectedReasons[requestIndex]?[key];
          final bool isRejected = reason != null;
          final bool isApproved =
              viewmodel.approvedFields[requestIndex]?.contains(key) ?? false;

          return _buildFieldComparison(
            key,
            oldValue,
            newValue,
            isApproved,
            isRejected,
            requestIndex,
          );
        }),
        const SizedBox(height: 16),
        _buildGlobalReasonSection(requestIndex, isExpanded: isExpanded),
      ],
    );
  }

  Widget _buildFieldComparison(
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
            _dataLabel("${StringConstant.current} $key"),
            isImageField
                ? _buildImageSection(_formatValue(oldValue))
                : _dataBox(_formatValue(oldValue), const Color(0xFFECCBDD)),

            const SizedBox(height: 8),

            _dataLabel("${StringConstant.requested} $key"),
            isImageField
                ? _buildImageSection(_formatValue(newValue))
                : _dataBox(_formatValue(newValue), Colors.greenAccent.shade100),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _approveCheckbox(isApproved, requestIndex, key),
                const SizedBox(width: 12),
                _rejectCheckbox(isRejected, requestIndex, key),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataLabel(String label) => Text(
    label,
    style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: font),
  );

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
      style: TextStyle(fontSize: 14, fontFamily: font),
    ),
  );

  Widget _approveCheckbox(bool isApproved, int requestIndex, String key) {
    return Row(
      children: [
        Checkbox(
          value: isApproved,
          checkColor: Colors.white,
          activeColor: Colors.greenAccent,
          onChanged: (value) {
            setState(() {
              viewmodel.approvedFields[requestIndex] ??= {};
              if (value == true) {
                viewmodel.approvedFields[requestIndex]!.add(key);
                viewmodel.rejectedReasons[requestIndex]?.remove(key);
              } else {
                viewmodel.approvedFields[requestIndex]!.remove(key);
              }
            });
          },
        ),
        Text(
          StringConstant.approve,
          style: TextStyle(fontSize: 14, fontFamily: font),
        ),
      ],
    );
  }

  Widget _rejectCheckbox(bool isRejected, int requestIndex, String key) {
    return Row(
      children: [
        Checkbox(
          value: isRejected,
          checkColor: Colors.white,
          activeColor: Colors.redAccent,
          onChanged: (value) {
            setState(() {
              viewmodel.rejectedReasons[requestIndex] ??= {};
              if (value == true) {
                viewmodel.rejectedReasons[requestIndex]![key] = "";
                viewmodel.approvedFields[requestIndex]?.remove(key);
              } else {
                viewmodel.rejectedReasons[requestIndex]?.remove(key);
              }
            });
          },
        ),
        Text(
          StringConstant.reject,
          style: TextStyle(fontSize: 14, fontFamily: font),
        ),
      ],
    );
  }

  Widget _buildGlobalReasonSection(int requestIndex, {bool isExpanded = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          StringConstant.rejectionComment,
          style: TextStyle(
            fontSize: 14,
            fontFamily: font,
            fontWeight: FontWeight.w600,
          ),
        ),
        _reasonTextField(requestIndex),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _cancelButton(isExpanded),
            const SizedBox(width: 10),
            _submitAllButton(),
          ],
        ),
      ],
    );
  }

  Widget _reasonTextField(int requestIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4, right: 8),
      child: TextField(
        onChanged: (val) {
          setState(() {
            viewmodel.rejectedReasons[requestIndex]!["global_reason"] = val;
          });
        },
        style: TextStyle(fontSize: 13, fontFamily: font),
        cursorColor: Colors.blue,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: StringConstant.reason,
          hintStyle: TextStyle(fontSize: 12, fontFamily: font),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(String imageUrl) {
    final List<String> imageUrls = imageUrl
        .split(',')
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList();

    if (imageUrls.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: const Text(
          "No images available",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final image = imageUrls[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.red, size: 40),
                loadingBuilder: (context, child, loadingProgress) {
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

  Widget _cancelButton(bool isExpanded) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            viewmodel.expandedIndex = isExpanded ? null : -1;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        child: Text(
          StringConstant.cancel,
          style: TextStyle(fontSize: 14, fontFamily: font, color: Colors.white),
        ),
      ),
    );
  }

  Widget _submitAllButton() {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: () async {
          final bool isValid = _validateBeforeSubmit();

          if (!isValid) {
            Fluttertoast.showToast(
              msg:
                  "Please approve or reject all changed fields before submitting.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return;
          }

          await viewmodel.approvalTempleUpdate(
            viewmodel.requests[viewmodel.expandedIndex!].id,
            viewmodel.expandedIndex ?? 0,
          );

          if (viewmodel.isUpdated) {
            Fluttertoast.showToast(
              msg: viewmodel.message.isNotEmpty
                  ? viewmodel.message
                  : "Update approved successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            viewmodel.expandedIndex = null;
            await viewmodel.fetchUpdateRequests(reset: true);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        child: Text(
          StringConstant.submitAllApprovals,
          style: TextStyle(fontSize: 14, fontFamily: font, color: Colors.white),
        ),
      ),
    );
  }

  bool _validateBeforeSubmit() {
    final int? requestIndex = viewmodel.expandedIndex;
    if (requestIndex == null) return false;

    final request = viewmodel.requests[requestIndex];
    final Map<String, dynamic> changedData = request.changes;

    final approved = viewmodel.approvedFields[requestIndex] ?? {};
    final rejected = viewmodel.rejectedReasons[requestIndex] ?? {};
    final allChangedKeys = changedData.keys.toList();
    final allMarkedKeys = {
      ...approved,
      ...rejected.keys.where((key) => key != "global_reason"),
    };
    return allChangedKeys.every(allMarkedKeys.contains);
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is List) return value.join(', ');
    if (value is Map) {
      return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    }
    return value.toString().replaceAll('[', '').replaceAll(']', '').trim();
  }
}
