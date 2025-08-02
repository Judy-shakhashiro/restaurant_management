class ForgetModel {
  final bool status;
  final int statusCode;
  final String message;

  ForgetModel({
    required this.status,
    required this.statusCode,
    required this.message,
  });

  factory ForgetModel.fromJson(Map<String, dynamic> json) {
    return ForgetModel(
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
