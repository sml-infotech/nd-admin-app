class TempleResponse {
  final String? message;
  final List<Temple>? data;
  final int? totalCount;
  final int? page;
  final int? limit;

  TempleResponse({
    this.message,
    this.data,
    this.totalCount,
    this.page,
    this.limit,
  });

  factory TempleResponse.fromJson(Map<String, dynamic> json) {
    return TempleResponse(
      message: json['message'],
      data: json['data'] != null
          ? List<Temple>.from(json['data'].map((x) => Temple.fromJson(x)))
          : [],
      totalCount: json['totalCount'],
      page: json['page'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((x) => x.toJson()).toList(),
      'totalCount': totalCount,
      'page': page,
      'limit': limit,
    };
  }
}

class Temple {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String architecture;
  final String phoneNumber;
  final String email;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<String>? deities;
  final List<String>? images;

  Temple({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.architecture,
    required this.phoneNumber,
    required this.email,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deities,
    this.images,
  });

  factory Temple.fromJson(Map<String, dynamic> json) {
    return Temple(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      architecture: json['architecture'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deities: json['deities'] != null
          ? List<String>.from(json['deities'])
          : [],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'architecture': architecture,
      'phone_number': phoneNumber,
      'email': email,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deities': deities,
      'images': images,
    };
  }
}
