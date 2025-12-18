import 'dart:convert';

class UserListResponse {
  final List<UserModel> users;
  final int totalCount;
  final int totalPages;
  final int currentPage;

  UserListResponse({
    required this.users,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      users: (json['users'] as List<dynamic>)
          .map((u) => UserModel.fromJson(u))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final List<TempleModel> associatedTemples;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.associatedTemples,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      role: json['role'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      associatedTemples: (json['associated_temples'] as List<dynamic>?)
              ?.map((t) => TempleModel.fromJson(t))
              .toList() ??
          [],
    );
  }
}

class TempleModel {
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
  final List<String> deities;
  final List<String> images;

  TempleModel({
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
    required this.deities,
    required this.images,
  });

  factory TempleModel.fromJson(Map<String, dynamic> json) {
    return TempleModel(
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
      deities:
          (json['deities'] as List?)?.map((d) => d.toString()).toList() ?? [],
      images:
          (json['images'] as List?)?.map((img) => img.toString()).toList() ?? [],
    );
  }
}
