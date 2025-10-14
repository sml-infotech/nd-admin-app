class LoginResponse {
  final String? otp;
  final String? message;
  final String? error;
  final String? userId;

  LoginResponse({
    this.otp,
    this.message,
    this.error,
    this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      otp: json['otp']?.toString(),
      message: json['message']?.toString(),
      error: json['error']?.toString(),
      userId: json['user_id']?.toString(),
    );
  }
}
