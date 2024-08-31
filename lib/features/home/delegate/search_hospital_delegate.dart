import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/hospital/controller/hospital_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchHospitalDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchHospitalDelegate({required this.ref});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  void navigateToSeeDoctors(BuildContext context, String id) {
    ref.read(hospitalControllerProvider.notifier).getHospitalByID(id);
    Routemaster.of(context).push('/seedoctor/$id');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchHospitalProvider(query)).when(
        data: (hospitals) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final hospital = hospitals[index];
              return ListTile(
                title: Text(hospital.name),
                subtitle: Row(
                  children: [
                    const Icon(Icons.pin_drop),
                    Text(hospital.location,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                onTap: () {
                  navigateToSeeDoctors(context, hospital.uid);
                },
              );
            },
            itemCount: hospitals.length,
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
