import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Screens/master_temple/master_temple_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/master_temple_list_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/master_temple/post_master_temple_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MasterTempleList extends StatefulWidget {
  const MasterTempleList({super.key});

  @override
  State<MasterTempleList> createState() => _MasterTempleListState();
}

class _MasterTempleListState extends State<MasterTempleList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    // final vm = context.read<MasterTempleListViewmodel>();
    // vm.fetchTemples(reset: true);

    _controller.addListener(() {
      final vm = context.read<MasterTempleListViewmodel>();

      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - 200) {
        if (!vm.isLoadingMore && vm.hasMore) {
          vm.fetchTemples();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        final vm = context.read<MasterTempleListViewmodel>();
        vm.fetchTemples(reset: true);
      },
      child: Consumer<MasterTempleListViewmodel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: ColorConstant.buttonColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: _buildAppBar(vm),
            ),

            body: vm.isLoading && vm.temples.isEmpty
                ? _buildShimmer()
                : RefreshIndicator(
                    onRefresh: () async => vm.fetchTemples(reset: true),
                    child: ListView.builder(
                      controller: _controller,
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.temples.length + (vm.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < vm.temples.length) {
                          return _templeCard(vm.temples[index]);
                        }
                        return const Padding(
                          padding: EdgeInsets.all(18),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _templeCard(MasterTempleListModal temple) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          templeName(temple),
          const SizedBox(height: 8),
          locationAndCity(temple),
          const SizedBox(height: 4),
          pincodeAndDate(temple),
        ],
      ),
    );
  }

  Widget templeName(MasterTempleListModal temple) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            temple.templeName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: font,
            ),
          ),
        ),
        Container(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: temple.isOnboarded ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            temple.isOnboarded ? "Onboarded" : "Not Onboarded",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: font,
            ),
          ),
        ),
      ],
    );
  }

  Widget pincodeAndDate(MasterTempleListModal temple) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          " ${temple.state} - ${temple.pincode}",
          style: TextStyle(fontFamily: font, color: Colors.grey[700]),
        ),
        const SizedBox(height: 4),

        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(4, 0, 0, 0),
          child: Text(
            "Created: ${formatApiDate(temple.createdAt)}",
            style: TextStyle(
              fontFamily: font,
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }

  Widget locationAndCity(MasterTempleListModal temple) {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            "${temple.address}, ${temple.city}",
            style: TextStyle(fontFamily: font, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  String formatApiDate(String apiDate) {
    DateTime date = DateTime.parse(apiDate);
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(MasterTempleListViewmodel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () { Navigator.pop(context);
          vm.reset();
          },
        ),
        const Spacer(),
        Text(
          StringConstant.masterTemples,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        IconButton(
          iconSize: 20,
          onPressed: () {
            Navigator.pushNamed(context, StringsRoute.create_master_temple);
            vm.reset();
          },
          icon: Icon(Icons.add),
          color: Colors.white,
        ),
      ],
    );
  }
}
