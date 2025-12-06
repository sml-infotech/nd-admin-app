import 'dart:math';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Screens/event_list_screen/event_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late EventListViewmodel viewmodel;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<EventItem> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<EventListViewmodel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewmodel.getTemples();

      if (viewmodel.templeData.isNotEmpty) {
        final firstTemple = viewmodel.templeData.first;
        viewmodel.setSelectedTemple(firstTemple);
        viewmodel.selectedTempleId = firstTemple.id;

        await viewmodel.fetchEvents(firstTemple.id, true);
        setState(() {
          filteredEvents = viewmodel.events;
        });
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !viewmodel.isLoadingMore &&
          viewmodel.hasMore &&
          !viewmodel.isLoading) {
        viewmodel.fetchEvents(viewmodel.selectedTempleId!, false);
      }
    });

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredEvents = viewmodel.events
            .where(
              (event) =>
                  event.name.toLowerCase().contains(query) ||
                  (event.description?.toLowerCase().contains(query) ?? false),
            )
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    viewmodel.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async {
        if (viewmodel.selectedTempleId != null) {
          await viewmodel.fetchEvents(viewmodel.selectedTempleId!, true);
          setState(() {
            filteredEvents = viewmodel.events;
          });
        }
      },
      child: Consumer<EventListViewmodel>(
        builder: (context, viewmodel, child) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorConstant.buttonColor,
            elevation: 0,
            title: nammaDaivaAppBar(),
          ),
          body: viewmodel.isLoading && viewmodel.events.isEmpty
              ? _buildShimmer()
              : Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    _buildTempleDropdown(),
                    SizedBox(height: 12),
                    if (!viewmodel.events.isEmpty) ...[searchBar()],
                    SizedBox(height: 12),
                    !filteredEvents.isEmpty
                        ? Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  filteredEvents.length +
                                  (viewmodel.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == filteredEvents.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Center(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  );
                                }
                                final event = filteredEvents[index];
                                return buildEventCard(event);
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "No events found.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontFamily: font,
                              ),
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTempleDropdown() {
    var uniqueTemples = viewmodel.templeData.toSet().toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CommonDropdownField(
        hintText: AppLocalizations.of(context)!.temple,
        labelText: AppLocalizations.of(context)!.temple,
        items: uniqueTemples.map((t) => t.name).toList(),
        selectedValue: viewmodel.selectedTemple?.name,
        paddingSize: 0,
        onChanged: (value) async {
          if (value == null) return;

          final selectedTemple = uniqueTemples.firstWhere(
            (t) => t.name == value,
          );

          viewmodel.setSelectedTemple(selectedTemple);
          viewmodel.selectedTempleId = selectedTemple.id;

          await viewmodel.fetchEvents(selectedTemple.id, true);

          setState(() {
            filteredEvents = viewmodel.events;
          });
        },
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.search,
          hintStyle: TextStyle(fontFamily: font),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget nammaDaivaAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        Spacer(),
        Text(
          AppLocalizations.of(context)!.events,
          style: AppTextStyles.appBarTitleStyle,
        ),

        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, StringsRoute.createEvent);
          },
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget buildEventCard(EventItem event) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 0),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  eventTitle(event.name),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        StringsRoute.createEvent,
                        arguments: event,
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              locationText(event.location ?? ''),
              const SizedBox(height: 8),
              fromAndEndDateText(event.startDate ?? '', event.endDate ?? ''),
              const SizedBox(height: 8),
              fromTimeEndTime(event.startTime ?? '', event.endTime ?? ''),
              const Divider(height: 24),
              descriptionTitleText(),
              const SizedBox(height: 6),
              descriptionText(event.description ?? ''),
              const Divider(height: 24),
              contactNameText(),
              const SizedBox(height: 8),
              contactName(event.contactName ?? ''),
              const SizedBox(height: 4),
              contactPhone(event.contactPhone ?? ''),
              const Divider(height: 24),
              if (event.images != null && event.images!.isNotEmpty)
                imageViewer(event),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageViewer(EventItem event) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: event.images?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final imageUrl = event.images?[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl!,
              width: 160,
              height: 120,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: 160,
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.buttonColor,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                width: 160,
                height: 120,
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget eventTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: font,
      ),
    );
  }

  Widget locationText(String location) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.grey, size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            location,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: font,
            ),
          ),
        ),
      ],
    );
  }

  Widget fromAndEndDateText(String startDate, String endDate) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
        const SizedBox(width: 6),
        Text(
          "From ${_formatDate(startDate)} to ${_formatDate(endDate)}",
          style: TextStyle(fontSize: 14, fontFamily: font),
        ),
      ],
    );
  }

  Widget fromTimeEndTime(String startTime, String endTime) {
    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.grey, size: 18),
        const SizedBox(width: 6),
        Text(
          "${startTime} - ${endTime}",
          style: TextStyle(fontSize: 14, fontFamily: font),
        ),
      ],
    );
  }

  Widget descriptionTitleText() {
    return Text(
      AppLocalizations.of(context)!.eventDescription,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: font,
      ),
    );
  }

  Widget descriptionText(String description) {
    return Text(
      description,
      style: TextStyle(fontSize: 14, color: Colors.black87, fontFamily: font),
    );
  }

  Widget contactNameText() {
    return Text(
      AppLocalizations.of(context)!.contactInformation,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: font,
      ),
    );
  }

  Widget contactName(String contactName) {
    return Row(
      children: [
        const Icon(Icons.person, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          contactName,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontFamily: font,
          ),
        ),
      ],
    );
  }

  Widget contactPhone(String contactPhone) {
    return Row(
      children: [
        const Icon(Icons.phone, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          contactPhone,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontFamily: font,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return '';
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
}
