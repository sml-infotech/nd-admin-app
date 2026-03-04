import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:nammadaiva_dashboard/Screens/contact_us/contact_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listscreen.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart'
    show ColorConstant, Fonts, StringConstant, font;
import 'package:nammadaiva_dashboard/Utills/image_strings.dart'
    show ImageStrings;
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/contact_us_model/contact_us_response.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ContactCard extends StatefulWidget {
  final ContactData data;

  const ContactCard({super.key, required this.data});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool _isExpanded = false;
  late ContactViewModel vm;

  @override
  void dispose() {
    vm.reset();
    super.dispose();
    print("ContactCard for ${widget.data.id} disposed");
  }

  @override
  Widget build(BuildContext context) {
    vm = Provider.of<ContactViewModel>(context, listen: false);
    return FocusDetector(
      onFocusGained: () {
        vm.fetchContacts();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
          ],
        ),
        child: InkWell(
          onTap: () async {
            setState(() => _isExpanded = !_isExpanded);

            if (!widget.data.isRead) {
              try {
                await vm.markMessageAsRead(widget.data.id);

                vm.updateContact(widget.data.copyWith(isRead: true));
              } catch (e) {
                print("Failed to mark as read: $e");
              }
            } else {
              print("dfsdfsdfsdf??????????");
            }
          },

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      contactName(),
                      const SizedBox(height: 4),
                      dateWidget(widget.data.createdAt),
                      const SizedBox(height: 4),
                      contactEmail(),
                    ],
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: widget.data.isRead ? Colors.black : Colors.red,
                    size: 28,
                  ),
                ],
              ),
              expandedWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactName() {
    return Row(
      children: [
        Text(
          widget.data.name,
          style: TextStyle(
            fontSize: 18,
            fontFamily: font,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 5),
        if (!widget.data.isRead)
          Container(
            width: 8,
            height: 8,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              color: Colors.red, // red color
              shape: BoxShape.circle, // circular shape
            ),
          ),
      ],
    );
  }

  Widget contactEmail() {
    return Text(
      widget.data.email,
      style: TextStyle(color: Colors.grey[600], fontFamily: font),
    );
  }

  Widget dateWidget(String apiDate) {
    return Text(
      formatApiDate(apiDate),
      style: TextStyle(color: Colors.grey[600], fontFamily: font),
    );
  }

  Widget expandedWidget() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      crossFadeState: _isExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: const SizedBox(),
      secondChild: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: contactDetails(widget, context),
      ),
    );
  }
}

Widget contactDetails(ContactCard widget, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "${AppLocalizations.of(context)!.phone}: ${widget.data.phoneNumber}",
        style: TextStyle(fontSize: 14, fontFamily: font),
      ),
      const SizedBox(height: 8),
      Text(
        "${AppLocalizations.of(context)!.message}:",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: font),
      ),
      const SizedBox(height: 4),
      Text(
        widget.data.message,
        style: TextStyle(color: Colors.grey[700], fontFamily: font),
      ),
    ],
  );
}

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final vm = context.read<ContactViewModel>();

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !vm.isLoadingMore &&
          vm.hasMore) {
        vm.fetchMore();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    final vm = context.read<ContactViewModel>();
    vm.reset();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        context.read<ContactViewModel>().fetchContacts(forceRefresh: true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorConstant.buttonColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: _buildAppBar(context),
        ),
        body: Consumer<ContactViewModel>(
          builder: (_, vm, __) {
            if (vm.isLoading) {
              return _buildShimmer();
            }

            return ListView.builder(
              controller: scrollController,
              itemCount: vm.contacts.length + (vm.isLoadingMore ? 1 : 0),
              itemBuilder: (_, index) {
                if (index < vm.contacts.length) {
                  return ContactCard(data: vm.contacts[index]);
                }

                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.buttonColor,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Widget _buildAppBar(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: Image.asset(ImageStrings.backbutton),
        onPressed: () => Navigator.pop(context),
      ),
      const Spacer(),
      Text(
        AppLocalizations.of(context)!.contacts,
        style: AppTextStyles.appBarTitleStyle,
      ),
      const Spacer(),
      const SizedBox(width: 48),
    ],
  );
}

Widget _buildShimmer() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ListView.separated(
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}

String formatApiDate(String apiDate) {
  DateTime date = DateTime.parse(apiDate);
  return DateFormat('dd-MM-yyyy').format(date);
}
