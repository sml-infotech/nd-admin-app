import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  // Example event data
  final Map<String, dynamic> event = {
    "temple_id": "21e37f32-388c-46a6-9249-70d6b9a6448f",
    "name": "Deepavali Pooja Celebration",
    "description":
        "Annual Deepavali celebration at the temple with lighting and prayers.",
    "location": "Coimbatore Temple",
    "contact_name": "Ramesh Kumar",
    "contact_phone": "+919876543210",
    "start_date": "2025-11-10T00:00:00.000Z",
    "end_date": "2025-11-12T00:00:00.000Z",
    "start_time": "18:00:00",
    "end_time": "21:00:00",
    "images": <String>[
      "https://example.com/event1.jpg",
      "https://example.com/event2.jpg",
    ],
    "is_active": true,
    "created_by_name": "Balakrishnan Ragavan",
  };

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async {},
      child: Scaffold(
        backgroundColor: ColorConstant.buttonColor,
        appBar: AppBar(
          backgroundColor: ColorConstant.buttonColor,
          elevation: 0,
          title: nammaDaivaAppBar(),
        ),
        body: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: buildEventCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nammaDaivaAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(StringConstant.events, style: AppTextStyles.appBarTitleStyle),
        const Spacer(),
      ],
    );
  }

  Widget buildEventCard() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            eventTitle(),
            const SizedBox(height: 8),
            locationText(),
            const SizedBox(height: 8),
            fromAndEndDateText(),
            const SizedBox(height: 8),
            fromTimeEndTime(),
            const Divider(height: 24),
            descriptionTitleText(),
            const SizedBox(height: 6),
            descriptionText(),
            const Divider(height: 24),
            contactNameText(),
            const SizedBox(height: 8),
            contactName(),
            const SizedBox(height: 4),
            contactPhone(),
            const Divider(height: 24),
            const SizedBox(height: 16),
            if (event['images'] != null && event['images'].length > 1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: event['images'].length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final imageUrl = event['images'][index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade300,
                              width: 120,
                              height: 100,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget eventTitle() {
    return Text(
      event['name'] ?? '',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: font,
      ),
    );
  }

  Widget locationText() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.grey, size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            event['location'] ?? '',
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

  Widget fromAndEndDateText() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
        const SizedBox(width: 6),
        Text(
          "From ${_formatDate(event['start_date'])} to ${_formatDate(event['end_date'])}",
          style: TextStyle(fontSize: 14, fontFamily: font),
        ),
      ],
    );
  }

  Widget fromTimeEndTime() {
    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.grey, size: 18),
        const SizedBox(width: 6),
        Text(
          "${event['start_time']} - ${event['end_time']}",
          style: TextStyle(fontSize: 14, fontFamily: font),
        ),
      ],
    );
  }

  Widget descriptionTitleText() {
    return Text(
      "Description",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: font,
      ),
    );
  }

  Widget descriptionText() {
    return Text(
      event['description'] ?? '',
      style: TextStyle(fontSize: 14, color: Colors.black87, fontFamily: font),
    );
  }

  Widget contactNameText() {
    return Text(
      "Contact Information",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: font,
      ),
    );
  }

  Widget contactName() {
    return Row(
      children: [
        const Icon(Icons.person, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          event['contact_name'] ?? '',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontFamily: font,
          ),
        ),
      ],
    );
  }

  Widget contactPhone() {
    return Row(
      children: [
        const Icon(Icons.phone, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          event['contact_phone'] ?? '',
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
