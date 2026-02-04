import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Screens/festivals/create_festival_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/festival_argument.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/create_festival/festival_list_modal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class FestivalListScreen extends StatefulWidget {
  const FestivalListScreen({super.key});

  @override
  State<FestivalListScreen> createState() => _FestivalListScreenState();
}

class _FestivalListScreenState extends State<FestivalListScreen> {
  late CreateFestivalViewmodel _viewmodel;
  final ScrollController _scrollController = ScrollController();
  String? language;
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('language') ?? 'en';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _viewmodel.reset();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_viewmodel.isInitialLoading &&
        !_viewmodel.isLoadingMore &&
        _viewmodel.hasMoreFestivals) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    await _viewmodel.fetchFestivals();
  }

  Widget _buildBottomShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
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
              _viewmodel.fetchFestivals(reset: true);
            },
            child: Column(
              children: [
                Expanded(
                  child: _viewmodel.isInitialLoading
                      ? _buildShimmer()
                      : _buildFestivalList(_viewmodel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.separated(
        itemCount: 6,
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
        const Spacer(),
        IconButton(
          onPressed: () {
            _viewmodel.reset();
            Navigator.pushNamed(context, StringsRoute.createFestival);
          },
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildFestivalList(CreateFestivalViewmodel viewmodel) {
    return ListView.builder(
      controller: _scrollController,
      itemCount:
          _viewmodel.festivalList.length + (_viewmodel.isLoadingMore ? 1 : 0),

      itemBuilder: (_, index) {
        if (index == _viewmodel.festivalList.length) {
          return _buildBottomShimmer();
        }

        final festival = _viewmodel.festivalList[index];
        return FestivalCard(
          festival: festival,
          viewmodel: viewmodel,
          language: language ?? "en",
        );
      },
    );
  }
}

class FestivalCard extends StatelessWidget {
  final FestivalListModal festival;
  final CreateFestivalViewmodel viewmodel;
  final String language;
  const FestivalCard({
    Key? key,
    required this.festival,
    required this.viewmodel,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String festivalDate = _formatDateRange(
      festival.startDate,
      festival.endDate,
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          StringsRoute.festivalDetailsScreen,
          arguments: FestivalArgument(
            name: festival.name,
            startDate: festival.startDate != null
                ? DateFormat('yyyy-MM-dd').format(festival.startDate!)
                : '',
            endDate: festival.endDate != null
                ? DateFormat('yyyy-MM-dd').format(festival.endDate!)
                : '',
            startTime: festival.startTime ?? '',
            endTime: festival.endTime ?? '',
            description: festival.description,
            deities: festival.deityNames,
            imageUrls: festival.images.map((e) => e.url).toList(),
            translation: festival.translations,
          ),
        );
      },
      child: SizedBox(
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
                      // Background Image
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
                      dateWidget(festivalDate),
                      Positioned(
                        top: 10,
                        right: 16,
                        child: editAndDeleteIcon(context, viewmodel, festival),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: nameAndDescriptionWidget(
                          festival,
                          language,
                          context,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget nameAndDescriptionWidget(
  FestivalListModal festival,
  String language,
  BuildContext context,
) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.9)],
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
          language == "kn" && festival.translations.isNotEmpty == true
              ? festival.translations.first.name
              : festival.name,
          style: AppTextStyles.welcomeStyle.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          language == "kn" && festival.translations.isNotEmpty == true
              ? festival.translations.first.description
              : festival.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.templeContactStyle.copyWith(color: Colors.white),
        ),
        const SizedBox(width: 6),
        const SizedBox(height: 8),
        Text(
          "${language == "kn" ? "${AppLocalizations.of(context)?.deities_en} : " ?? 'Deities:' : 'Deities:'} ${language == "kn" && festival.translations.isNotEmpty == true ? festival.translations.first.deities?.join(', ') ?? '' : festival.deityNames.join(', ')}",
          style: AppTextStyles.templeContactStyle.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}

Widget editAndDeleteIcon(
  BuildContext context,
  CreateFestivalViewmodel viewmodel,
  FestivalListModal festival,
) {
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            StringsRoute.createFestival,
            arguments: FestivalArgument(
              name: festival.name,
              startDate: festival.startDate != null
                  ? DateFormat('yyyy-MM-dd').format(festival.startDate!)
                  : '',
              endDate: festival.endDate != null
                  ? DateFormat('yyyy-MM-dd').format(festival.endDate!)
                  : '',
              startTime: festival.startTime ?? '',
              endTime: festival.endTime ?? '',
              description: festival.description,
              deities: festival.deityNames,
              imageUrls: festival.images.map((e) => e.url).toList(),
              festivalId: festival.id,
              translation: festival.translations,
            ),
          );
        },
        child: Icon(Icons.edit, size: 20, color: Colors.white),
      ),
      SizedBox(width: 6),
      GestureDetector(
        onTap: () {
          _showDeleteConfirmationSheet(
            context,
            festivalId: festival.id,
            festivalName: festival.name,
            viewmodel: viewmodel,
          );
        },
        child: const Icon(Icons.delete, size: 20, color: Colors.red),
      ),
      SizedBox(width: 16),
    ],
  );
}

Widget dateWidget(String festivalDate) {
  return Positioned(
    top: 10, // Position it 10px from the top
    left: 16, // Position it 16px from the left
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
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
  );
}

String _formatDateRange(DateTime? startDate, DateTime? endDate) {
  if (startDate == null || endDate == null) {
    return "No Date";
  }
  String start = DateFormat('MMM d').format(startDate);
  String end = DateFormat('MMM d').format(endDate);
  return "$start - $end";
}

void _showDeleteConfirmationSheet(
  BuildContext context, {
  required String festivalId,
  required String festivalName,
  required CreateFestivalViewmodel viewmodel,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
            const SizedBox(height: 12),

            Text(
              "Delete Festival",
              style: AppTextStyles.appBarTitleStyle.copyWith(
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Are you sure you want to delete \"$festivalName\"?",
              textAlign: TextAlign.center,
              style: AppTextStyles.templeContactStyle.copyWith(
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorConstant.buttonColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: AppTextStyles.buttonTextStyle.copyWith(
                        color: ColorConstant.buttonColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await viewmodel.deleteFestival(festivalId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Delete", style: AppTextStyles.buttonTextStyle),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
