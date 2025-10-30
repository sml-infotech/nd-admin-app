import 'package:flutter/material.dart';
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
                              itemCount: viewmodel.requests.length +
                                  (viewmodel.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < viewmodel.requests.length) {
                                  return _buildUpdateRequestCard(index);
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
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator(color: Colors.grey,)),
    );
  }


  Widget _buildShimmer() {
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
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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

  Widget _buildUpdateRequestCard(int index) {
    final request = viewmodel.requests[index];
    final isExpanded = viewmodel.expandedIndex == index;

    return AnimatedContainer(
      width: double.infinity,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonTitleAndSubtitle(
              "${StringConstant.templeName}: ",
              request.templeDetails.name,
            ),
            commonTitleAndSubtitle(
              "${StringConstant.email}: ",
              request.templeDetails.email,
            ),
            commonTitleAndSubtitle(
              "${StringConstant.address}: ",
              request.templeDetails.address,
            ),
            commonTitleAndSubtitle(
              "${StringConstant.pincode}: ",
              request.templeDetails.pincode,
            ),
            const SizedBox(height: 8),
            expandWidgets(isExpanded, index, request),
          ],
        ),
      ),
    );
  }

  Widget expandWidgets(bool isExpanded, int index, TempleRequest request) {
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
            StringConstant.previousData,
            Map.fromEntries(
              request.templeDetails.toJson().entries.where(
                (e) => request.changes.keys.contains(e.key),
              ),
            ),
            isChangeSection: false,
          ),
          const SizedBox(height: 12),
          _buildDataSection(
            StringConstant.changesData,
            request.changes,
            requestIndex: index,
            isChangeSection: true,
          ),
        ],
      ],
    );
  }

  Widget commonTitleAndSubtitle(String title, String subTitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: subTitle,
              style: AppTextStyles.templeNameDetailsStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(
    String title,
    Map<String, dynamic> data, {
    bool isChangeSection = false,
    int? requestIndex,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: title == "Previous Data"
            ? Colors.grey.shade100
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: title == "Previous Data"
              ? Colors.grey.shade400
              : Colors.blue.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: font,
            ),
          ),
          const SizedBox(height: 4),

          ...data.entries.map((entry) {
            final key = entry.key;
            final value = entry.value.toString();

            final reason = viewmodel.rejectedReasons[requestIndex]?[key];
            final bool isRejected = reason != null;
            final bool isApproved =
                viewmodel.approvedFields[requestIndex]?.contains(key) ?? false;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(key, value),
                      if (isChangeSection)
                        Row(
                          children: [
                            approveFields(isApproved, requestIndex, key),

                            const SizedBox(width: 8),
                            rejectFields(isRejected,requestIndex,key),
                          ],
                        ),
                    ],
                  ),

                  if (isRejected)
                  reasonTextField(requestIndex,key),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget titleText(String key, String value) {
    return Expanded(
      child: Text(
        "$key : ${value.replaceAll('[', '').replaceAll(']', '')}",
        style: TextStyle(fontSize: 14, fontFamily: font, color: Colors.black87),
      ),
    );
  }

  Widget approveFields(bool isApproved, int? requestIndex, String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          viewmodel.approvedFields[requestIndex!] ??= {};
          if (isApproved) {
            viewmodel.approvedFields[requestIndex]!.remove(key);
          } else {
            viewmodel.approvedFields[requestIndex]!.add(key);
          }
          viewmodel.rejectedReasons[requestIndex]?.remove(key);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Approved change for $key ✅"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Icon(
        Icons.check_circle,
        color: isApproved ? Colors.green : Colors.grey,
        size: 22,
      ),
    );
  }


  
  Widget rejectFields(bool isRejected,int? requestIndex,String key){
    return 
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  viewmodel.rejectedReasons[requestIndex ??
                                          0] ??=
                                      {};
                                  if (isRejected) {
                                    viewmodel.rejectedReasons[requestIndex]!
                                        .remove(key);
                                  } else {
                                    viewmodel
                                            .rejectedReasons[requestIndex]![key] =
                                        "";
                                    viewmodel.approvedFields[requestIndex]
                                        ?.remove(key);
                                  }
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                color: isRejected ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                            );
  }

  Widget reasonTextField(int ?requestIndex,String key){
    return   Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4, right: 8),
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              viewmodel.rejectedReasons[requestIndex]![key] =
                                  val;
                            });
                          },
                          style: TextStyle(fontSize: 13, fontFamily: font),
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            hintText: StringConstant.reason,
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontFamily: font,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1.6,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    );
  }
}
