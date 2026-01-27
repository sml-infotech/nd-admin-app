
class LogoutRequestModel {
  final String fcmToken;

  LogoutRequestModel({required this.fcmToken});

  Map<String, dynamic> toJson() {
    return {
      'fcm_token': fcmToken,
    };
  }
}