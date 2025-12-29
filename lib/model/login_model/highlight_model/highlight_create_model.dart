class HighlightCreateModel {
  final String? media_type;
  final String? media_url;
  final String? thumbnail_url;
  

  HighlightCreateModel({
    this.media_type,
     this.media_url,
     this.thumbnail_url,
    
  });
  factory HighlightCreateModel.fromJson(Map<String, dynamic> json) {
    return HighlightCreateModel(
      media_type: json['media_type'] ?? '',
      media_url: json['media_url'] ?? '',
      thumbnail_url: json['thumbnail_url'] ?? '',
     
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'media_type': media_type,
      'media_url': media_url,
      'thumbnail_url': thumbnail_url,
    
    };
  }
}
