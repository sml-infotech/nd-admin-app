class MasterTempleListResponse {
  final int code;
  final String message;
  final List<MasterTempleListModal> data;
  final int totalCount;
  final int page;
  final int limit;

  MasterTempleListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.page,
    required this.limit,
  });

  factory MasterTempleListResponse.fromJson(Map<String, dynamic> json) {
    return MasterTempleListResponse(
      code: json["code"] ?? 0,
      message: json["message"] ?? "",
      data: (json["data"] as List<dynamic>)
          .map((item) => MasterTempleListModal.fromJson(item))
          .toList(),
      totalCount: json["totalCount"] ?? 0,
      page: json["page"] ?? 1,
      limit: json["limit"] ?? 10,
    );
  }
}
class MasterTempleListModal {
  final String id;
  final String templeName;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final bool isOnboarded;
  final String createdAt;

  MasterTempleListModal({
    required this.id,
    required this.templeName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isOnboarded,
    required this.createdAt,
  });

  factory MasterTempleListModal.fromJson(Map<String, dynamic> json) {
    return MasterTempleListModal(
      id: json["id"] ?? "",
      templeName: json["temple_name"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      isOnboarded: json["is_onboarded"] ?? false,
      createdAt: json["created_at"] ?? "",
    );
  }
}
