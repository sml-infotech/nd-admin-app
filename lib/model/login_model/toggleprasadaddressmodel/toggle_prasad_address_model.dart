class TogglePrasadAddressModel {
  final String? puja_id;
  final bool? requires_prasad_address;

  TogglePrasadAddressModel({this.puja_id, this.requires_prasad_address});

  factory TogglePrasadAddressModel.fromJson(Map<String, dynamic> json) {
    return TogglePrasadAddressModel(
      puja_id: json['puja_id'] as String?,
      requires_prasad_address:
          json['requires_prasad_address'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'puja_id': puja_id,
      'requires_prasad_address': requires_prasad_address,
    };
  }
}

class TogglePrasadAddressResponse {
  final int code;
  final String message;
  final dynamic data; // You can define a specific data model if needed

  TogglePrasadAddressResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory TogglePrasadAddressResponse.fromJson(Map<String, dynamic> json) {
    return TogglePrasadAddressResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'message': message, 'data': data};
  }
}
