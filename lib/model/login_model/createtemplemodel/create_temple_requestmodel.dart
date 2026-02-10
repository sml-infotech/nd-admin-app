class AddTemple {
  final String? templeId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String architecture;
  final String phoneNumber;
  final String email;
  final String description;
  final List<String>? deities;
  final List<String>? images;
  final List<Translation> translations;


  AddTemple({
    this.templeId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.architecture,
    required this.phoneNumber,
    required this.email,
    required this.description,
    this.deities,
    this.images,
    required this.translations,
  });

  // From JSON
  factory AddTemple.fromJson(Map<String, dynamic> json) {
    return AddTemple(
      templeId: json['temple_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      architecture: json['architecture'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      deities: List<String>.from(json['deities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      translations: (json['translations'] as List<dynamic>? ?? [])
          .map((e) => Translation.fromJson(e))
          .toList(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'temple_id': templeId,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'architecture': architecture,
      'phone_number': phoneNumber,
      'email': email,
      'description': description,
      'deities': deities,
      'images': images,
      'translations': translations.map((e) => e.toJson()).toList(),
    };
  }
}
class Translation {
  final String languageCode;
  final String name;
  final String address;
  final String city;
  final String state;
  final String description;
  final List<String> deities;
  final String? architecture;
  final String? taluk;
  final String? village_name;

Translation({
    required this.languageCode,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.description,
    required this.deities,
    this.architecture,
    this.taluk,
    this.village_name,
  });
factory Translation.fromJson(Map<String, dynamic> json) {
  return Translation(
    languageCode: json['language_code'] ?? '',
    name: json['name'] ?? '',
    address: json['address'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    description: json['description'] ?? '',
    deities: json['deities'] != null
        ? List<String>.from(json['deities'])
        : <String>[],
    architecture: json['architecture'],
    taluk: json['taluk'],
    village_name: json['village_name'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'description': description,
      'deities': deities,
      'architecture': architecture,
      'taluk': taluk,
      'village_name': village_name,
    };
  }
}