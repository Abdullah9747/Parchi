import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/hospital/controller/hospital_controller.dart';
import 'package:routemaster/routemaster.dart';

class Menudrawer extends ConsumerStatefulWidget {
  const Menudrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenudrawerState();
}

class _MenudrawerState extends ConsumerState<Menudrawer> {
  void navigateToAddDoctor(String id, BuildContext context) {
    Routemaster.of(context).push('/adddoctor/$id');
  }

  @override
  Widget build(BuildContext context) {
    final hospitalController = ref.watch(hospitalControllerProvider.notifier);
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: SafeArea(
        child: FutureBuilder(
          future: hospitalController.getHospitals(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Loader(),
              );
            } else if (snapshot.hasError) {
              return const ErrorText(error: "Error loading hospitals");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No hospitals found");
            } else {
              final hospitals = snapshot.data!;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final hospital = hospitals[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () =>
                              navigateToAddDoctor(hospital.uid, context),
                          title: Text(hospital.name),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(hospital.profilePic),
                          ),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.pin_drop),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Text(hospital.location,
                                    style: const TextStyle(fontSize: 12)),
                              )
                            ],
                          )),
                    ),
                  );
                },
                itemCount: hospitals.length,
              );
            }
          },
        ),
      ),
    );
  }
}
