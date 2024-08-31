import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/constants/constants.dart';
import 'package:parchi/core/utils.dart';
import 'package:parchi/features/hospital/repository/hospital_repository.dart';
import 'package:parchi/models/doctor_model.dart';
import 'package:parchi/models/hospital_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final getHospitalByIdProvider = FutureProvider.family((ref, String id) {
  return ref.watch(hospitalControllerProvider.notifier).getHospitalByID(id);
});

final getDoctorsProvider = StreamProvider.family((ref, String id) {
  return ref.watch(hospitalControllerProvider.notifier).getDoctors(id);
});

final searchHospitalProvider = StreamProvider.family((ref, String query) {
  return ref.watch(hospitalControllerProvider.notifier).searchHospital(query);
});

final hospitalStreamProvider = StreamProvider((ref) {
  return ref.watch(hospitalControllerProvider.notifier).getHOspitalsStream();
});

final hospitalControllerProvider =
    StateNotifierProvider<HospitalController, bool>((ref) {
  final hospitalrepoistory = ref.watch(hospitalRepositoryProvider);
  return HospitalController(hospitalRepository: hospitalrepoistory);
});

class HospitalController extends StateNotifier<bool> {
  final HospitalRepository _hospitalRepository;
  HospitalController({required HospitalRepository hospitalRepository})
      : _hospitalRepository = hospitalRepository,
        super(false);

  Stream<List<HospitalModel>> searchHospital(String query) {
    return _hospitalRepository.searchHospital(query);
  }

  void addHospital(String name, String location, File? hospitalimage,
      BuildContext context) async {
    state = true;
    String uid = const Uuid().v4();
    HospitalModel hospital = HospitalModel(
        uid: uid,
        name: name,
        location: location,
        profilePic: hospitalimage != null
            ? hospitalimage.path
            : Constants.buildingDefault,
        doctors: []);
    final res = await _hospitalRepository.addHospital(hospital, hospitalimage);
    res.fold((l) => showSnakBar(context, "Hospital creation Unsuccessful"),
        (r) => Routemaster.of(context).pop());
    state = false;
  }

  Future<List<HospitalModel>> getHospitals(BuildContext context) async {
    try {
      final hospitals = await _hospitalRepository.getHospitals();
      return hospitals;
    } catch (e) {
      ErrorText(error: e.toString());
      return [];
    }
  }

  void addDoctor(
      String name,
      String starttime,
      String endtime,
      String speciality,
      String fee,
      File? profilePic,
      BuildContext context,
      String hospitalid) async {
    state = true;
    final DoctorModel doctor = DoctorModel(
        name: name,
        speciality: speciality,
        profilePic:
            profilePic != null ? profilePic.path : Constants.defaultAvatar,
        starttiming: starttime,
        endtiming: endtime,
        fee: fee);
    final res =
        await _hospitalRepository.addDoctor(doctor, profilePic, hospitalid);
    res.fold((l) => showSnakBar(context, "Doctor creation Unsuccessful"), (r) {
      showSnakBar(context, "Doctor creation Successful");
    });
    state = false;
  }

  Stream<List<HospitalModel>> getHOspitalsStream() {
    return _hospitalRepository.getHOspitalsStream();
  }

  Stream<List<DoctorModel>> getDoctors(String id) {
    return _hospitalRepository.getDoctors(id);
  }

  Future<HospitalModel> getHospitalByID(String id) async {
    final hospital = await _hospitalRepository.getHospitalByID(id);
    return hospital;
  }
}
