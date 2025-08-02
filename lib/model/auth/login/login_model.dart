class LoginModel {
  final bool status;
  final int status_code;
  final String message;
  final String token;

  const LoginModel({
    required this.status,
    required this.status_code,
    required this.message,
    required this.token,
  });

  factory LoginModel.fromJson(Map<dynamic, dynamic> json) {
    return LoginModel(
      status: json['status'],
      status_code: json['status_code'],
      message: json['message'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': status_code,
      'message': message,
      'token': token,
    };
  }
}
