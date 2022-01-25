import 'dart:convert';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String password;
  final String phoneNumber;

  UserModel({
    required this.email,
    required this.name,
    required this.password,
    required this.phoneNumber,
    required this.uid,
  });

  UserModel copyWith({
    required String email,
    required String name,
    required String uid,
    required String password,
  }) {
    return UserModel(
      email: email,
      name: name,
      password: password,
      phoneNumber: phoneNumber,
      uid: uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      email: map?['email'],
      name: map?['name'],
      password: map?['password'],
      phoneNumber: map?['phoneNumber'],
      uid: map?['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PhoneAuthModel(email: $email, name: $name, password: $password, phoneNumber: $phoneNumber, uid: $uid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserModel &&
        o.email == email &&
        o.name == name &&
        o.password == password &&
        o.phoneNumber == phoneNumber &&
        o.uid == uid;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        password.hashCode ^
        phoneNumber.hashCode ^
        uid.hashCode;
  }
}
