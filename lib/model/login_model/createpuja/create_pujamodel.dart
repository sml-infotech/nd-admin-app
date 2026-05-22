import 'package:flutter/material.dart';

class Puja {
  final String? templeId;
  final String? pujaId;
  final String pujaName;
  final List<String> deitiesName;
  final List<String> benefits;
  final String description;
  final int maximumNoOfDevotees;
  final double fee;
  final List<String> sampleImages;
  final int bookingCutoffNotice;
  final bool allowsSpecialRequirements;
  final String fromDate;
  final String toDate;
  final List<String> days;
  final List<TimeSlot> timeSlots;
  final bool requires_prasad_address;
  final String prasad_delivery_charges;
  final List<Translation> translations;

  Puja({
    this.templeId,
    this.pujaId,
    required this.pujaName,
    required this.deitiesName,
    required this.benefits,
    required this.description,
    required this.maximumNoOfDevotees,
    required this.fee,
    required this.sampleImages,
    required this.bookingCutoffNotice,
    required this.allowsSpecialRequirements,
    required this.fromDate,
    required this.toDate,
    required this.days,
    required this.timeSlots,
    required this.requires_prasad_address,
    required this.prasad_delivery_charges,
    required this.translations,
  });

  factory Puja.fromJson(Map<String, dynamic> json) {
    return Puja(
      templeId: json['temple_id'] as String?,
      pujaId: json['puja_id'] as String?,
      pujaName: json['puja_name'] as String,
      deitiesName: (json['deities_name'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      benefits: (json['benefits'] as List<dynamic>?)
          ?.map((e) => e as String)
              .toList() ??
          [],
      description: json['description'] as String,
      maximumNoOfDevotees: json['maximumNoOfDevotees'] is int
          ? json['maximumNoOfDevotees'] as int
          : (json['maximumNoOfDevotees'] as num).toInt(),
      fee: (json['fee'] as num).toDouble(),
      sampleImages: (json['sample_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      bookingCutoffNotice: json['booking_cutoff_notice'] is int
          ? json['booking_cutoff_notice'] as int
          : (json['booking_cutoff_notice'] as num).toInt(),
      allowsSpecialRequirements: json['allows_special_requirements'] as bool,
      fromDate: json['from_date'] as String,
      toDate: json['to_date'] as String,
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      timeSlots: (json['time_slots'] as List<dynamic>?)
              ?.map((ts) => TimeSlot.fromJson(ts as Map<String, dynamic>))
              .toList() ??
          [],
      requires_prasad_address: json['requires_prasad_address'] as bool? ?? false,
      prasad_delivery_charges: json['prasad_delivery_charges'] as String? ?? '',

      translations: (json['translations'] as List<dynamic>?)
              ?.map((t) => Translation.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temple_id': templeId,
      'puja_id': pujaId,
      'puja_name': pujaName,
      'deities_name': deitiesName,
      'benefits': benefits,
      'description': description,
      'maximumNoOfDevotees': maximumNoOfDevotees,
      'fee': fee,
      'sample_images': sampleImages,
      'booking_cutoff_notice': bookingCutoffNotice,
      'allows_special_requirements': allowsSpecialRequirements,
      'from_date': fromDate,
      'to_date': toDate,
      'days': days,
      'time_slots': timeSlots.map((t) => t.toJson()).toList(),
      'requires_prasad_address': requires_prasad_address,
      'prasad_delivery_charges': prasad_delivery_charges,
      'translations': translations.map((t) => t.toJson()).toList(),
    };
  }

  static String _formatDate(DateTime dt) =>
      "${dt.toIso8601String().split('T').first}";
}

class TimeSlot {
  final String fromTime; 
  final String toTime;   

  TimeSlot({
    required this.fromTime,
    required this.toTime,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      fromTime: json['fromTime'] as String? ?? '',
      toTime: json['toTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'fromTime': fromTime,
        'toTime': toTime,
      };

  @override
  String toString() => '$fromTime - $toTime';
}
class Benefit {
  final String description;

  Benefit({required this.description});

  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(description: json['description'] as String);
  }

  Map<String, dynamic> toJson() => {
        'description': description,
      };
}

class Translation {
  final String languageCode;
  final String pujaName;
  final String description;
  final List<String> deityNames;
  final List<String> benefits;

Translation({
    required this.languageCode,
    required this.pujaName,
    required this.description,
    required this.deityNames,
    required this.benefits,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      languageCode: json['language_code'] ?? '',
      pujaName: json['puja_name'] ?? '',
      description: json['description'] ?? '',
      deityNames: json['deities_name'] != null
          ? List<String>.from(json['deities_name'])
          : [],
      benefits: json['benefits'] != null
          ? List<String>.from(json['benefits'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'puja_name': pujaName,
      'description': description,
      'deities_name': deityNames,
      'benefits': benefits,
    };
  }
}
