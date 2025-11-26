import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/bookings/bookings_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_request_templemodel/update_request_temple_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late BookingsViewmodel vm;
  final ScrollController _scrollController = ScrollController();

  String? _token;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
    _role = prefs.getString('userRole');

    if (mounted) setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_role != null) vm.setUserRole(_role!);
      vm.fetchBookings(reset: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 200) {
        if (!vm.isLoadingMore && vm.hasMore) vm.fetchBookings();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm = Provider.of<BookingsViewmodel>(context, listen: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    vm.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingsViewmodel>(
      builder: (context, vm, child) {
        List<TempleRequest> visible = vm.bookings;

        return FocusDetector(
          onFocusGained: () async {
            await vm.fetchBookings(reset: true);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: vm.isLoading
                          ? _buildShimmer()
                          : RefreshIndicator(
                              onRefresh: () => vm.fetchBookings(reset: true),
                              color: ColorConstant.buttonColor,
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount:
                                    visible.length + (vm.isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index < visible.length) {
                                    final data = visible[index];
                                    return _buildCard(data);
                                  }
                                  return _loadingMore();
                                },
                              ),
                            ),
                    ),
                  ],
                ),

                if (vm.isUpdating)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: ColorConstant.buttonColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: ColorConstant.buttonColor,
      title: Text(
        "Bookings",
        style: AppTextStyles.appBarTitleStyle,
      ),
      centerTitle: true,
    );
  }

  Widget _buildCard(TempleRequest request) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Temple: ${request.templeDetails.name}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("Email: ${request.templeDetails.email}"),
          Text("Status: ${request.status}"),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
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
      ),
    );
  }

  Widget _loadingMore() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: CircularProgressIndicator(color: Colors.grey),
      ),
    );
  }
}

  AppBar buildAppBar(BuildContext context) {
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

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator(color: Colors.grey)),
    );
  }


  Widget _infoRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: subtitle == "Completed"
                    ? Colors.green
                    : subtitle == "Pending"
                    ? Colors.red
                    : Colors.black,
                fontFamily: font,
              ),
            ),
          ],
        ),
      ),
    );
  }





  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is List) return value.join(', ');
    if (value is Map)
      return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    return value.toString().replaceAll('[', '').replaceAll(']', '').trim();
  }

