class Reservation {
  final int id;
  final String type;
  final int tablesCount;
  final String revsDate;
  final String revsTime;
  final String revsDuration;
  final int guestsCount;
  final String status;
  final double? depositValue;
  final bool? acceptedCancellability;
  final bool? cancellabilityNow;
  final bool? acceptedModifiability;
  final bool? modifiabilityNow;
  // New attributes for detailed reservation view
  final String? depositStatus;
  final String? note;
  final String? createdAt;
  final int? cancellationInabilityHours;
  final int? modificationInabilityHours;
  final int? autoNoShowMinutes;

  Reservation({
    required this.id,
    required this.type,
    required this.tablesCount,
    required this.revsDate,
    required this.revsTime,
    required this.revsDuration,
    required this.guestsCount,
    required this.status,
    this.depositValue,
    this.acceptedCancellability,
    this.cancellabilityNow,
    this.acceptedModifiability,
    this.modifiabilityNow,
    this.depositStatus,
    this.note,
    this.createdAt,
    this.cancellationInabilityHours,
    this.modificationInabilityHours,
    this.autoNoShowMinutes,
  });

  // A factory constructor to create a Reservation object from JSON data.
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as int,
      type: json['type'] as String,
      tablesCount: json['tables_count'] as int,
      revsDate: json['revs_date'] as String,
      revsTime: json['revs_time'] as String,
      revsDuration: json['revs_duration'] as String,
      guestsCount: json['guests_count'] as int,
      status: json['status'] as String,
      depositValue: (json['deposit_value'] as num?)?.toDouble(),
      acceptedCancellability: json['revs_accepted_cancellability'] as bool?,
      cancellabilityNow: json['revs_cancellability_now'] as bool?,
      acceptedModifiability: json['revs_accepted_modifiability'] as bool?,
      modifiabilityNow: json['revs_modifiability_now'] as bool?,
      // Parse new attributes
      depositStatus: json['deposit_status'] as String?,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String?,
      cancellationInabilityHours: json['cancellation_inability_hours'] as int?,
      modificationInabilityHours: json['modification_inability_hours'] as int?,
      autoNoShowMinutes: json['auto_no_show_minutes'] as int?,
    );
  }
}