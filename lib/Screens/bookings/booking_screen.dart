import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/bookings/bookings_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm = Provider.of<BookingsViewmodel>(context, listen: false);

    if (_role != null) vm.setUserRole(_role!);
    vm.reset();
    vm.fetchBookings(reset: true);
    vm.fetchTemples();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
    _role = prefs.getString('userRole');

    if (mounted) setState(() {});

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 200) {
        if (!vm.isLoadingMore && vm.hasMore) {
          vm.fetchBookings();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingsViewmodel>(
      builder: (context, vm, child) {
        return FocusDetector(
          onFocusGained: () => vm.fetchTemples(),
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

                if (!vm.isLoading && vm.bookings.isEmpty)
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.no_bookings_found,
                      style: TextStyle(fontFamily: font),
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
        Text(
          AppLocalizations.of(context)!.bookings,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildBody(BookingsViewmodel vm) {
    if (vm.isLoading && vm.bookings.isEmpty) {
      return _buildShimmer();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: vm.bookings.length + 2 + (vm.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTempleDropdown(),
          );
        }

        if (index == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSegmentedControl(),
          );
        }

        if (index - 2 < vm.bookings.length) {
          return _buildCard(vm.bookings[index - 2], index - 2);
        }

        return _loadingMore();
      },
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: List.generate(vm.segments.length, (index) {
          final active = index == vm.selectedSegment;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => vm.selectedSegment = index);
                vm.fetchBookings(
                  reset: true,
                  filter: vm.segments[index].toLowerCase(),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active
                      ? ColorConstant.buttonColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  vm.segments[index],
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }),
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
        ),
        child: Row(
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
    final isExpanded = vm.expandedIndex == index;

    final statusColor = request.bookingStatus.toLowerCase() == "confirmed"
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
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            _infoRow("Name", request.userName),
            _infoRow("Date", request.pujaDateFormatted),
            _infoRow("Amount", "₹ ${request.totalAmount}"),

            if (request.bookingStatus.toLowerCase() == "confirmed")
              markedAsCompletedWidget(request.bookingId),

            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 26,
              ),
            ),

            if (isExpanded) ...[
              const Divider(),
              _infoRow("Phone", request.userPhone),
              _infoRow("Email", request.userEmail),
              _infoRow("Booking ID", request.bookingId),
              _infoRow("Created", request.createdAtFormatted),
              if (request.paymentDetails.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: request.paymentDetails
                      .map(
                        (p) => Column(
                          children: [
                            _infoRow("Payment ID", p.paymentId),
                            _infoRow("Status", p.paymentStatus),
                            _infoRow("Txn Date", p.transactionDateFormatted),
                          ],
                        ),
                      )
                      .toList(),
                ),
              if (request.images.isNotEmpty)
                poojaImage(request.images.first, request),
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

  Widget poojaImage(String url, BookingModel request) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          "Pooja Images",
          style: TextStyle(
            fontFamily: font,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: request.images.map((imgUrl) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Image.network(imgUrl, fit: BoxFit.fitWidth),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imgUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),
      ],
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

  Widget markedAsCompletedWidget(String bookingId) {
    return GestureDetector(
      onTap: () => _openUploadPoojaDialog(bookingId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.buttonColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Mark as Completed",
          style: TextStyle(
            fontFamily: font,
            fontWeight: FontWeight.bold,
            color: ColorConstant.buttonColor,
          ),
        ),
      ),
    );
  }

  void _openUploadPoojaDialog(String bookingId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Consumer<BookingsViewmodel>(
          builder: (context, vm, _) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titleAndCloseIcon(),
                    const SizedBox(height: 16),
                    _buildImagePicker(),
                    const SizedBox(height: 20),
                    submitButton(bookingId),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget submitButton(String bookingId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          if (vm.selectedImages.isNotEmpty) {
            await vm.uploadSelectedImages(bookingId);
          }
          await vm.updateBooking(bookingId);
          Navigator.pop(context);
        },
        child: Text(
          "Mark as Completed",
          style: TextStyle(fontFamily: font, fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget titleAndCloseIcon() {
    return Row(
      children: [
        const Spacer(),
        Text(
          "Upload Pooja Image",
          style: TextStyle(
            fontFamily: font,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: vm.pickImages,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo),
                SizedBox(width: 8),
                Text("Add Images"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (vm.selectedImages.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              vm.selectedImages.length,
              (index) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(vm.selectedImages[index].path),
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => vm.removeImage(index),
                      child: const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

Widget _loadingMore() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Center(child: CircularProgressIndicator(color: Colors.grey)),
  );
}
