class LogoutResponseModal {
  final String? message;
  final int? code;

  LogoutResponseModal({required this.message, this.code});

  factory LogoutResponseModal.fromJson(Map<String, dynamic> json) {
return LogoutResponseModal(
      message: json['message'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code};
  }
}
