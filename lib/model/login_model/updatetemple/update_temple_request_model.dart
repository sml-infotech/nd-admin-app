class TempleUpdatePayload {
  String? templeId;
  TempleChanges? changes;

  TempleUpdatePayload({this.templeId, this.changes});

  factory TempleUpdatePayload.fromJson(Map<String, dynamic> json) {
    return TempleUpdatePayload(
      templeId: json['temple_id'],
      changes: json['changes'] != null
          ? TempleChanges.fromJson(json['changes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['temple_id'] = templeId;
    if (changes != null) {
      data['changes'] = changes!.toJson();
    }
    return data;
  }
}

class TempleChanges {
  String? name;
  String? address;
  String? description;
  String? city;
  String? state;
  String? pincode;
  String? phoneNumber;
  String? email;
  List<String>? deities;
  String? architecture;
  List<String>? images;

  TempleChanges({
    this.name,
    this.address,
    this.description,
    this.city,
    this.state,
    this.pincode,
    this.phoneNumber,
    this.email,
    this.deities,
    this.architecture,
    this.images,
  });

  factory TempleChanges.fromJson(Map<String, dynamic> json) {
    return TempleChanges(
      name: json['name'],
      address: json['address'],
      description: json['description'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      deities: json['deities'] != null
          ? List<String>.from(json['deities'])
          : [],
      architecture: json['architecture'],
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['address'] = address;
    data['description'] = description;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['deities'] = deities;
    data['architecture'] = architecture;
    data['images'] = images;
    return data;
  }
}
