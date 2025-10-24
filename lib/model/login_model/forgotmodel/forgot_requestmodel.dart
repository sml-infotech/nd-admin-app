

class ForgotRequestmodel {
  final String email;
  ForgotRequestmodel({
    required this.email, 
  });
  factory ForgotRequestmodel.fromJson(Map<String, dynamic> json) {
    return ForgotRequestmodel(
      email: json["email"] ?? "",
    );
  }
  Map<String, dynamic> toJson() => {
        "email": email, 
      };
}
