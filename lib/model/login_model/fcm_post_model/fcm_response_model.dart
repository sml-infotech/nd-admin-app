class FcmResponseModel {
  final String? message;
  final int? code;

  FcmResponseModel({required this.message, this.code});

  factory FcmResponseModel.fromJson(Map<String, dynamic> json) {
    return FcmResponseModel(
      message: json['message'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code};
  }
}
