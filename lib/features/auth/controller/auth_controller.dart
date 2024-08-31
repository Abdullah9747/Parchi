import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/utils.dart';
import 'package:parchi/features/auth/repository/auth_repository.dart';
import 'package:parchi/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final passwordErrorProvider = StateProvider<bool>((ref) => false);
final userExistErrorProvider = StateProvider<bool>((ref) => true);
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref);
});
final userProvider = StateProvider<UserModel?>((ref) => null);
final initialLoginStateProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
});
final isLoggedInProvider = StateProvider<bool>((ref) {
  final initialLoginState = ref
      .watch(initialLoginStateProvider)
      .maybeWhen(orElse: () => false, data: (value) => value);
  return initialLoginState;
});
final isLoggedInStreamProvider = StreamProvider<bool>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  return Stream.value(isLoggedIn);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  void signIn(BuildContext context, String phone, String password) async {
    state = true;
    final userExist = await _authRepository.userExist(phone);
    userExist.fold((l) => showSnakBar(context, l.message), (r) async {
      if (r) {
        final user1 = _authRepository.getUserData(phone);

        final user = await user1.first;
        if (user != null) {
          _ref.watch(userExistErrorProvider.notifier).update((state) => true);
          final userpass = user.password;
          if (BCrypt.checkpw(password, userpass)) {
            _ref.read(isLoggedInProvider.notifier).state = true;
            _ref.watch(userProvider.notifier).update((state) => user);
            _ref.watch(passwordErrorProvider.notifier).update((state) => false);
            _ref.watch(userProvider.notifier).update((state) => user);
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', true);
            prefs.setString('phoneNumber', phone);
          } else {
            _ref.watch(passwordErrorProvider.notifier).update((state) => true);
          }
        } else {
          _ref.watch(userExistErrorProvider.notifier).update((state) => false);
        }
      } else {
        showSnakBar(context, "User does not exist");
      }
    });
    state = false;
  }

  void signOut() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('phoneNumber');
    _ref.watch(userProvider.notifier).update((state) => null);
    _ref.read(isLoggedInProvider.notifier).state = false;
    state = false;
  }

  void signUp(BuildContext context, String firstName, String lastName,
      String phoneNumber, String password, String cnic) async {
    state = true;
    final userExist = await _authRepository.userExist(phoneNumber);
    userExist.fold((l) => showSnakBar(context, l.message), (r) async {
      if (r) {
        showSnakBar(context, "User with same Phone already exists");
      } else {
        password = BCrypt.hashpw(password, BCrypt.gensalt());
        final res = await _authRepository.signUp(
            firstName, lastName, phoneNumber, password, cnic);
        res.fold(
          (failure) => showSnakBar(context, failure.message),
          (user) async {
            _ref.watch(userProvider.notifier).update((state) => user);
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', true);
            prefs.setString('phoneNumber', phoneNumber);
            _ref.read(isLoggedInProvider.notifier).state = true;
          },
        );
      }
      state = false;
    });
  }

  Future<UserModel?> getUserData(String phone) {
    return _authRepository.getUserData(phone).first;
  }

  Future<bool> userExists(String phone) async {
    final userExist = await _authRepository.userExist(phone);
    return userExist.fold((l) => false, (r) => r);
  }
}
