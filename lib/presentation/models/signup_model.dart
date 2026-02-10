class SignupData {
  final String email;
  final String password;
  final String name;
  final DateTime? dob;
  final String gender;
  final String country;

  const SignupData({
    required this.email,
    this.password = '',
    this.name = '',
    this.dob,
    this.gender = '',
    this.country = '',
  });

  SignupData copyWith({
    String? password,
    String? name,
    DateTime? dob,
    String? gender,
    String? country,
  }) {
    return SignupData(
      email: email,
      password: password ?? this.password,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      country: country ?? this.country,
    );
  }
}
