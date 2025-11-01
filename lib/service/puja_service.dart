import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujaresponsemodel.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class PujaService {
  final HttpApiService apiService = HttpApiService();

  Future<PujaResponse> cretaPuja(
    String id,
    String pujaName,
    List<String> deitiesName,
    String description,
    int maximumNoOfDevotees,
    int fees,
    List<String> sample_images,
    int booking_cutoff_notice,
    bool allows_special_requirements,
    String fromDate,
    String toDate,
    List<String> days,
    List<TimeSlot> time_slots,
  ) async {
    try {
      final createpuja = Puja(
        templeId: id,
        pujaName: pujaName,
        deitiesName: deitiesName,
        description: description,
        maximumNoOfDevotees: maximumNoOfDevotees,
        fee: 500,
        sampleImages: sample_images,
        bookingCutoffNotice: booking_cutoff_notice,
        allowsSpecialRequirements: allows_special_requirements,
        fromDate: fromDate,
        toDate: toDate,
        days: days,
        timeSlots: time_slots,
      );

      print("📦 ------------------- CREATE PUJA REQUEST -------------------");
      print("Temple ID: $id");
      print("Puja Name: $pujaName");
      print("Deities: $deitiesName");
      print("Description: $description");
      print("Maximum No of Devotees: $maximumNoOfDevotees");
      print("Fee: $fees");
      print("Sample Images: $sample_images");
      print("Booking Cutoff Notice: $booking_cutoff_notice");
      print("Allows Special Requirements: $allows_special_requirements");
      print("From Date: $fromDate");
      print("To Date: $toDate");
      print("Days: $days");
      print("Time Slots: ${time_slots.map((e) => e.toJson()).toList()}");
      print("-------------------------------------------------------------");

      final data = await apiService.post(
        UrlConstant.createPujaUrl,
        createpuja.toJson(),
      );

      print("✅ CREATE PUJA RESPONSE: $data");

      return PujaResponse.fromJson(data);
    } catch (e) {
      print("❌ PujaService: API request failed -> $e");
      throw Exception('API failed: $e');
    }
  }


 Future<PujaResponse> updatePuja(
  String pujaId, // ✅ actual puja_id
  String templeId,
  String pujaName,
  List<String> deitiesName,
  String description,
  int maximumNoOfDevotees,
  double fees,
  List<String> sample_images,
  int booking_cutoff_notice,
  bool allows_special_requirements,
  String fromDate,
  String toDate,
  List<String> days,
  List<TimeSlot> time_slots,
) async {
  try {
    final updatePuja = Puja(
      puja_id: pujaId,
      templeId: templeId,
      pujaName: pujaName,
      deitiesName: deitiesName,
      description: description,
      maximumNoOfDevotees: maximumNoOfDevotees,
      fee: fees,
      sampleImages: sample_images,
      bookingCutoffNotice: booking_cutoff_notice,
      allowsSpecialRequirements: allows_special_requirements,
      fromDate: fromDate,
      toDate: toDate,
      days: days,
      timeSlots: time_slots,
    );

    print("📦 ------------------- UPDATE PUJA REQUEST -------------------");
    print("Temple ID: $templeId");
    print("Puja ID: $pujaId");
    print("Puja Name: $pujaName");
    print("Deities: $deitiesName");
    print("Description: $description");
    print("Maximum No of Devotees: $maximumNoOfDevotees");
    print("Fee: $fees");
    print("Sample Images: $sample_images");
    print("Booking Cutoff Notice: $booking_cutoff_notice");
    print("Allows Special Requirements: $allows_special_requirements");
    print("From Date: $fromDate");
    print("To Date: $toDate");
    print("Days: $days");
    print("Time Slots: ${time_slots.map((e) => e.toJson()).toList()}");
    print("-------------------------------------------------------------");

    final data = await apiService.put(
      UrlConstant.updatePuja,
      updatePuja.toJson(),
    );

    print("✅ UPDATE PUJA RESPONSE: $data");

    return PujaResponse.fromJson(data);
  } catch (e) {
    print("❌ PujaService: API request failed -> $e");
    throw Exception('API failed: $e');
  }
}

  
}
