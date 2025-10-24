

class ResetResponsemodel {
  final int code;
  final String message;
  ResetResponsemodel({
    required this.code,
    required this .message
  });
  factory ResetResponsemodel.fromJson(Map<String, dynamic> json) {
    return ResetResponsemodel(
      code: json['code'],
      message: json['message']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message':message
    };
  }
}