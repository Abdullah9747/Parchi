import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:parchi/core/constants/collections.dart';
import 'package:parchi/core/failure.dart';
import 'package:parchi/core/providers/firebaseproviders.dart';
import 'package:parchi/core/typedefs.dart';
import 'package:parchi/models/doctor_model.dart';
import 'package:parchi/models/hospital_model.dart';

final hospitalRepositoryProvider = Provider((ref) {
  return HospitalRepository(
    firebaseFirestore: ref.read(fireStoreProvider),
    storage: ref.read(storageProvider),
  );
});

class HospitalRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _storage;

  HospitalRepository({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage storage,
  })  : _firebaseFirestore = firebaseFirestore,
        _storage = storage;

  CollectionReference get _hospitals =>
      _firebaseFirestore.collection(Collections.hospitals);

  FutureVoid addHospital(HospitalModel hospital, File? file) async {
    try {
      if (file != null) {
        String filePath =
            'hospitals/${hospital.uid}/${file.path.split('/').last}';
        UploadTask uploadTask = _storage.ref(filePath).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        hospital.profilePic = downloadUrl;
      }
      hospital.name = hospital.name.toLowerCase();
      await _hospitals.doc(hospital.uid).set(hospital.toMap());

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message!));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<HospitalModel>> searchHospital(String query) {
    query = query.toLowerCase();
    return _hospitals
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThanOrEqualTo: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .snapshots()
        .map((event) {
      List<HospitalModel> hospitals = [];
      for (var doc in event.docs) {
        hospitals
            .add(HospitalModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return hospitals;
    });
  }

  Future<List<HospitalModel>> getHospitals() async {
    final snapshot = await _hospitals.get();
    return snapshot.docs
        .map((e) => HospitalModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<HospitalModel>> getHOspitalsStream() {
    return _hospitals.snapshots().map((event) {
      List<HospitalModel> hospitals = [];
      for (var doc in event.docs) {
        hospitals
            .add(HospitalModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return hospitals;
    });
  }

  FutureVoid addDoctor(DoctorModel doctor, File? file, String id) async {
    try {
      if (file != null) {
        String filePath =
            'hospitals/$id/"docotors"/"${doctor.name}"/${file.path.split('/').last}';
        UploadTask uploadTask = _storage.ref(filePath).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        doctor.profilePic = downloadUrl;
      }
      return right(_hospitals.doc(id).update({
        'doctors': FieldValue.arrayUnion([doctor.toMap()]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<DoctorModel>> getDoctors(String id) {
    return _hospitals.doc(id).snapshots().map((event) {
      List<DoctorModel> doctors = [];
      final data = event.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('doctors')) {
        for (var doc in data['doctors']) {
          doctors.add(DoctorModel.fromMap(doc as Map<String, dynamic>));
        }
      }
      return doctors;
    });
  }

  Future<HospitalModel> getHospitalByID(String id) async {
    final snapshot = await _hospitals.doc(id).get();
    return HospitalModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }
}
