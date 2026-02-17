import 'package:nammadaiva_dashboard/model/login_model/create_event/create_event_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/create_event/create_eventmodal.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_event/update_event_requestmodel.dart';
import 'package:nammadaiva_dashboard/model/login_model/update_event/update_event_response.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class EventService {
  final HttpApiService apiService = HttpApiService();

  Future<CreateEventResponse> createEvent(
    String? templeId,
    String name,
    String knName,
    String start_date,
    String description,
    String knDescription,
    String location,
    String knLocation,
    String contactName,
    String knContactName,
    String contact_phone,
    String endDate,
    String startTime,
    String endTime,
    List<String> images,
  ) async {
    try {
      final createEvent = CreateEventModal(
        templeId: templeId,
        name: name,
        startDate: start_date,
        description: description,
        location: location,
        contactName: contactName,
        contactPhone: contact_phone,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        images: images,
        translations: [
          CreateEventTranslation(
            languageCode: 'kn',
            name: knName,
            location: knLocation,
            description: knDescription,
            contactName: knContactName,
          ),
        ],
      );
      final data = await apiService.post(
        UrlConstant.createEventUrl,
        createEvent.toJson(),
      );

      return CreateEventResponse.fromJson(data);
    } catch (e) {
      print("CreateEventResponse service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<EventUpdateResponse> updateEvents(
    String? templeId,
    String eventId,
    String name,
    String knName,
    DateTime start_date,
    String description,
    String knDescription,
    String location,
    String knLocation,
    String contactName,
    String knContactName,
    String contact_phone,
    DateTime endDate,
    String startTime,
    String endTime,
    List<String> images,
  ) async {
    try {
      print("templeIdtempleId${templeId}");
      final createEvent = EventUpdate(
        templeId: templeId ?? null,
        name: name,
        startDate: start_date,
        description: description,
        location: location,
        contactName: contactName,
        contactPhone: contact_phone,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        images: images,
        isActive: true,
        translations: [
          CreateEventTranslation(
            languageCode: "kn",
            name: knName,
            location: knLocation,
            description: knDescription,
            contactName: knContactName,
          ),
        ],
      );

      final data = await apiService.put(
        "${UrlConstant.updateEvent}/$eventId",
        createEvent.toJson(),
      );

      return EventUpdateResponse.fromJson(data);
    } catch (e) {
      print("apiiiii update service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<EventListResponse> fetchEventes({
    int page = 1,
    int limit = 10,
    String temple_id = '',
  }) async {
    try {
      final url =
          '${UrlConstant.getEventsUrl}'
          '?page=$page'
          '&limit=$limit'
          '&language=kn'
          '${temple_id != null && temple_id.isNotEmpty ? '&temple_id=$temple_id' : ''}';

      print('Fetching fetchEventes: $url');
      dynamic data = await apiService.get(url);
      return EventListResponse.fromJson(data);
    } catch (e) {
      print("fetchEventes service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }
}
