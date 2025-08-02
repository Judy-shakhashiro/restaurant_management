class ResetModel {
  final bool status;
  final int statusCode;
  final String message;

  ResetModel({
    required this.status,
    required this.statusCode,
    required this.message,
  });

  factory ResetModel.fromJson(Map<String, dynamic> json) {
    return ResetModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'message': message,
    };
  }
}
