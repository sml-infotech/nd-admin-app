import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  int _selectedTab = 0;

  final List<String> templeImages = [
    "https://picsum.photos/id/1011/800/400",
    "https://picsum.photos/id/1015/800/400",
    "https://picsum.photos/id/1016/800/400",
  ];

  final List<String> tabTitles = ["Map", "About", "Events",];

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
                child: Column(
                  children: [
                    carouselWidget(),
                    const SizedBox(height: 2),
                    carouselDotWidget(),
                    templeNameWidget(),
                    const SizedBox(height: 8),
                    templeDetailContactWidget(StringConstant.phone, "+91 9876543210", ImageStrings.phone),
                    templeDetailContactWidget(StringConstant.email, "info@svtemple.org", ImageStrings.phone),
                    contentWidgets(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: getSelectedTabContent(_selectedTab),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



Widget contentWidgets(){
  return   Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start, 
    children: List.generate(tabTitles.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(right: 60.0,), 
        
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Column(
            spacing: 4,
            children: [
                 _getTabIcon(index),
                  
              Text(
                tabTitles[index],
                style:_selectedTab == index ? AppTextStyles.tabTextStyle :AppTextStyles.unTabTextStyle,
              ),
             
            ],
          ) ,
              onPressed: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
          
        
      ));
    }),
  ));
}




Widget _getTabIcon(int index) {
  switch (index) {
    case 0:
      return Image.asset(
        ImageStrings.mapicon,
        width: 24,
        height: 24,
        color: _selectedTab == index ? ColorConstant.buttonColor : Colors.grey,
      );
    case 1:
      return Image.asset(
         ImageStrings.abouticon,
        width: 24,
        height: 24,
         color: _selectedTab == index ? ColorConstant.buttonColor : Colors.grey,
      );
default:
      return Image.asset(
        ImageStrings.eventicon,
        width: 24,
        height: 24,
         color: _selectedTab == index ? ColorConstant.buttonColor : Colors.grey,
      );
   
  }
}


  Widget getSelectedTabContent(int index) {
    switch (index) {
      case 0:
        return mapTab();
      case 1:
        return aboutTab();
    default:
        return eventsTab();
      
      
    }
  }

  Widget mapTab() => Padding(
        key: const ValueKey("Map"),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              "https://maps.googleapis.com/maps/api/staticmap?center=Madurai,India&zoom=13&size=600x300&key=YOUR_API_KEY",
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Text("Madurai Main, Madurai\nTamil Nadu"),
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Colors.red),
                Text("8.2 km"),
              ],
            )
          ],
        ),
      );

  Widget aboutTab() => Padding(
        key: const ValueKey("About"),
        padding: const EdgeInsets.all(16.0),
        child: const Text("About the temple goes here."),
      );

  Widget eventsTab() => Padding(
        key: const ValueKey("Events"),
        padding: const EdgeInsets.all(16.0),
        child: const Text("Upcoming events go here."),
      );



  Widget carouselWidget() {
    return CarouselSlider(
      items: templeImages
          .map(
            (image) => ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                image,
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
          )
          .toList(),
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget carouselDotWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: templeImages.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => setState(() {
            _currentIndex = entry.key;
          }),
          child: Container(
            width: _currentIndex == entry.key ? 10.0 : 8.0,
            height: _currentIndex == entry.key ? 10.0 : 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == entry.key
                  ? ColorConstant.buttonColor
                  : Colors.grey,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget templeNameWidget() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          "Arulmigu Arunachaleswarar Temple",
          style: AppTextStyles.templeNameDetailsStyle,
        ),
      ),
    );
  }

  Widget templeDetailContactWidget(String title, String subtitle, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          imageWidget(image),
          templeContacts(title, subtitle),
        ],
      ),
    );
  }

  Widget imageWidget(String image) {
    return IconButton(
      icon: Image.asset(image),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget templeContacts(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.templeContactStyle),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTextStyles.templeContactStyle),
        ],
      ),
    );
  }

  Widget nammaDaivaDetailAppBar() {
    return Center(
      child: Row(
        children: [
          IconButton(
            icon: Image.asset(ImageStrings.backbutton),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Text(StringConstant.templeDetail, style: AppTextStyles.appBarTitleStyle),
          const Spacer(),
          Text(StringConstant.edit, style: AppTextStyles.appBarTitleStyle),
        ],
      ),
    );
  }
}
