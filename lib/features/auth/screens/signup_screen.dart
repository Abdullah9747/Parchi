import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/auth/controller/auth_controller.dart';
import 'package:parchi/features/auth/screens/textformfield.dart';
import 'package:routemaster/routemaster.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _cinicController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _cinicController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cinicController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signUp(BuildContext context, String firstName, String lastName,
      String phoneNumber, String password, String cnic) {
    final authController = ref.watch(authControllerProvider.notifier);
    authController.signUp(
        context, firstName, lastName, phoneNumber, password, cnic);
  }

  void navigateToLoginScreen() {
    Routemaster.of(context).push('/');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final double size = MediaQuery.of(context).size.width;
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
              key: _signUpFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      const SizedBox(height: 60),
                      Textformfield(
                        hintText: 'First Name',
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter First name';
                          }
                          final nameRegExp = RegExp(r'^[a-zA-Z]+$');
                          if (!nameRegExp.hasMatch(value)) {
                            return 'Name can only contain alphabets';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Textformfield(
                        controller: _lastNameController,
                        hintText: 'Last Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Last name';
                          }
                          final nameRegExp = RegExp(r'^[a-zA-Z]+$');
                          if (!nameRegExp.hasMatch(value)) {
                            return 'Name can only contain alphabets';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      Textformfield(
                        controller: _cinicController,
                        hintText: 'CNIC  e.g. 12345-1234567-1',
                        iscnic: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your CNIC';
                          }
                          final cnicRegExp = RegExp(r'^\d{5}-\d{7}-\d{1}$');
                          if (!cnicRegExp.hasMatch(value)) {
                            return 'CNIC must be in the format 12345-1234567-1';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(size * 0.70, 45),
                          backgroundColor:
                              const Color.fromARGB(255, 30, 114, 241),
                        ),
                        onPressed: () {
                          if (_signUpFormKey.currentState?.validate() ??
                              false) {
                            // Form is valid, proceed with sign-up
                            // Add your sign-up logic here
                            signUp(
                                context,
                                _firstNameController.text,
                                _lastNameController.text,
                                _phoneController.text,
                                _passwordController.text,
                                _cinicController.text);
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
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              navigateToLoginScreen();
                            },
                            child: const Text(
                              'Sign In',
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
