class EmailConfirmModel {
  final bool status;
  final int statusCode;
  final String message;
  final String token;

  EmailConfirmModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.token,
  });

  factory EmailConfirmModel.fromJson(Map<String, dynamic> json) {
    return EmailConfirmModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'message': message,
      'token': token,
    };
  }
}
