class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String? image;
  final String? birthdate;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    this.image,
    this.birthdate,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      mobile: json['mobile'] ?? "",
      image: json['image'],
      birthdate: json['birthdate'],
    );
  }
}
