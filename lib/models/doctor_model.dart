class DoctorModel {
  String name;
  String speciality;
  String profilePic;
  String starttiming;
  String endtiming;
  String fee;
  DoctorModel({
    required this.name,
    required this.speciality,
    required this.profilePic,
    required this.starttiming,
    required this.endtiming,
    required this.fee,
  });

  DoctorModel copyWith({
    String? name,
    String? speciality,
    String? profilePic,
    String? starttiming,
    String? endtiming,
    String? fee,
  }) {
    return DoctorModel(
      name: name ?? this.name,
      speciality: speciality ?? this.speciality,
      profilePic: profilePic ?? this.profilePic,
      starttiming: starttiming ?? this.starttiming,
      endtiming: endtiming ?? this.endtiming,
      fee: fee ?? this.fee,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'speciality': speciality,
      'profilePic': profilePic,
      'starttiming': starttiming,
      'endtiming': endtiming,
      'fee': fee,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      name: map['name'] as String,
      speciality: map['speciality'] as String,
      profilePic: map['profilePic'] as String,
      starttiming: map['starttiming'] as String,
      endtiming: map['endtiming'] as String,
      fee: map['fee'] as String,
    );
  }

  @override
  String toString() {
    return 'DoctorModel(name: $name, speciality: $speciality, profilePic: $profilePic, starttiming: $starttiming, endtiming: $endtiming, fee: $fee)';
  }

  @override
  bool operator ==(covariant DoctorModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.speciality == speciality &&
        other.profilePic == profilePic &&
        other.starttiming == starttiming &&
        other.endtiming == endtiming &&
        other.fee == fee;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        speciality.hashCode ^
        profilePic.hashCode ^
        starttiming.hashCode ^
        endtiming.hashCode ^
        fee.hashCode;
  }
}
