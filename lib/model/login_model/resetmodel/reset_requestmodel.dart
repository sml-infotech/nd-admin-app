
class ResetRequestmodel {
  final String new_password;
  ResetRequestmodel({
    required this.new_password,
  });

  factory ResetRequestmodel.fromJson(Map<String, dynamic> json) {
    return ResetRequestmodel(
      new_password: json["new_password"] ?? "",
    );
  }
  Map<String, dynamic> toJson() => {
        "new_password": new_password,
     
      };
}
