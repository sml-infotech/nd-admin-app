class MasterTemplePost {
  final List<MasterTemple> temples;

  MasterTemplePost({required this.temples});

  factory MasterTemplePost.fromJson(Map<String, dynamic> json) {
    return MasterTemplePost(
      temples: (json['temples'] as List)
          .map((e) => MasterTemple.fromJson(e))
          .toList(),
    );
  }
}

class MasterTemple {
  final String templeName;
  final String address;
  final String city;
  final String state;
  final String pincode;
  bool? isOnboarded;
  List<MasterTranslation> translations;

  MasterTemple({
    required this.templeName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.isOnboarded,
    required this.translations,
  });

  // Factory to convert from JSON
  factory MasterTemple.fromJson(Map<String, dynamic> json) {
    return MasterTemple(
      templeName: json['temple_name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      isOnboarded: json['is_onboarded'],
      translations: json['translations'] != null
          ? (json['translations'] as List)
                .map((e) => MasterTranslation.fromJson(e))
                .toList()
          : [],
    );
  }

  // Add this method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'temple_name': templeName,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'is_onboarded': isOnboarded ?? false,
      'translations': translations
          ?.map(
            (e) => {
              'language_code': e.languageCode,
              'temple_name': e.templeName,
              'address': e.address,
              'city': e.city,
              'state': e.state,
            },
          )
          .toList(),
    };
  }
}

class MasterTranslation {
  final String languageCode;
  final String templeName;
  final String address;
  final String city;
  final String state;

  MasterTranslation({
    required this.languageCode,
    required this.templeName,
    required this.address,
    required this.city,
    required this.state,
  });

  factory MasterTranslation.fromJson(Map<String, dynamic> json) {
    return MasterTranslation(
      languageCode: json['language_code'] ?? '',
      templeName: json['temple_name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
