import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/auth/controller/auth_controller.dart';
import 'package:parchi/features/auth/screens/textformfield.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void navigateToSignupScreen() {
    Routemaster.of(context).push('/signup');
  }

  void signIn(BuildContext context, String phone, String password) {
    final authController = ref.watch(authControllerProvider.notifier);
    authController.signIn(context, phone, password);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final double size = MediaQuery.of(context).size.width;
    final isPasswordError = ref.watch(passwordErrorProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        title: const Text(
          'Parchi',
          style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(233, 241, 241, 241)),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Form(
              key: _loginFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      const SizedBox(height: 60),
                      Textformfield(
                        controller: _phoneController,
                        hintText: 'Phone e.g 03001234567',
                        isphone: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          final phoneRegExp = RegExp(r'^\d{11}$');
                          if (!phoneRegExp.hasMatch(value)) {
                            return 'Phone number must be exactly 11 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Textformfield(
                        controller: _passwordController,
                        hintText: 'Password',
                        ispass: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          final passwordRegExp = RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                          if (!passwordRegExp.hasMatch(value)) {
                            return 'Password should contain at least 8 char,numbers and special characters';
                          }
                          return null;
                        },
                      ),
                      if (isPasswordError == true)
                        const Text("Incorrect Password",
                            style: TextStyle(color: Colors.red)),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(size * 0.70, 45),
                          backgroundColor:
                              const Color.fromARGB(255, 30, 114, 241),
                        ),
                        onPressed: () {
                          if (_loginFormKey.currentState?.validate() ?? false) {
                            signIn(context, _phoneController.text,
                                _passwordController.text);
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          TextButton(
                            onPressed: () {
                              if (isPasswordError == false) {
                                navigateToSignupScreen();
                              }
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
