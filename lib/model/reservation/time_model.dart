
class TimeSlotsModel {
  final bool status;
  final int statusCode;
  final String message;
  final TimeSlots timeSlots;

  const TimeSlotsModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.timeSlots,
  });

  factory TimeSlotsModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotsModel(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      timeSlots: TimeSlots.fromJson(json['time_slots']),
    );
  }
}

class TimeSlots {
  final List<String> indoor;
  final List<String> outdoor;

  const TimeSlots({
    required this.indoor,
    required this.outdoor,
  });

  factory TimeSlots.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final indoorList = (json['indoor'] as List<dynamic>?)?.whereType<String>().toList() ?? [];
      final outdoorList = (json['outdoor'] as List<dynamic>?)?.whereType<String>().toList() ?? [];
      return TimeSlots(
        indoor: indoorList,
        outdoor: outdoorList,
      );
    } else {
      return TimeSlots(
        indoor: [],
        outdoor: [],
      );
    }
  }
}