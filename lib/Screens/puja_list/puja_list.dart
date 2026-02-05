import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/expandable_text.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/puja_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/toggle_button.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/puja_arguments.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/login_model/createpuja/create_pujamodel.dart';

class PujaList extends StatefulWidget {
  const PujaList({super.key});

  @override
  State<PujaList> createState() => _PujaListState();
}

class _PujaListState extends State<PujaList> {
  final ScrollController _scrollController = ScrollController();
  bool isActive = false;

  late PujaListViewmodel viewmodel;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      viewmodel.language = prefs.getString('language') ?? 'en';
    });
  }

  @override
  void dispose() {
    viewmodel.reset();
    print("xcxvfgfdg");
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !viewmodel.isLoadingMore &&
        viewmodel.hasMorePujas &&
        !viewmodel.isLoading) {
      _loadMorePujas();
    }
  }

  Future<void> _loadMorePujas() async {
    await viewmodel.loadMorePujas();
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<PujaListViewmodel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async {
        await viewmodel.getTemples(reset: true);
        await viewmodel.fetchPujas(reset: true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(flex: 1, child: _buildTempleDropdown()),
                          ],
                        ),
                        if (viewmodel.pujaList.isEmpty && !viewmodel.isLoading)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 200),
                              Text(
                                "No Pujas Available",
                                style: TextStyle(fontFamily: font),
                              ),
                            ],
                          ),

                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                viewmodel.pujaList.length +
                                (viewmodel.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < viewmodel.pujaList.length) {
                                return listCard(viewmodel.pujaList[index]);
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (viewmodel.isLoading) Positioned.fill(child: _buildShimmer()),
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
            AppLocalizations.of(context)!.pujaList,
            style: AppTextStyles.appBarTitleStyle,
          ),
          const Spacer(),
          IconButton(
            iconSize: 20,
            onPressed: () {
              Navigator.pushNamed(
                context,
                StringsRoute.addPuja,
                arguments: PujaArguments(
                  puja_id: '',
                  puja_name: '',
                  description: '',
                  maximumNoOfDevotees: 0,
                  fee: 0,
                  booking_cutoff_notice: '',
                  allows_special_requirements: true,
                  from_date: '',
                  to_date: '',
                  days: [],
                  deities_name: [],
                  sample_images: [],
                  templeId: "",
                  timeSlots: [],
                  translations: [],
                  benefits: [],
                ),
              );
              viewmodel.reset();
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget listCard(PujaData puja) {
    List<String> formatTimeSlots(List<PujaTimeSlot> slots) {
      return slots.map((slot) {
        return "${slot.fromTime}-${slot.toTime}";
      }).toList();
    }

    String formatTimeRange(String fromTime, String toTime) {
      try {
        final from = DateFormat("HH:mm:ss").parse(fromTime);
        final to = DateFormat("HH:mm:ss").parse(toTime);
        final formattedFrom = DateFormat("hh:mm a").format(from);
        final formattedTo = DateFormat("hh:mm a").format(to);
        return "$formattedFrom - $formattedTo";
      } catch (e) {
        return "$fromTime - $toTime";
      }
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
                  pujatitleName(puja),
                  Spacer(),
                  SmallToggleSwitch(
                    value: puja.isActive ?? false,
                    onChanged: (bool value) {
                      Future(() async {
                        viewmodel.isToggling = true;
                        final success = await viewmodel.toggleActivate(
                          puja.id,
                          value,
                        );
                        viewmodel.isToggling = false;
                        if (success) {
                          setState(() => puja.isActive = value);
                        } else {
                          setState(() => puja.isActive = puja.isActive);
                        }
                      });
                    },
                  ),

                  editButton(puja),
                ],
              ),
              // isActiveTextWidget(isActive),
              buildDeities(puja),
              descriptionWidget(puja),
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
        padding: const EdgeInsets.all(14),
        child: ListView.separated(
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 140,
              margin: const EdgeInsets.symmetric(horizontal: 0),
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

  Widget pujatitleName(PujaData puja) {
    String nameToDisplay = puja.pujaName;

    if (viewmodel.language == "kn" &&
        puja.translations != null &&
        puja.translations!.isNotEmpty) {
      nameToDisplay = puja.translations!.first.pujaName;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
      child: SizedBox(
        width: 200,
        child: Text(
          nameToDisplay,
          maxLines: 2,
          style: AppTextStyles.welcomeStyle,
        ),
      ),
    );
  }

  Widget editButton(PujaData puja) {
    return IconButton(
      onPressed: () {
        print("Editing Puja: ${puja.sampleImages}");
        print("Editing Puja Translations: ${puja.translations}");
        Navigator.pushNamed(
          context,
          StringsRoute.addPuja,
          arguments: PujaArguments(
            puja_id: puja.id,
            puja_name: puja.pujaName,
            description: puja.description,
            maximumNoOfDevotees: puja.maximumNoOfDevotees,
            fee: double.parse(puja.fee),
            booking_cutoff_notice: puja.bookingCutoffNotice.toString(),
            allows_special_requirements: puja.allowsSpecialRequirements,
            from_date: puja.fromDate.toString(),
            to_date: puja.toDate.toString(),
            templeId: puja.templeId,
            days: puja.days.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toList(),
            deities_name: puja.deitiesName,
            sample_images: puja.sampleImages,
            timeSlots: puja.timeSlots,
            translations: puja.translations ?? [],
            benefits: puja.benefits ?? [],
          ),
        );
      },
      icon: Icon(Icons.edit),
    );
  }

  Widget buildDeities(PujaData puja) {
    // Extract names safely
    List<String> displayNames =
        (viewmodel.language == "kn" &&
            puja.translations != null &&
            puja.translations!.isNotEmpty)
        ? puja.translations!.first.deityNames ?? []
        : puja.deitiesName ?? [];

    // Remove any empty strings from the list
    final filteredNames = displayNames
        .where((name) => name.trim().isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${AppLocalizations.of(context)!.deitiesText}: ",
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: filteredNames.isNotEmpty ? filteredNames.join(', ') : '---',
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                // Optional: change color if it's '---'
                color: filteredNames.isNotEmpty ? null : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget descriptionWidget(PujaData puja) {
    String displayDescription =
        (viewmodel.language == "kn" &&
            puja.translations != null &&
            puja.translations!.isNotEmpty)
        ? (puja.translations!.first.description ?? "")
        : (puja.description ?? "");

    if (displayDescription.isEmpty) {
      displayDescription = "---";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 13, 0),
      child: ExpandableText(
        label: AppLocalizations.of(context)!.descriptionText,
        text: displayDescription,
        maxLines: 2,
        style: AppTextStyles.templeNameDetailsStyle,
      ),
    );
  }

  Widget _buildTempleDropdown() {
    return CommonDropdownField(
      selectedValue: viewmodel.selectedTemple,
      hintText: AppLocalizations.of(context)!.temple,
      labelText: AppLocalizations.of(context)!.temple,
      items: viewmodel.templeData.map((t) => t.name).toList(),
      paddingSize: 16,
      isLoadingMore: viewmodel.isFetchingNextPage,
      onLoadMore: () {
        print("Load more temples called");
        if (!viewmodel.isFetchingNextPage && viewmodel.hasNextPage) {
          viewmodel.getTemples(reset: false);
        }
      },
      onChanged: (value) {
        final idx = viewmodel.templeData.indexWhere(
          (temple) => temple.name == value,
        );
        if (idx != -1) {
          final selectedTemple = viewmodel.templeData[idx];
          viewmodel.selectedTemple = selectedTemple.name;
          viewmodel.templeId = selectedTemple.id;
          viewmodel.fetchPujas(reset: true);
        }
      },
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
                  text: AppLocalizations.of(context)!.from,
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
                  text: AppLocalizations.of(context)!.to,
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
        isActive
            ? AppLocalizations.of(context)!.active
            : AppLocalizations.of(context)!.inActive,
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
                  text: AppLocalizations.of(context)!.fee,
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
                  text: AppLocalizations.of(context)!.maxDevotee,
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

    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(8, 0, 0, 0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: allDays.map((day) {
          final isActive = activeDays.contains(day);

          return AnimatedContainer(
            width: 30,
            height: 30,
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: isActive
                  ? ColorConstant.buttonColor
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isActive
                    ? ColorConstant.buttonColor
                    : Colors.grey.shade400,
              ),
            ),
            child: Text(
              day.substring(0, 1),
              style: TextStyle(
                fontSize: 12,
                fontFamily: font,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.black87,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget availableDaysText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
      child: Text(
        AppLocalizations.of(context)!.availableDays,
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
        AppLocalizations.of(context)!.availableslot,
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
          AppLocalizations.of(context)!.viewImg,
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
          AppLocalizations.of(context)!.noAvailableSlot,
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
          final parts = time.split('-');
          String formatted = time;
          if (parts.length == 2) {
            formatted = formatTimeRange(parts[0], parts[1]);
          }

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              color: ColorConstant.buttonColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: ColorConstant.buttonColor, width: 1),
            ),
            child: Text(
              formatted,
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

  String formatTimeRange(String fromTime, String toTime) {
    try {
      final from = DateFormat("HH:mm:ss").parse(fromTime);
      final to = DateFormat("HH:mm:ss").parse(toTime);
      final formattedFrom = DateFormat("hh:mm a").format(from);
      final formattedTo = DateFormat("hh:mm a").format(to);
      return "$formattedFrom - $formattedTo";
    } catch (e) {
      return "$fromTime - $toTime";
    }
  }
}
