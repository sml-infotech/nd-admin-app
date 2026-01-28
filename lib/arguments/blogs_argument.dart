class BlogsArgument {
  final String slug_name;

  BlogsArgument({required this.slug_name});

  factory BlogsArgument.fromJson(Map<String, dynamic> json) {
    return BlogsArgument(slug_name: json['slug_name']);
  }
}
