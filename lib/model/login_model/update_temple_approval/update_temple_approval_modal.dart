class UpdateTempleApprovalModal {
  final String requestId;
  final Map<String, String> fieldDecisions;

  UpdateTempleApprovalModal({
    required this.requestId,
    required this.fieldDecisions,
  });

  factory UpdateTempleApprovalModal.fromJson(Map<String, dynamic> json) {
    return UpdateTempleApprovalModal(
      requestId: json['request_id'] ?? '',
      fieldDecisions: Map<String, String>.from(json['field_decisions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'field_decisions': fieldDecisions,
    };
  }
}
