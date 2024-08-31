import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:parchi/core/constants/collections.dart';
import 'package:parchi/core/failure.dart';
import 'package:parchi/core/providers/firebaseproviders.dart';
import 'package:parchi/core/typedefs.dart';
import 'package:parchi/models/appointment_model.dart';

final appointmentRepositoryProvider = Provider((ref) {
  return AppointmentRepository(firebaseFirestore: ref.read(fireStoreProvider));
});

class AppointmentRepository {
  final FirebaseFirestore _firebaseFirestore;
  AppointmentRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _appointments =>
      _firebaseFirestore.collection(Collections.appointments);

  FutureVoid addAppointment(AppointmentModel appointment) async {
    try {
      await _firebaseFirestore
          .collection(Collections.users)
          .doc(appointment.patientPhone)
          .update({
        'appointments': FieldValue.arrayUnion([appointment.id])
      });
      return right(
          await _appointments.doc(appointment.id).set(appointment.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  Stream<List<AppointmentModel>> getAppointments(String phoneNumber) {
    return _appointments
        .where('patientPhone', isEqualTo: phoneNumber)
        .snapshots()
        .map((event) {
      final List<AppointmentModel> appointments = [];
      for (final doc in event.docs) {
        appointments
            .add(AppointmentModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return appointments;
    });
  }

  Future<AppointmentModel> getAppointmentByID(String id) async {
    final doc = await _appointments.doc(id).get();
    return AppointmentModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}
