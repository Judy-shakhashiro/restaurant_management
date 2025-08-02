import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  final bool status;
  final int statusCode;
  final String message;
  final User user;

  RegisterModel({
    required this.status,
    required this.statusCode,
     required this.message,
     required this.user,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      status: json['status'] ,
      statusCode: json['status_code'] , 
      message: json['message'] ,
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'message': message,
      'user': user.toJson(),
    };
  }
}
class User {
  final String first_name;
  final String last_name;
  final String mobile;
  final String email;
  final DateTime createdAt;
  final int? id;

  User({
    required  this.first_name,
     required this.last_name,
     required this.mobile,
    required  this.email,
     required this.createdAt,
      this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      first_name: json['first_name'] ,
      last_name: json['last_name'] ,
      mobile: json['mobile'] ,
      email: json['email'] ,
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'mobile': mobile,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'id': id,
    };
  }
}
