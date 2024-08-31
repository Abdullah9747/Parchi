import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/appointment/controller/appointment_controller.dart';
import 'package:parchi/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  final String id;
  const AppointmentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  void navigateToHome(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  @override
  Widget build(BuildContext context) {
    final appointment = ref.watch(getAppointmentByIdProvider(widget.id));
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        title: const Text(
          'Appointment',
          style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(233, 241, 241, 241)),
        ),
        leading: IconButton(
            onPressed: () {
              navigateToHome(context);
            },
            icon: const Icon(Icons.home)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              appointment.when(
                data: (data) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            const Text(
                              "Patient Name : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(
                              '${user!.firstName} ${user.lastName}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          children: [
                            const Text(
                              "Doctor Name : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(
                              data.doctorName,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          children: [
                            const Text(
                              "Hospital Name : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(
                              data.hospitalName,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          children: [
                            const Text(
                              "Appointment Date : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(
                              data.appointmentDate,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          children: [
                            const Text(
                              "Appointment Time : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(
                              data.appointmentTime,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          children: [
                            const Text(
                              "Fee : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(
                              data.fee,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1976D2),
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/barcode.jpeg'),
                                fit: BoxFit.cover),
                          ),
                        )
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
