import '../model/login_model/create_festival/festival_list_modal.dart';

class FestivalArgument {
  final String name;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String description;
  final List<String> deities;
  final List<String> imageUrls;
  final String? festivalId;
  final List<CreateFestivalTranslation>? translation;
  FestivalArgument({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.deities,
    required this.imageUrls,
    this.festivalId,
    this.translation,
  });
}
