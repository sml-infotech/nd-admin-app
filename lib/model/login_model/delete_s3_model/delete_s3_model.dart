class DeleteS3Model {
  final String key;

  DeleteS3Model({required this.key,});

  factory DeleteS3Model.fromJson(Map<String, dynamic> json) {
    return DeleteS3Model(
      key: json['key'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, };
  }
}

class DeleteS3ModelResponse {
final int code;

DeleteS3ModelResponse({required this.code,});

factory DeleteS3ModelResponse.fromJson(Map<String, dynamic> json) {
return DeleteS3ModelResponse(
  code: json['code'] ?? 0,
);
}

Map<String, dynamic> toJson() {
return {'code': code, };
}
}
   

