class MantraListModal {
  final int code;
  final String message;
  final List<MantraItem> items;
  final int total;
  final int page;
  final int limit;

  MantraListModal({
    required this.code,
    required this.message,
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory MantraListModal.fromJson(Map<String, dynamic> json) {
    return MantraListModal(
      code: json["code"],
      message: json["message"],
      items: (json["items"] as List)
          .map((item) => MantraItem.fromJson(item))
          .toList(),
      total: json["total"],
      page: json["page"],
      limit: json["limit"],
    );
  }
}

class MantraItem {
  final String id;
  final String mantraName;
  final String mantra;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  MantraItem({
    required this.id,
    required this.mantraName,
    required this.mantra,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MantraItem.fromJson(Map<String, dynamic> json) {
    return MantraItem(
      id: json["id"],
      mantraName: json["mantra_name"],
      mantra: json["mantra"],
      imageUrl: json["deity_image_url"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}
