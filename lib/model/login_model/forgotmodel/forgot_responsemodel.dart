

class ForgotResponsemodel {
  final int code;
  final String message;
  final String otp;
  final String user_id;

  ForgotResponsemodel({
    required this.code,
    required this.message,
    required this.otp,
    required this.user_id,
  });

  factory ForgotResponsemodel.fromJson(Map<String, dynamic> json) {
    return ForgotResponsemodel(
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      otp: json["otp"] ?? "",
      user_id: json["user_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "otp": otp,
        "user_id": user_id,
      };
}
