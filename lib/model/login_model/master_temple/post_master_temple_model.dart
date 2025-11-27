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
  final bool isOnboarded;

  MasterTemple({
    required this.templeName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isOnboarded,
  });

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
}
