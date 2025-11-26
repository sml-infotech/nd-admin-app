import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/bookings/bookings_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart'
    show CommonDropdownField;
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/model/login_model/booking_model/booking_response.dart';
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
    if (_role != null) vm.setUserRole(_role!);
    vm.fetchBookings(reset: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingsViewmodel>(
      builder: (context, vm, child) {
        return FocusDetector(
          onFocusGained: () async {
            await vm.fetchTemples();
            // await vm.fetchBookings(reset: true);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: ColorConstant.buttonColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: _buildAppBar(),
            ),
            body: Stack(
              children: [
                _buildBody(vm),

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

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text("Bookings", style: AppTextStyles.appBarTitleStyle),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildBody(BookingsViewmodel vm) {
    if (vm.isLoading && vm.bookings.isEmpty) return _buildShimmer();
    if (!vm.isLoading && vm.bookings.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _buildTempleDropdown(),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Center(
              child: Text(
                "No bookings found",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: font,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return RefreshIndicator(
      color: ColorConstant.buttonColor,
      onRefresh: () => vm.fetchBookings(reset: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: vm.bookings.length + 1 + (vm.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == 0) {
            // First item is the temple dropdown
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildTempleDropdown(),
            );
          }

          if (index <= vm.bookings.length) {
            return _buildCard(vm.bookings[index - 1], index - 1);
          }

          return _loadingMore();
        },
      ),
    );
  }

  Widget _buildTempleDropdown() {
    return GestureDetector(
      onTap: () => vm.openTempleBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                vm.selectedTemple ?? "Select Temple",
                style: TextStyle(fontSize: 16, fontFamily: font),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BookingModel request, int index) {
    bool isExpanded = vm.expandedIndex == index;

    Color statusColor = request.bookingStatus.toLowerCase() == "confirmed"
        ? Colors.green
        : request.bookingStatus.toLowerCase() == "pending"
        ? Colors.orange
        : Colors.red;

    return GestureDetector(
      onTap: () => vm.setExpanded(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.pujaName,
                    style: TextStyle(
                      fontFamily: font,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.bookingStatus,
                    style: TextStyle(
                      fontFamily: font,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _infoRow("Name", request.userName),
            _infoRow("Date", request.pujaDateFormatted),
            _infoRow("Amount", "₹ ${request.totalAmount}"),


            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 26,
                color: Colors.grey.shade700,
              ),
            ),

            if (isExpanded) ...[
              const Divider(height: 20),
              _infoRow("Phone", request.userPhone),
              _infoRow("Email", request.userEmail),
              _infoRow("Booking ID", request.bookingId),
              _infoRow("Created", request.createdAtFormatted),

              const SizedBox(height: 10),

              if (request.paymentDetails.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Details",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...request.paymentDetails.map(
                      (p) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("Payment ID", p.paymentId),
                          _infoRow("Status", p.paymentStatus),
                          _infoRow("Txn Date", p.transactionDateFormatted),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: font),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontFamily: font)),
          ),
        ],
      ),
    );
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

  Widget _loadingMore() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator(color: Colors.grey)),
    );
  }
}
