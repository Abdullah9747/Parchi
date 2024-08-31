import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/appointment/controller/appointment_controller.dart';
import 'package:parchi/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerStatefulWidget {
  const ProfileDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends ConsumerState<ProfileDrawer> {
  void navigateToAddHospital(BuildContext context) {
    Routemaster.of(context).push('/addhospital');
  }

  void navigateToAppointments(BuildContext context, String id) {
    Routemaster.of(context).push('/appointment/$id');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final authController = ref.watch(authControllerProvider.notifier);
    return Drawer(
      child: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListTile(
              title: const Text("Create Hospital"),
              leading: const Icon(Icons.add),
              onTap: () => navigateToAddHospital(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Appointments',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 20,
            ),
            ref.watch(getAppointmentProvider(user!.phoneNumber)).when(
                data: (appointments) {
                  return Container(
                    height: 500,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            onTap: () {
                              navigateToAppointments(context, appointment.id);
                            },
                            title: Text(appointment.hospitalName),
                            subtitle: Text(appointment.doctorName),
                            trailing: Text(appointment.appointmentDate),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader()),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                ),
                onPressed: () {
                  authController.signOut();
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ))
          ],
        ),
      )),
    );
  }
}
