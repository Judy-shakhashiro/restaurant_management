import 'package:flutter_application_restaurant/model/reservation/available-days_model.dart';
import 'package:flutter_application_restaurant/model/reservation/temporery_model.dart';
import 'package:flutter_application_restaurant/model/reservation/time_model.dart';
import 'dart:convert';

class ReservationModificationData {
  final int minPeople;
  final int maxPeople;
  final int maxRevsDurationHours;
  final RevsData revsData;
  final List<AvailableDate> availableDates;
  final TimeSlotsModel timeSlots;


  ReservationModificationData({
    required this.minPeople,
    required this.maxPeople,
    required this.maxRevsDurationHours,
    required this.revsData,
    required this.availableDates,
    required this.timeSlots,
  });

  factory ReservationModificationData.fromJson(Map<String, dynamic> json) {
    // Assuming the JSON structure matches the provided example.
    final List<dynamic> availableDateList = json['available_date'];
    final List<AvailableDate> parsedAvailableDates = availableDateList
        .map((e) => AvailableDate.fromJson(e as Map<String, dynamic>))
        .toList();

    return ReservationModificationData(
      minPeople: json['min_people'] as int,
      maxPeople: json['max_people'] as int,
      maxRevsDurationHours: json['max_revs_duration_hours'] as int,
      revsData: RevsData.fromJson(json['revs_data'] as Map<String, dynamic>),
      availableDates: parsedAvailableDates,
      timeSlots: TimeSlotsModel.fromJson({'time_slots': json['time_slots']}),
    );
  }
}

class RevsData {
  final int id;
  final String revsDate;
  final String revsDuration;
  final int guestsCount;
  final String revsTime;
  final String type;

  RevsData({
    required this.id,
    required this.revsDate,
    required this.revsDuration,
    required this.guestsCount,
    required this.revsTime,
    required this.type,
  });

  factory RevsData.fromJson(Map<String, dynamic> json) {
    return RevsData(
      id: json['id'] as int,
      revsDate: json['revs_date'] as String,
      revsDuration: json['revs_duration'] as String,
      guestsCount: json['guests_count'] as int,
      revsTime: json['revs_time'] as String,
      type: json['type'] as String,
    );
  }
}


