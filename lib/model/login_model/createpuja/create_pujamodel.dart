
import 'package:flutter/material.dart';

class Puja {
  final String templeId;
  final String pujaName;
  final List<String> deitiesName;
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

  Puja({
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
    required this.timeSlots,
  });

  factory Puja.fromJson(Map<String, dynamic> json) {
    return Puja(
      templeId: json['temple_id'] as String,
      pujaName: json['puja_name'] as String,
      deitiesName: (json['deities_name'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String,
      maximumNoOfDevotees: json['maximumNoOfDevotees'] is int
          ? json['maximumNoOfDevotees'] as int
          : (json['maximumNoOfDevotees'] as num).toInt(),
      fee: (json['fee'] as num).toDouble(),
      sampleImages: (json['sample_images'] as List<dynamic>).map((e) => e as String).toList(),
      bookingCutoffNotice: json['booking_cutoff_notice'] is int
          ? json['booking_cutoff_notice'] as int
          : (json['booking_cutoff_notice'] as num).toInt(),
      allowsSpecialRequirements: json['allows_special_requirements'] as bool,
      fromDate: json['from_date'] as String,
      toDate: json['to_date'] as String,
      days: (json['days'] as List<dynamic>).map((e) => e as String).toList(),
      timeSlots: json['time_slots'] != null
          ? (json['time_slots'] as List<dynamic>)
              .map((ts) => TimeSlot.fromJson(ts as Map<String, dynamic>))
              .toList()
          : <TimeSlot>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temple_id': templeId,
      'puja_name': pujaName,
      'deities_name': deitiesName,
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
    };
  }

  static String _formatDate(DateTime dt) => "${dt.toIso8601String().split('T').first}"; 
}

class TimeSlot {
  final String fromTime; 
  final String toTime; 

  TimeSlot({required this.fromTime, required this.toTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      fromTime: json['fromTime'] as String,
      toTime: json['toTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromTime': fromTime,
      'toTime': toTime,
    };
  }

  TimeOfDay toTimeOfDayFrom() => _parseToTimeOfDay(fromTime);
  TimeOfDay toTimeOfDayTo() => _parseToTimeOfDay(toTime);

  static TimeOfDay _parseToTimeOfDay(String value) {
    final parts = value.split(':').map((s) => int.tryParse(s) ?? 0).toList();
    final hour = parts.isNotEmpty ? parts[0] : 0;
    final minute = parts.length > 1 ? parts[1] : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }
}


