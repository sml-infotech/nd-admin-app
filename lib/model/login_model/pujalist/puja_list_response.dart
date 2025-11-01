class PujaListResponse {
  final int code;
  final List<PujaData> data;

  PujaListResponse({required this.code, required this.data});

  factory PujaListResponse.fromJson(Map<String, dynamic> json) {
    return PujaListResponse(
      code: json['code'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => PujaData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'data': data.map((item) => item.toJson()).toList()};
  }
}

class PujaData {
  final String id;
  final String templeId;
  final String pujaName;
  final List<String> deitiesName;
  final String description;
  final int maximumNoOfDevotees;
  final String fee;
  final List<String> sampleImages;
  final int bookingCutoffNotice;
  final bool allowsSpecialRequirements;
  final DateTime fromDate;
  final DateTime toDate;
  final Map<String, bool> days;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PujaTimeSlot> timeSlots;
   bool? isActive;

  PujaData({
    required this.id,
    required this.templeId,
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
    required this.timeSlots,
    this.isActive,
  });

  factory PujaData.fromJson(Map<String, dynamic> json) {
    return PujaData(
      id: json['id'] ?? '',
      templeId: json['temple_id'] ?? '',
      pujaName: json['puja_name'] ?? '',
      deitiesName: json['deities_name'] != null
          ? List<String>.from(json['deities_name'])
          : [],
      description: json['description'] ?? '',
      maximumNoOfDevotees: json['maximum_no_of_devotees'] ?? 0,
      fee: json['fee'] != null ? json['fee'].toString() : '0',
      sampleImages: json['sample_images'] != null
          ? List<String>.from(json['sample_images'])
          : [],
      bookingCutoffNotice: json['booking_cutoff_notice'] ?? 0,
      allowsSpecialRequirements: json['allows_special_requirements'] ?? false,
      fromDate: json['from_date'] != null
          ? DateTime.parse(json['from_date'])
          : DateTime.now(),
      toDate: json['to_date'] != null
          ? DateTime.parse(json['to_date'])
          : DateTime.now(),
      days: json['days'] != null
          ? Map<String, bool>.from(json['days'])
          : {
              'Mon': true,
              'Tue': true,
              'Wed': true,
              'Thu': true,
              'Fri': true,
              'Sat': true,
              'Sun': true,
            },
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      timeSlots: json['time_slots'] != null
          ? (json['time_slots'] as List)
                .map((item) => PujaTimeSlot.fromJson(item))
                .toList()
          : [],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temple_id': templeId,
      'puja_name': pujaName,
      'deities_name': deitiesName,
      'description': description,
      'maximum_no_of_devotees': maximumNoOfDevotees,
      'fee': fee,
      'sample_images': sampleImages,
      'booking_cutoff_notice': bookingCutoffNotice,
      'allows_special_requirements': allowsSpecialRequirements,
      'from_date': fromDate.toIso8601String(),
      'to_date': toDate.toIso8601String(),
      'days': days,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'time_slots': timeSlots.map((slot) => slot.toJson()).toList(),
      'is_active': isActive,
    };
  }
}

class PujaTimeSlot {
  final String id;
  final String pujaId;
  final String fromTime;
  final String toTime;

  PujaTimeSlot({
    required this.id,
    required this.pujaId,
    required this.fromTime,
    required this.toTime,
  });

  factory PujaTimeSlot.fromJson(Map<String, dynamic> json) {
    return PujaTimeSlot(
      id: json['id'] ?? '',
      pujaId: json['puja_id'] ?? '',
      fromTime: json['from_time'] ?? '',
      toTime: json['to_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'puja_id': pujaId,
      'from_time': fromTime,
      'to_time': toTime,
    };
  }
}
