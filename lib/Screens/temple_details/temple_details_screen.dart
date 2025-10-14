
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class TempleDetailsScreen extends StatefulWidget {
  const TempleDetailsScreen({super.key});

  @override
  State<TempleDetailsScreen> createState() => _TempleDetailsScreenState();
}

class _TempleDetailsScreenState extends State<TempleDetailsScreen> {
  int _currentIndex = 0;

  final List<String> templeImages = [
    'https://picsum.photos/400/200?image=1',
    'https://picsum.photos/400/200?image=2',
    'https://picsum.photos/400/200?image=3',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        title: nammaDaivaDetailAppBar(),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 🖼 Carousel Slider
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          aspectRatio: 16 / 9,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: templeImages.map((imageUrl) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),

                      // 🔘 Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: templeImages.asMap().entries.map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == entry.key
                                  ? ColorConstant.buttonColor
                                  : Colors.grey[300],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // 📝 Example text content
                      Text(
                        "Temple details go here...",
                        style: AppTextStyles.appBarTitleStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nammaDaivaDetailAppBar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Image.asset(ImageStrings.backbutton),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Text(
            StringConstant.templeDetail,
            style: AppTextStyles.appBarTitleStyle,
          ),
          const Spacer(),
          Text(
            StringConstant.edit,
            style: AppTextStyles.appBarTitleStyle,
          ),
        ],
      ),
    );
  }
}
