import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/create_festival/festival_list_modal.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nammadaiva_dashboard/Screens/festivals/create_festival_viewmodel.dart';

class FestivalListScreen extends StatefulWidget {
  const FestivalListScreen({super.key});

  @override
  State<FestivalListScreen> createState() => _FestivalListScreenState();
}

class _FestivalListScreenState extends State<FestivalListScreen> {
  late CreateFestivalViewmodel _viewmodel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener to trigger pagination
  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_viewmodel.isLoading &&
        !_viewmodel.isLoadingMore &&
        _viewmodel.hasMoreFestivals) {
      // Load more data if conditions are met
      _loadMoreData();
    }
  }

  // Function to load more data
  Future<void> _loadMoreData() async {
    await _viewmodel.fetchFestivals();
  }

  @override
  Widget build(BuildContext context) {
    _viewmodel = Provider.of<CreateFestivalViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaAppBar(),
      ),
      body: Stack(
        children: [
          FocusDetector(
            onFocusGained: () {
              _viewmodel.fetchFestivals(
                reset: true,
              ); // Reload festivals when focus is gained
            },
            child: Column(
              children: [
                if (_viewmodel.isLoading)
                  Expanded(child: _buildShimmer())
                else
                  Expanded(child: _buildFestivalList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.separated(
        itemCount: 6, // Number of shimmer items to show
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // AppBar UI
  Widget nammaDaivaAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.festivals,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const SizedBox(width: 48),
        const Spacer(),
      ],
    );
  }

  // Festival list UI
  Widget _buildFestivalList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount:
          _viewmodel.festivalList.length +
          (_viewmodel.isLoadingMore
              ? 1
              : 0), // Add one for loading more indicator
      itemBuilder: (context, index) {
        if (index == _viewmodel.festivalList.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ), // Show a loader at the bottom
          );
        }

        final festival = _viewmodel.festivalList[index];
        return FestivalCard(festival: festival);
      },
    );
  }
}

class FestivalCard extends StatelessWidget {
  final FestivalListModal festival;

  const FestivalCard({Key? key, required this.festival}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String festivalDate = _formatDateRange(
      festival.startDate,
      festival.endDate,
    );

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            festival.images.isNotEmpty
                                ? festival.images[0].url
                                : '',
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Positioned(
                      top: 10, // Position the date from the top
                      right: 16, // Position the date from the right
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0,
                          ), // Applying blur effect
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                0.3,
                              ), // Slightly transparent black
                            ),
                            child: Text(
                              festivalDate,
                              style: AppTextStyles.templeContactStyle.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              festival.name,
                              style: AppTextStyles.welcomeStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              festival.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.templeContactStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Deities: ${festival.deityNames.join(', ')}",
                              style: AppTextStyles.templeContactStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDateRange(DateTime? startDate, DateTime? endDate) {
  if (startDate == null || endDate == null) {
    return "No Date";
  }

  // Format start and end date to "Nov 1 - Nov 3"
  String start = DateFormat('MMM d').format(startDate); // Nov 1
  String end = DateFormat('MMM d').format(endDate); // Nov 3

  return "$start - $end"; // Concatenate start and end dates
}
