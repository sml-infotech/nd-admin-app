class UpdateTempleApprovalModal {
  final String requestId;
  final Map<String, String> fieldDecisions;
  final String admin_comments;

  UpdateTempleApprovalModal({
    required this.requestId,
    required this.fieldDecisions,
    required this.admin_comments
    
  });

  factory UpdateTempleApprovalModal.fromJson(Map<String, dynamic> json) {
    return UpdateTempleApprovalModal(
      requestId: json['request_id'] ?? '',
      fieldDecisions: Map<String, String>.from(json['field_decisions'] ?? {}),
    admin_comments: json['admin_comments']??""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'field_decisions': fieldDecisions,
      'admin_comments':admin_comments
    };
  }
}
