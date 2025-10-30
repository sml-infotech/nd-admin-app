class TempleUpdateResponse {
  int? code;
  String? message;
  TempleUpdateData? data;

  TempleUpdateResponse({this.code, this.message, this.data});

  factory TempleUpdateResponse.fromJson(Map<String, dynamic> json) {
    return TempleUpdateResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null
          ? TempleUpdateData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TempleUpdateData {
  String? requestId;
  String? status;
  String? createdAt;

  TempleUpdateData({this.requestId, this.status, this.createdAt});

  factory TempleUpdateData.fromJson(Map<String, dynamic> json) {
    return TempleUpdateData(
      requestId: json['request_id'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['request_id'] = requestId;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
