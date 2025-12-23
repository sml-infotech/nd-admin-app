import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/festival_argument.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';

class FestivalDetailsScreen extends StatefulWidget {
  final FestivalArgument arguments;
  const FestivalDetailsScreen({super.key, required this.arguments});

  @override
  State<FestivalDetailsScreen> createState() => _FestivalDetailsScreenState();
}

class _FestivalDetailsScreenState extends State<FestivalDetailsScreen> {
  late final List<String> imageUrls;

  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    imageUrls = widget.arguments.imageUrls;
    print(">>>>>>>>>>>>${widget.arguments.name}");

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % imageUrls.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image Slider
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: _buildPageIndicators(),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  deityNameWidget(),
                  const SizedBox(height: 12),
                  startDateEndDateWidget(),
                  const SizedBox(height: 16),
                  startTimeEndTimeWidget(),
                  const SizedBox(height: 16),
                  deities(),
                  deitiesList(),
                  const SizedBox(height: 16),
                  descriptionTitleWidget(),
                  const SizedBox(height: 8),
                  descriptionWidget(),
                  const SizedBox(height: 8),
                  descriptionWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget descriptionTitleWidget() {
    return Text(
      "Description",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: font,
      ),
    );
  }

  Widget descriptionWidget() {
    return Text(
      widget.arguments.description,
      style: TextStyle(
        fontSize: 14,
        height: 1.5,
        fontFamily: font,
        color: Colors.black87,
      ),
    );
  }

  Widget deityNameWidget() {
    return Text(
      widget.arguments.name,
      style: TextStyle(
        fontSize: 20,
        fontFamily: font,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget startDateEndDateWidget() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 16),
        const SizedBox(width: 8),
        Text(
          "${widget.arguments.startDate} - ${widget.arguments.endDate}",
          style: TextStyle(fontSize: 14, fontFamily: font, color: Colors.grey),
        ),
      ],
    );
  }

  Widget startTimeEndTimeWidget() {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 16),
        const SizedBox(width: 8),
        Text(
          "${widget.arguments.startTime} - ${widget.arguments.endTime}",
          style: TextStyle(fontSize: 14, fontFamily: font, color: Colors.grey),
        ),
      ],
    );
  }

  Widget nammaDaivaAppBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.festivalDetails,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget deities() {
    return Text(
      "Deities :",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: font,
      ),
    );
  }

  Widget deitiesList() {
    return Text(
      widget.arguments.deities.join(", "),
      style: TextStyle(
        fontSize: 14,
        height: 1.5,
        fontFamily: font,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(imageUrls.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.white : Colors.white54,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
