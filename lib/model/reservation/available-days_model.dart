class AvailableDaysModel {
  final bool status;
  final int statusCode;
  final String message;
  final Data data;

  const AvailableDaysModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AvailableDaysModel.fromJson(Map<String, dynamic> json) {
    return AvailableDaysModel(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: Data.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Data {
  final int minPeople;
  int maxPeople;
  final int maxRevsDurationHours;
  final List<AvailableDate> availableDate;

  Data({
    required this.minPeople,
    required this.maxPeople,
    required this.maxRevsDurationHours,
    required this.availableDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      minPeople: json['min_people'] as int? ?? 1,
      maxPeople: json['max_people'] as int? ?? 10,
      maxRevsDurationHours: json['max_revs_duration_hours'] as int? ?? 8,
      availableDate: (json['available_date'] as List<dynamic>?)
              ?.map((e) => AvailableDate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AvailableDate {
  final DateTime date;
  final bool isAvailable;
  final String? reason;

  const AvailableDate({
    required this.date,
    required this.isAvailable,
    this.reason,
  });

  factory AvailableDate.fromJson(Map<String, dynamic> json) {
    return AvailableDate(
      date: DateTime.parse(json['date'] as String? ?? '2025-01-01'),
      isAvailable: json['is_available'] as bool? ?? false,
      reason: json['reason'] as String?,
    );
  }
}