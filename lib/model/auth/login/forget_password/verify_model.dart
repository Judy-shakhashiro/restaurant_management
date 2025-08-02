class VerifyModel {
  final bool status;
  final int statusCode;
  final String message;
  final String token;

  VerifyModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.token,
  });

  factory VerifyModel.fromJson(Map<String, dynamic> json) {
    return VerifyModel(
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
