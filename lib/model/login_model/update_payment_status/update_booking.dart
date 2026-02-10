class BookingCompletionRequest {
  final String bookingStatus;
  final List<String> images;

  BookingCompletionRequest({
    required this.bookingStatus,
    required this.images,
  });

  factory BookingCompletionRequest.fromJson(Map<String, dynamic> json) {
    return BookingCompletionRequest(
      bookingStatus: json['booking_status'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "booking_status": bookingStatus,
      "images": images,
    };
  }
}
