import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/expandable_text.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/puja_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/toggle_button.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PujaList extends StatefulWidget {
  const PujaList({super.key});

  @override
  State<PujaList> createState() => _PujaListState();
}

class _PujaListState extends State<PujaList> {
  bool isActive = false;
  late PujaListViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<PujaListViewmodel>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    return FocusDetector(
      onFocusGained: () async {
        await viewmodel.getTemples();
        await viewmodel.fetchPujas(templeId: viewmodel.templeId);
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
                    constraints: BoxConstraints(
                      minHeight: screenHeight - kToolbarHeight,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),

                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 15),

                          Row(
                            children: [
                              _buildTempleDropdown(),
                              Expanded(
                                child: IconButton(
                                  iconSize: 20,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      StringsRoute.addPuja,
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                          Column(children: _buildPujaList()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (viewmodel.isLoading) Center(child: _buildShimmer()),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPujaList() {
    if (viewmodel.isLoading) {
      return [];
    }
    if (viewmodel.pujaList.isEmpty) {
      return [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 300),
            Text(
              StringConstant.noPujaAvailable,
              style: TextStyle(fontFamily: font),
            ),
          ],
        ),
      ];
    }
    return viewmodel.pujaList.map((puja) => listCard(puja)).toList();
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
          Text(StringConstant.pujaList, style: AppTextStyles.appBarTitleStyle),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget listCard(PujaData puja) {
    List<String> formatTimeSlots(List<TimeSlot> slots) {
      return slots.map((slot) {
        return "${slot.fromTime} → ${slot.toTime}";
      }).toList();
    }

    final formattedTimes = formatTimeSlots(puja.timeSlots);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  pujatitleName(puja.pujaName),
                  Spacer(),
                  SmallToggleSwitch(
                    onChanged: (bool value) {
                      print(value);
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                  editButton(),
                ],
              ),
              isActiveTextWidget(isActive),
              deitiesName(puja.deitiesName),
              descriptionWidget(puja.description),
              SizedBox(height: 8),
              fromAndToWidget(
                fromDate:
                    "${puja.fromDate.day.toString().padLeft(2, '0')}/${puja.fromDate.month.toString().padLeft(2, '0')}/${puja.fromDate.year}",
                toDate:
                    "${puja.toDate.day.toString().padLeft(2, '0')}/${puja.toDate.month.toString().padLeft(2, '0')}/${puja.toDate.year}",
              ),
              SizedBox(height: 8),
              feesAndMaxDevotees(
                fee: puja.fee,
                maxDevotee: "${puja.maximumNoOfDevotees}",
              ),
              SizedBox(height: 8),
              availableDaysText(),
              SizedBox(height: 8),
              availableDays(
                activeDays: puja.days.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList(),
              ),
              SizedBox(height: 8),
              availableTimeSlotsTitle(),
              SizedBox(height: 8),
              availableTimeSlots(activeTimes: formattedTimes),
              SizedBox(height: 6),
              if (puja.sampleImages.isNotEmpty)
                viewImageWidget(imageUrls: puja.sampleImages, context: context),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(0, 100, 0, 0),
      child: Container(
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
      ),
    );
  }

  Widget pujatitleName(String pujaName) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(12, 8, 0, 0),
      child: SizedBox(
        width: 200,
        child: Text(pujaName, maxLines: 2, style: AppTextStyles.welcomeStyle),
      ),
    );
  }

  Widget editButton() {
    return IconButton(onPressed: () {}, icon: Icon(Icons.edit));
  }

  Widget deitiesName(List<String> deitiesName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: StringConstant.deitiesText,
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: deitiesName.join(', '),
              style: AppTextStyles.templeNameDetailsStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget descriptionWidget(String desscription) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 13, 0),
      child: ExpandableText(
        label: StringConstant.descriptionText,
        text: desscription,
        maxLines: 2,
        style: AppTextStyles.templeNameDetailsStyle,
      ),
    );
  }

  Widget _buildTempleDropdown() {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 350,
        child: CommonDropdownField(
          selectedValue: viewmodel.selectedTemple,
          hintText: StringConstant.temple,
          labelText: StringConstant.temple,
          items: viewmodel.templeData.map((t) => t.name).toList(),
          paddingSize: 16,
          onChanged: (value) {
            final idx = viewmodel.templeData.indexWhere(
              (temple) => temple.name == value,
            );
            if (idx != -1) {
              final selectedTemple = viewmodel.templeData[idx];
              viewmodel.selectedTemple = selectedTemple.name;
              viewmodel.fetchPujas(templeId: selectedTemple.id);
            }
          },
        ),
      ),
    );
  }

  Widget fromAndToWidget({required String fromDate, required String toDate}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: StringConstant.from,
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: fromDate,
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: StringConstant.to,
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: toDate,
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget isActiveTextWidget(bool isActive) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: Text(
        isActive ? StringConstant.active : StringConstant.inActive,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontFamily: font,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget feesAndMaxDevotees({required String fee, required String maxDevotee}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: StringConstant.fee,
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "₹$fee",
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: StringConstant.maxDevotee,
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: maxDevotee,
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget availableDays({required List<String> activeDays}) {
    final allDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: allDays.map((day) {
        final isActive = activeDays.contains(day);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isActive ? ColorConstant.buttonColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: isActive
                  ? ColorConstant.buttonColor
                  : Colors.grey.shade400,
              width: 1,
            ),
          ),
          child: Text(
            day.substring(0, 3),
            style: TextStyle(
              fontSize: 11,
              fontFamily: font,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget availableDaysText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
      child: Text(
        StringConstant.availableDays,
        style: AppTextStyles.templeNameDetailsStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget availableTimeSlotsTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
      child: Text(
        StringConstant.availableslot,
        style: AppTextStyles.templeNameDetailsStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget viewImageWidget({
    required List<String> imageUrls,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        if (imageUrls.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 12),
                      SizedBox(
                        height: 400,
                        child: PageView.builder(
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("No images available")));
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
        child: Text(
          StringConstant.viewImg,
          style: AppTextStyles.templeNameDetailsStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstant.buttonColor,
          ),
        ),
      ),
    );
  }

  Widget availableTimeSlots({required List<String> activeTimes}) {
    if (activeTimes.isEmpty) {
      return Center(
        child: Text(
          StringConstant.noAvailableSlot,
          style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: font),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children: activeTimes.map((time) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              color: ColorConstant.buttonColor,
              borderRadius: BorderRadius.circular(0),
              border: Border.all(color: ColorConstant.buttonColor, width: 1),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 11,
                fontFamily: font,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
