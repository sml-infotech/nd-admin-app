
class PujaResponse {
  final int code;
  final String message;
  final PujaData data;

  PujaResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory PujaResponse.fromJson(Map<String, dynamic> json) {
    return PujaResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: PujaData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data.toJson(),
      };
}

class PujaData {
  final String id;
  final String ?templeId;
  final String pujaName;
  final List<String> deitiesName;
  final String description;
  final int maximumNoOfDevotees;
  final double fee;
  final List<String> sampleImages;
  final int bookingCutoffNotice;
  final bool allowsSpecialRequirements;
  final DateTime fromDate;
  final DateTime toDate;
  final Map<String, bool> days;
  final DateTime createdAt;
  final DateTime updatedAt;

  PujaData({
    required this.id,
     this.templeId,
    required this.pujaName,
    required this.deitiesName,
    required this.description,
    required this.maximumNoOfDevotees,
    required this.fee,
    required this.sampleImages,
    required this.bookingCutoffNotice,
    required this.allowsSpecialRequirements,
    required this.fromDate,
    required this.toDate,
    required this.days,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PujaData.fromJson(Map<String, dynamic> json) {
    return PujaData(
      id: json['id'] as String,
      templeId: json['temple_id'] as String,
      pujaName: json['puja_name'] as String,
      deitiesName: (json['deities_name'] as List).map((e) => e as String).toList(),
      description: json['description'] as String,
      maximumNoOfDevotees: json['maximum_no_of_devotees'] is int
          ? json['maximum_no_of_devotees'] as int
          : (json['maximum_no_of_devotees'] as num).toInt(),
      fee: double.tryParse(json['fee'].toString()) ?? 0.0,
      sampleImages: (json['sample_images'] as List).map((e) => e as String).toList(),
      bookingCutoffNotice: json['booking_cutoff_notice'] is int
          ? json['booking_cutoff_notice'] as int
          : (json['booking_cutoff_notice'] as num).toInt(),
      allowsSpecialRequirements: json['allows_special_requirements'] as bool,
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      days: Map<String, bool>.from(json['days'] as Map),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'temple_id': templeId,
        'puja_name': pujaName,
        'deities_name': deitiesName,
        'description': description,
        'maximum_no_of_devotees': maximumNoOfDevotees,
        'fee': fee.toStringAsFixed(2),
        'sample_images': sampleImages,
        'booking_cutoff_notice': bookingCutoffNotice,
        'allows_special_requirements': allowsSpecialRequirements,
        'from_date': fromDate.toIso8601String(),
        'to_date': toDate.toIso8601String(),
        'days': days,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
class Deity {
  final String id;
  final String name;

  Deity({required this.id, required this.name});

  factory Deity.fromJson(Map<String, dynamic> json) {
    return Deity(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}
