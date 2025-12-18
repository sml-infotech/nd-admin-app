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

  MasterTemple({
    required this.templeName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.isOnboarded,
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
      'is_onboarded': isOnboarded ?? false, // default true if null
    };
  }
}

