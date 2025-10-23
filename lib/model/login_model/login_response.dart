class LoginResponse {
  final int code;
  final String? otp;
  final String? message;
  final String? error;
  final String? userId;

  LoginResponse({
   required this.code,
    this.otp,
    this.message,
    this.error,
    this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'],
      otp: json['otp']?.toString(),
      message: json['message']?.toString(),
      error: json['error']?.toString(),
      userId: json['user_id']?.toString(),
    );
  }
}
