class MantraModel {
  final String mantraName;
  final String mantra;
  final String deityImageUrl;

  MantraModel({
    required this.mantraName,
    required this.mantra,
    required this.deityImageUrl,
  });

  factory MantraModel.fromJson(Map<String, dynamic> json) {
    return MantraModel(
      mantraName: json['mantra_name'] ?? "",
      mantra: json['mantra'] ?? "",
      deityImageUrl: json['deity_image_url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mantra_name": mantraName,
      "mantra": mantra,
      "deity_image_url": deityImageUrl,
    };
  }
}
