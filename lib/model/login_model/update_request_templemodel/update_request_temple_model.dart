class TempleUpdateRequestListModel {
  final int code;
  final String message;
  final TempleUpdateData data;

  TempleUpdateRequestListModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory TempleUpdateRequestListModel.fromJson(Map<String, dynamic> json) {
    return TempleUpdateRequestListModel(
      code: json['code'],
      message: json['message'],
      data: TempleUpdateData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data.toJson(),
      };
}

class TempleUpdateData {
  final int total;
  final int page;
  final int limit;
  final String status;
  final List<TempleRequest> requests;

  TempleUpdateData({
    required this.total,
    required this.page,
    required this.limit,
    required this.status,
    required this.requests,
  });

  factory TempleUpdateData.fromJson(Map<String, dynamic> json) {
    return TempleUpdateData(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      status: json['status'],
      requests: (json['requests'] as List)
          .map((e) => TempleRequest.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'limit': limit,
        'status': status,
        'requests': requests.map((e) => e.toJson()).toList(),
      };
}

class TempleRequest {
  final String id;
  final String templeId;
  final String requestedBy;
  final String requestedByName;
  final String role;
  final String status;
  final Map<String, dynamic> changes;
  final String createdAt;
  final TempleDetails templeDetails;

  TempleRequest({
    required this.id,
    required this.templeId,
    required this.requestedBy,
    required this.requestedByName,
    required this.role,
    required this.status,
    required this.changes,
    required this.createdAt,
    required this.templeDetails,
  });

  factory TempleRequest.fromJson(Map<String, dynamic> json) {
    return TempleRequest(
      id: json['id'],
      templeId: json['temple_id'],
      requestedBy: json['requested_by'],
      requestedByName: json['requested_by_name'],
      role: json['role'],
      status: json['status'],
      changes: Map<String, dynamic>.from(json['changes']),
      createdAt: json['created_at'],
      templeDetails: TempleDetails.fromJson(json['temple_details']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'temple_id': templeId,
        'requested_by': requestedBy,
        'requested_by_name': requestedByName,
        'role': role,
        'status': status,
        'changes': changes,
        'created_at': createdAt,
        'temple_details': templeDetails.toJson(),
      };
}

class TempleDetails {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? architecture;
  final String phoneNumber;
  final String email;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<String> deities;
  final List<String> images;

  TempleDetails({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.architecture,
    required this.phoneNumber,
    required this.email,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.deities,
    required this.images,
  });

  factory TempleDetails.fromJson(Map<String, dynamic> json) {
    return TempleDetails(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      architecture: json['architecture'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deities: List<String>.from(json['deities']),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() => {
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
