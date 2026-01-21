class EditHighlightRequest {
  final String title;
  final String description;

  EditHighlightRequest({required this.title, required this.description});
  factory EditHighlightRequest.fromJson(Map<String, dynamic> json) {
    return EditHighlightRequest(
      title: json['title'] ?? "",
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description};
  }
}
