class CreateBlogResponse {
  final int code;
  final String message;

  CreateBlogResponse({required this.code, required this.message});

  factory CreateBlogResponse.fromJson(Map<String, dynamic> json) {
    return CreateBlogResponse(code: json["code"], message: json["message"]);
  }
}
