class Temple {
  final String name;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String architecture;
  final String phoneNumber;
  final String email;
  final String description;
  final List<String> deities;
  final List<String> images;

  Temple({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.architecture,
    required this.phoneNumber,
    required this.email,
    required this.description,
    required this.deities,
    required this.images,
  });

  // From JSON
  factory Temple.fromJson(Map<String, dynamic> json) {
    return Temple(
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
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}
