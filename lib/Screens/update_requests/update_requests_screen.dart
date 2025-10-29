import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class UpdateRequests extends StatefulWidget {
  const UpdateRequests({super.key});

  @override
  State<UpdateRequests> createState() => _UpdateRequestsState();
}

class _UpdateRequestsState extends State<UpdateRequests> {
  final List<Map<String, dynamic>> requests = [
    {
      "templeName": "Sri Murugan Temple",
      "email": "temple@gmail.com",
      "address": "Maruthamalai Temple, Near Vellode",
      "pincode": "638112",
      "previousData": {
        "city": "Coimbatore",
        "state": "Tamil Nadu",
        "phone_number": "9876543210",
        "description": "Old temple data example",
      },
      "changesData": {
        "city": "Erode",
        "state": "Tamil Nadu",
        "phone_number": "9999999999",
        "description":
            "Updated temple d vbnhnnlkmnhlknlkghhnkghlkkmnlkghnklnfghkln knlfghknlkfghfgh klnfghngfhata exampl e",
      },
    },
  ];

  int? expandedIndex;

  /// Track rejected fields and reasons for each request
  final Map<int, Map<String, String>> rejectedReasons = {};

  /// ✅ Track approved fields for each request
  final Map<int, Set<String>> approvedFields = {};

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: _buildAppBar(),
      body: Column(
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
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(
                      requests.length,
                      (index) => _buildUpdateRequestCard(index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
    final request = requests[index];
    final isExpanded = expandedIndex == index;

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
              request["templeName"],
            ),
            commonTitleAndSubtitle(
              "${StringConstant.email}: ",
              request["email"],
            ),
            commonTitleAndSubtitle(
              "${StringConstant.address}: ",
              request["address"],
            ),
            commonTitleAndSubtitle(
              "${StringConstant.pincode}: ",
              request["pincode"],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              child: Text(
                isExpanded ? "Hide Details" : "View & Approve",
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
                "Previous Data",
                request["previousData"],
                isChangeSection: false,
              ),
              const SizedBox(height: 12),
              _buildDataSection(
                "Changes Data",
                request["changesData"],
                requestIndex: index,
                isChangeSection: true,
              ),
            ],
          ],
        ),
      ),
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

            final reason = rejectedReasons[requestIndex]?[key];
            final bool isRejected = reason != null;
            final bool isApproved =
                approvedFields[requestIndex]?.contains(key) ?? false;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "$key : $value",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: font,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (isChangeSection)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  approvedFields[requestIndex!] ??= {};
                                  if (isApproved) {
                                    approvedFields[requestIndex]!.remove(key);
                                  } else {
                                    approvedFields[requestIndex]!.add(key);
                                  }
                                  rejectedReasons[requestIndex]?.remove(key);
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
                            ),

                            const SizedBox(width: 8),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  rejectedReasons[requestIndex ?? 0] ??= {};
                                  if (isRejected) {
                                    rejectedReasons[requestIndex]!.remove(key);
                                  } else {
                                    rejectedReasons[requestIndex]![key] = "";
                                    approvedFields[requestIndex]?.remove(key);
                                  }
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                color: isRejected ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  if (isRejected)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4, right: 8),
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              rejectedReasons[requestIndex]![key] = val;
                            });
                          },
                          style: TextStyle(fontSize: 13, fontFamily: font),
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            hintText: "Reason",
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
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
