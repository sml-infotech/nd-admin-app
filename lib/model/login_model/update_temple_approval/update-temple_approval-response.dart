class UpdateTempleApprovalResponse {
  final int code;
  final String message;
  final TempleReviewData data;

  UpdateTempleApprovalResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory UpdateTempleApprovalResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTempleApprovalResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: TempleReviewData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class TempleReviewData {
  final String status;
  final String? comments;
  final Map<String, String> fieldReviewStatus;
  final List<String> approvedFields;

  TempleReviewData({
    required this.status,
    this.comments,
    required this.fieldReviewStatus,
    required this.approvedFields,
  });

  factory TempleReviewData.fromJson(Map<String, dynamic> json) {
    return TempleReviewData(
      status: json['status'] ?? '',
      comments: json['comments'],
      fieldReviewStatus:
          Map<String, String>.from(json['field_review_status'] ?? {}),
      approvedFields:
          List<String>.from(json['approved_fields'] ?? <String>[]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'comments': comments,
      'field_review_status': fieldReviewStatus,
      'approved_fields': approvedFields,
    };
  }
}
