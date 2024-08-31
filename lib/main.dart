import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/auth/controller/auth_controller.dart';
import 'package:parchi/models/user_model.dart';
import 'package:parchi/router.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? user;
  bool isLoading = true;

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber');

    if (phoneNumber != null) {
      final userexist =
          ref.watch(authControllerProvider.notifier).userExists(phoneNumber);
      final userExist = await userexist;

      if (userExist) {
        final user1 =
            ref.read(authControllerProvider.notifier).getUserData(phoneNumber);

        user = await user1;

        ref.read(userProvider.notifier).update((state) => user);
      } else {
        user = null;
        ref.read(userProvider.notifier).update((state) => null);
      }
    } else {
      user = null;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(isLoggedInStreamProvider).when(
        data: (isLoggedIn) {
          if (isLoading) {
            return const Loader();
          }

          return MaterialApp.router(
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                user = ref.watch(userProvider);
                if (isLoggedIn == true && user != null) {
                  return loggedinRoute;
                }
                return loggedoutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromRGBO(249, 248, 248, 1),
            ),
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
