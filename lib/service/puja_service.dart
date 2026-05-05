import 'package:nammadaiva_dashboard/generated/l10n.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujamodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/createpuja/create_pujaresponsemodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/toggleactivemodel/toggle_active_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/toggleprasadaddressmodel/toggle_prasad_address_model.dart';
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
    double fees,
    List<String> sample_images,
    int booking_cutoff_notice,
    bool allows_special_requirements,
    String fromDate,
    String toDate,
    List<String> days,
    List<TimeSlot> time_slots,
    List<String> benefits,
    bool requires_prasad_address,
    String prasad_delivery_charges,
    List<Translation> translations,
  ) async {
    try {
      final createpuja = Puja(
        templeId: id,
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
        benefits: benefits,
        requires_prasad_address: requires_prasad_address,
        prasad_delivery_charges: prasad_delivery_charges,
        translations: translations,
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
      print("{  'benefits': ${benefits.map((b) => b).toList()} }");
      print("Translations: ${translations.map((t) => t.toJson()).toList()}");
      print("Requires Prasad Address: $requires_prasad_address");
      print("Prasad Delivery Charges: $prasad_delivery_charges");
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
    List<String> benefits,
    bool requires_prasad_address,
    String prasad_delivery_charges,
    List<Translation> translations,
  ) async {
    try {
      final updatePuja = Puja(
        pujaId: pujaId,
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
        benefits: benefits,
        requires_prasad_address: requires_prasad_address,
        prasad_delivery_charges: prasad_delivery_charges,
        translations: translations,
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
      print("{  'benefits': ${benefits.map((b) => b).toList()} }");
      print("Translations: ${translations.map((t) => t.toJson()).toList()}");
      print("Requires Prasad Address: $requires_prasad_address");
      print("Prasad Delivery Charges: $prasad_delivery_charges");
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

  Future<PujaDeactivateResponse> activateToggle(
    String pujaId,
    bool isActive,
  ) async {
    try {
      final updatePuja = ToggleActiveModel(
        puja_id: pujaId,
        is_active: isActive,
      );

      print(
        "📦 ------------------- UPDATE ToggleActiveModel -------------------",
      );
      print("Temple ID: $isActive");
      print("Puja ID: $pujaId");

      final data = await apiService.put(
        UrlConstant.toggleUrl,
        updatePuja.toJson(),
      );

      print("✅ toggle PUJA activate: $data");

      return PujaDeactivateResponse.fromJson(data);
    } catch (e) {
      print("❌ toggle: API request failed -> $e");
      throw Exception('API failed: $e');
    }
  }

  Future<TogglePrasadAddressResponse> togglePrasadAddress(
    String pujaId,
    bool requiresPrasadAddress,
  ) async {
    try {
      final togglePrasad = TogglePrasadAddressModel(
        puja_id: pujaId,
        requires_prasad_address: requiresPrasadAddress,
      );

      print(
        "📦 ------------------- TOGGLE PRASAD ADDRESS REQUEST -------------------",
      );
      print("Puja ID: $pujaId");
      print("Requires Prasad Address: $requiresPrasadAddress");

      final data = await apiService.put(
        UrlConstant.togglePrasadAddressUrl(pujaId),
        togglePrasad.toJson(),
      );

      print("✅ TOGGLE PRASAD ADDRESS RESPONSE: $data");

      return TogglePrasadAddressResponse.fromJson(data);
    } catch (e) {
      print("❌ Toggle Prasad Address: API request failed -> $e");
      throw Exception('API failed: $e');
    }
  }
}
