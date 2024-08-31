import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/utils.dart';
import 'package:parchi/features/appointment/repository/appointment_repository.dart';
import 'package:parchi/models/appointment_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final appointmentControllerProvider =
    StateNotifierProvider<AppointmentController, bool>((ref) {
  final appointmentRepository = ref.watch(appointmentRepositoryProvider);
  return AppointmentController(appointmentRepository: appointmentRepository);
});

final getAppointmentByIdProvider = FutureProvider.family((ref, String id) {
  return ref
      .watch(appointmentControllerProvider.notifier)
      .getAppointmentByID(id);
});

final getAppointmentProvider = StreamProvider.family((ref, String phoneNumber) {
  return ref
      .watch(appointmentControllerProvider.notifier)
      .getAppointments(phoneNumber);
});

class AppointmentController extends StateNotifier<bool> {
  final AppointmentRepository _appointmentRepository;
  AppointmentController({required AppointmentRepository appointmentRepository})
      : _appointmentRepository = appointmentRepository,
        super(false);

  void addAppointment(
      String patientPhone,
      String doctorName,
      String hospitalName,
      String appointmentDate,
      String appointmentTime,
      String fee,
      BuildContext context) async {
    state = true;
    final id = const Uuid().v4();
    final AppointmentModel appointment = AppointmentModel(
        id: id,
        patientPhone: patientPhone,
        doctorName: doctorName,
        hospitalName: hospitalName,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        fee: fee);

    final res = await _appointmentRepository.addAppointment(appointment);
    res.fold((l) => showSnakBar(context, "Appointment Booking Unsuccessful"),
        (r) {
      showSnakBar(context, "Appointment Booked");
      Routemaster.of(context).push('/appointment/$id');
    });
    state = false;
  }

  Stream<List<AppointmentModel>> getAppointments(String phoneNumber) {
    return _appointmentRepository.getAppointments(phoneNumber);
  }

  Future<AppointmentModel> getAppointmentByID(String id) async {
    return _appointmentRepository.getAppointmentByID(id);
  }
}
