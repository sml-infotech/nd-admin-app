
class FcmRequestModel {
  final String fcmToken;
  final String device_type;

  FcmRequestModel({required this.fcmToken,required this.device_type});

  Map<String, dynamic> toJson() {
    return {
      'fcm_token': fcmToken,
      'device_type': device_type,
    };
  }
}