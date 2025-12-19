class HighlightStatusUpdate {
  final List<String> ids;
  final bool isActive;

  // Constructor
  HighlightStatusUpdate({
    required this.ids,
    required this.isActive,
  });

  // Factory constructor to create a HighlightStatusUpdate instance from JSON
  factory HighlightStatusUpdate.fromJson(Map<String, dynamic> json) {
    return HighlightStatusUpdate(
      ids: List<String>.from(json['ids'] ?? []),
      isActive: json['is_active'] ?? false,
    );
  }

  // Method to convert HighlightStatusUpdate instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ids': ids,
      'is_active': isActive,
    };
  }
}
class HighlightStatusUpdateResponse {
  final int code;
  final String message;
  final HighlightStatusUpdateData data;

  // Constructor
  HighlightStatusUpdateResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  // Factory constructor to create an instance from JSON
  factory HighlightStatusUpdateResponse.fromJson(Map<String, dynamic> json) {
    return HighlightStatusUpdateResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: HighlightStatusUpdateData.fromJson(json['data'] ?? {}),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class HighlightStatusUpdateData {
  final int updatedCount;

  // Constructor
  HighlightStatusUpdateData({
    required this.updatedCount,
  });

  // Factory constructor to create an instance from JSON
  factory HighlightStatusUpdateData.fromJson(Map<String, dynamic> json) {
    return HighlightStatusUpdateData(
      updatedCount: json['updated_count'] ?? 0,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'updated_count': updatedCount,
    };
  }
}
