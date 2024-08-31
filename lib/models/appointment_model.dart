class AppointmentModel {
  String id;
  String patientPhone;
  String doctorName;
  String hospitalName;
  String appointmentDate;
  String appointmentTime;
  String fee;
  AppointmentModel({
    required this.id,
    required this.patientPhone,
    required this.doctorName,
    required this.hospitalName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.fee,
  });

  AppointmentModel copyWith({
    String? id,
    String? patientPhone,
    String? doctorName,
    String? hospitalName,
    String? appointmentDate,
    String? appointmentTime,
    String? fee,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientPhone: patientPhone ?? this.patientPhone,
      doctorName: doctorName ?? this.doctorName,
      hospitalName: hospitalName ?? this.hospitalName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      fee: fee ?? this.fee,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'patientPhone': patientPhone,
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'fee': fee,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as String,
      patientPhone: map['patientPhone'] as String,
      doctorName: map['doctorName'] as String,
      hospitalName: map['hospitalName'] as String,
      appointmentDate: map['appointmentDate'] as String,
      appointmentTime: map['appointmentTime'] as String,
      fee: map['fee'] as String,
    );
  }

  @override
  String toString() {
    return 'AppointmentModel(id: $id, patientPhone: $patientPhone, doctorName: $doctorName, hospitalName: $hospitalName, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, fee: $fee)';
  }

  @override
  bool operator ==(covariant AppointmentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.patientPhone == patientPhone &&
        other.doctorName == doctorName &&
        other.hospitalName == hospitalName &&
        other.appointmentDate == appointmentDate &&
        other.appointmentTime == appointmentTime &&
        other.fee == fee;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        patientPhone.hashCode ^
        doctorName.hashCode ^
        hospitalName.hashCode ^
        appointmentDate.hashCode ^
        appointmentTime.hashCode ^
        fee.hashCode;
  }
}
