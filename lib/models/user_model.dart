import 'package:flutter/foundation.dart';

class UserModel {
  String firstName;
  String lastName;
  String profilePic;
  String phoneNumber;
  String password;
  String cnic;
  List<String> appointments;
  UserModel({
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.phoneNumber,
    required this.password,
    required this.cnic,
    required this.appointments,
  });

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? profilePic,
    String? phoneNumber,
    String? password,
    String? cnic,
    List<String>? appointments,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePic: profilePic ?? this.profilePic,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      cnic: cnic ?? this.cnic,
      appointments: appointments ?? this.appointments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'password': password,
      'cnic': cnic,
      'appointments': appointments,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      profilePic: map['profilePic'] as String,
      phoneNumber: map['phoneNumber'] as String,
      password: map['password'] as String,
      cnic: map['cnic'] as String,
      appointments: List<String>.from(map['appointments'] ?? []),
    );
  }

  @override
  String toString() {
    return 'UserModel(firstName: $firstName, lastName: $lastName, profilePic: $profilePic, phoneNumber: $phoneNumber, password: $password, cnic: $cnic, appointments: $appointments)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.profilePic == profilePic &&
        other.phoneNumber == phoneNumber &&
        other.password == password &&
        other.cnic == cnic &&
        listEquals(other.appointments, appointments);
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        profilePic.hashCode ^
        phoneNumber.hashCode ^
        password.hashCode ^
        cnic.hashCode ^
        appointments.hashCode;
  }
}
