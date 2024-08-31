import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:parchi/core/constants/collections.dart';
import 'package:parchi/core/constants/constants.dart';
import 'package:parchi/core/failure.dart';
import 'package:parchi/core/providers/firebaseproviders.dart';
import 'package:parchi/core/typedefs.dart';
import 'package:parchi/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseFirestore: ref.read(fireStoreProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  AuthRepository({
    required firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _users =>
      _firebaseFirestore.collection(Collections.users);

  Future<Either<Failure, bool>> userExist(String phone) async {
    try {
      final user = await _users.where('phoneNumber', isEqualTo: phone).get();

      if (user.docs.isNotEmpty) {
        return right(true);
      } else {
        return right(false);
      }
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signUp(String firstName, String lastName,
      String phoneNumber, String password, String cnic) async {
    try {
      UserModel userModel = UserModel(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          password: password,
          cnic: cnic,
          profilePic: Constants.defaultAvatar,
          appointments: []);
      await _users.doc(phoneNumber).set(userModel.toMap());
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel?> getUserData(String phone) {
    return _users.doc(phone).snapshots().map((event) {
      final data = event.data();
      if (data == null) {
        return null;
      } else {
        return UserModel.fromMap(data as Map<String, dynamic>);
      }
    });
  }
}
