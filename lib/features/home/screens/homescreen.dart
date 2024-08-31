import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/auth/controller/auth_controller.dart';
import 'package:parchi/features/home/delegate/search_hospital_delegate.dart';
import 'package:parchi/features/home/drawer/menudrawer.dart';
import 'package:parchi/features/home/drawer/profile_drawer.dart';
import 'package:parchi/features/hospital/controller/hospital_controller.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<HomeScreen> {
  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void navigateToSeeDoctor(BuildContext context, String id) {
    Routemaster.of(context).push('/seedoctor/$id');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: false,
        title: const Text(
          'Parchi',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 29,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(233, 241, 241, 241),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchHospitalDelegate(ref: ref),
              );
            },
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayEndDrawer(context),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user!.profilePic),
              ),
            );
          })
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Hospitals",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ref.watch(hospitalStreamProvider).when(
                  data: (hospitals) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final hospital = hospitals[index];
                        hospital.name = hospital.name[0].toUpperCase() +
                            hospital.name.substring(1);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1976D2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () =>
                                    navigateToSeeDoctor(context, hospital.uid),
                                child: const Text(
                                  "See Departs",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              onTap: () {},
                              title: Text(
                                hospital.name,
                                softWrap: true,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              leading: AspectRatio(
                                aspectRatio: 1, // Adjust ratio if needed
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(hospital.profilePic),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align items to start
                                children: [
                                  const Icon(Icons.pin_drop),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Text(
                                        hospital.location,
                                        style: const TextStyle(fontSize: 12),
                                        softWrap: true, // Allow text to wrap
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: hospitals.length,
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
          ),
        ],
      ),
      endDrawer: const ProfileDrawer(),
      drawer: const Menudrawer(),
    );
  }
}
