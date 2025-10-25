class TempleImage {
  final String filename;
  final String contentType;

  TempleImage({
    required this.filename,
    required this.contentType,
  });

  factory TempleImage.fromJson(Map<String, dynamic> json) {
    return TempleImage(
      filename: json['filename'] as String,
      contentType: json['contentType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'contentType': contentType,
    };
  }
}

class PresignedUrlResponse {
  final String message;
  final String url;

  PresignedUrlResponse({
    required this.message,
    required this.url,
  });

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) {
    return PresignedUrlResponse(
      message: json['message'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'url': url,
    };
  }
}
