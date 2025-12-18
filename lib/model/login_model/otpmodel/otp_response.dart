
class OtpResponse {
  OtpResponse({
    this.code,
     this.token,
     this.message,
    this.error,
    this.user,
  });
    late final int? code;

  late final String? token;
  late final String? message;
  late final String ?error;
  late final User ?user;

  OtpResponse.fromJson(Map<String, dynamic> json){
    code=json['code'];
    token = json['token'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] =code;
    _data['token'] = token;
    _data['message'] = message;
    if (user != null) {
      _data['user'] = user?.toJson();

    }
    _data['error'] = error;
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.email,

    required this.role,
    required this.full_name
  });
  late final String id;
  late final String email;
  late final String role;
  late final String full_name;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    email = json['email'];
    role = json['role'];
    full_name=json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['email'] = email;
    _data['role'] = role;
    _data['full_name'] = full_name;
    return _data;
  }
}