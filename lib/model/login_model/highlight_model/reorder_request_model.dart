class ReorderRequestModel {
  final String? id;
  final int from_position;
  final int to_position;
  

  ReorderRequestModel({
    this.id,
    required this.from_position,
    required this.to_position,
    
  });
  factory ReorderRequestModel.fromJson(Map<String, dynamic> json) {
    return ReorderRequestModel(
      id: json['id'] ?? '',
      from_position: json['from_position'] ?? 0,
      to_position: json['to_position'] ?? 0,
     
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_position': from_position,
      'to_position': to_position,
    
    };
  }
}



class ReorderResponse {
  final int code;
  final String message;

  ReorderResponse({
    required this.code,
    required this.message,
  });

  factory ReorderResponse.fromJson(Map<String, dynamic> json) {
    return ReorderResponse(
      code: json['code'],
      message: json['message'],
     
    );
}

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}