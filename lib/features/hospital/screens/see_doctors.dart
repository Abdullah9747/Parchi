import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/appointment/controller/appointment_controller.dart';
import 'package:parchi/features/auth/controller/auth_controller.dart';
import 'package:parchi/features/hospital/controller/hospital_controller.dart';
import 'package:routemaster/routemaster.dart';

class SeeDoctorsScreen extends ConsumerStatefulWidget {
  final String id;
  const SeeDoctorsScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeeDoctorsScreenState();
}

class _SeeDoctorsScreenState extends ConsumerState<SeeDoctorsScreen> {
  void navigateToHome(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  void addAppointment(
      BuildContext context, String doctorName, String timing, String fee) {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final user = ref.read(userProvider);
    ref.read(getHospitalByIdProvider(widget.id)).when(
        data: (hospital) {
          ref.read(appointmentControllerProvider.notifier).addAppointment(
              user!.phoneNumber,
              doctorName,
              hospital.name,
              formattedDate,
              timing,
              fee,
              context);
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        title: const Text(
          'Departments',
          style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(233, 241, 241, 241)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                navigateToHome(context);
              },
              icon: const Icon(Icons.home)),
        ],
      ),
      body: ref.watch(getDoctorsProvider(widget.id)).when(
          data: (doctors) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio:
                      0.7, // Adjust the aspect ratio to fit your needs
                ),
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(doctor.profilePic),
                                radius: 35,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                doctor.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              // Text(
                              //   doctor.speciality,
                              //   style: const TextStyle(
                              //       fontSize: 15, fontWeight: FontWeight.bold),
                              //   textAlign: TextAlign.center,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              // const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.punch_clock_rounded),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.blue[300],
                                    ),
                                    child: Text(
                                      '${doctor.starttiming} - ${doctor.endtiming}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 10, 56, 93)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1976D2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (doctor.endtiming.compareTo(
                                            DateFormat('HH:mm')
                                                .format(DateTime.now())) <
                                        0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Doctor is not available right now'),
                                        ),
                                      );
                                      return;
                                    }
                                    addAppointment(context, doctor.name,
                                        doctor.starttiming, doctor.fee);
                                  },
                                  child: const Text(
                                    'Book Appointment',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: doctors.length,
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
