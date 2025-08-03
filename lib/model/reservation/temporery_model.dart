
class ConfirmationResponse {
  final bool status;
  final int statusCode;
  final String message;
  final ConfirmationData data;

  const ConfirmationResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ConfirmationResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmationResponse(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: ConfirmationData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ConfirmationData {
  final int revsId;
  final int depositValue;
  final int confirmationTime;
  final int tablesCount;
  final double cancellationInabilityHours;
  final double modificationInabilityHours;
  final String explanatoryNotes;

  const ConfirmationData({
    required this.revsId,
    required this.depositValue,
    required this.confirmationTime,
    required this.tablesCount,
    required this.cancellationInabilityHours,
    required this.modificationInabilityHours,
    required this.explanatoryNotes,
  });

  factory ConfirmationData.fromJson(Map<String, dynamic> json) {
    return ConfirmationData(
      revsId: json['revs_id'] as int? ?? 0,
      depositValue: json['deposit_value'] as int? ?? 0,
      confirmationTime: json['confirmation_time'] as int? ?? 0,
      tablesCount: json['tables_count'] as int? ?? 0,
      cancellationInabilityHours: (json['cancellation_inability_hours'] as num?)?.toDouble() ?? 0.0,
      modificationInabilityHours: (json['modification_inability_hours'] as num?)?.toDouble() ?? 0.0,
      explanatoryNotes: json['explanatory_notes'] as String? ?? '',
    );
  }
}