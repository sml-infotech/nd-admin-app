class DeleteFestivalResponse {
  final int code;
  final String message;

  DeleteFestivalResponse({required this.code, required this.message});

  factory DeleteFestivalResponse.fromJson(Map<String, dynamic> json) {
    return DeleteFestivalResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'message': message};
  }
}
