class ToggleActiveModel {
  final String? puja_id;
final bool? is_active;
  ToggleActiveModel({
    this.puja_id,
    this.is_active,
  });

  factory ToggleActiveModel.fromJson(Map<String, dynamic> json) {
    return ToggleActiveModel(
      puja_id: json['puja_id'] as String?,
      is_active: json['is_active'] ??false
          
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'puja_id': puja_id,
      'is_active': is_active,
    };
  }
}


class PujaDeactivateResponse {
  final int code;
  final String message;
  final PujaDataForActive? data;

  PujaDeactivateResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory PujaDeactivateResponse.fromJson(Map<String, dynamic> json) {
    return PujaDeactivateResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? PujaDataForActive.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class PujaDataForActive {
  final String id;
  final String pujaName;
  final bool isActive;
  final String? updatedAt;

  PujaDataForActive({
    required this.id,
    required this.pujaName,
    required this.isActive,
    this.updatedAt,
  });

  factory PujaDataForActive.fromJson(Map<String, dynamic> json) {
    return PujaDataForActive(
      id: json['id'] ?? '',
      pujaName: json['puja_name'] ?? '',
      isActive: json['is_active'] ?? false,
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'puja_name': pujaName,
      'is_active': isActive,
      'updated_at': updatedAt,
    };
  }
}

