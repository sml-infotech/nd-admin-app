
import 'package:nammadaiva_dashboard/model/login_model/pujalist/puja_list_response.dart';

class PujaArguments {
  final String templeId;
  final String puja_id;
  final String puja_name;
  final String description;
  final int maximumNoOfDevotees;
  final int fee;
  final String booking_cutoff_notice;
  final bool allows_special_requirements;
  final String from_date;
  final String to_date;
  final List<String> deities_name;
  final List<String> days;
  final List<String> sample_images;
  final List<PujaTimeSlot> timeSlots;

  PujaArguments({
    required this.templeId,
    required this.puja_id,
    required this.puja_name,
    required this.description,
    required this.maximumNoOfDevotees,
    required this.fee,
    required this.booking_cutoff_notice,
    required this.allows_special_requirements,
    required this.from_date,
    required this.to_date,
    required this.days,
    required this.deities_name,
    required this.sample_images,
    required this.timeSlots,
  });
}
