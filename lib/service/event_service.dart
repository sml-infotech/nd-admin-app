


import 'package:nammadaiva_dashboard/model/login_model/create_event/create_event_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/create_event/create_eventmodal.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class EventService {
  final HttpApiService apiService = HttpApiService();

  Future<CreateEventResponse> createEvent(String templeId, String name,String start_date,String description,String location,String contactName,String contact_phone,String endDate,String startTime,String endTime,List<String>images) async {
    try {
      final loginRequest = CreateEventModal(templeId: templeId, name: name, startDate: start_date,description:description , location: location, contactName: contactName, contactPhone: contact_phone, endDate: endDate, startTime: startTime, endTime: endTime, images: images);

      final data = await apiService.post(
        UrlConstant.createEventUrl,
        loginRequest.toJson(),
      );

      return CreateEventResponse.fromJson(data);
    } catch (e) {
      print("CreateEventResponse service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }
}
