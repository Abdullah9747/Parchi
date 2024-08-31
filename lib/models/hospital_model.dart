import 'package:flutter/foundation.dart';

import 'package:parchi/models/doctor_model.dart';

class HospitalModel {
  String uid;
  String name;
  String location;
  String profilePic;
  List<DoctorModel> doctors;
  HospitalModel({
    required this.uid,
    required this.name,
    required this.location,
    required this.profilePic,
    required this.doctors,
  });

  HospitalModel copyWith({
    String? uid,
    String? name,
    String? location,
    String? profilePic,
    List<DoctorModel>? doctors,
  }) {
    return HospitalModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      location: location ?? this.location,
      profilePic: profilePic ?? this.profilePic,
      doctors: doctors ?? this.doctors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'location': location,
      'profilePic': profilePic,
      'doctors': doctors.map((x) => x.toMap()).toList(),
    };
  }

  factory HospitalModel.fromMap(Map<String, dynamic> map) {
    return HospitalModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      location: map['location'] as String,
      profilePic: map['profilePic'] as String,
      doctors: List<DoctorModel>.from(
        (map['doctors'] as List<dynamic>? ?? []).map<DoctorModel>(
          (x) => DoctorModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'HospitalModel(uid: $uid, name: $name, location: $location, profilePic: $profilePic, doctors: $doctors)';
  }

  @override
  bool operator ==(covariant HospitalModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.location == location &&
        other.profilePic == profilePic &&
        listEquals(other.doctors, doctors);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        location.hashCode ^
        profilePic.hashCode ^
        doctors.hashCode;
  }
}
