import 'package:flutter/material.dart';
import 'package:parchi/features/appointment/screens/appointment_screen.dart';
import 'package:parchi/features/auth/screens/login_screen.dart';
import 'package:parchi/features/auth/screens/signup_screen.dart';
import 'package:parchi/features/home/screens/homescreen.dart';
import 'package:parchi/features/hospital/screens/add_doctors.dart';
import 'package:parchi/features/hospital/screens/add_hospital_screen.dart';
import 'package:parchi/features/hospital/screens/see_doctors.dart';
import 'package:routemaster/routemaster.dart';

final loggedoutRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: LoginScreen()),
  "/signup": (_) => const MaterialPage(child: SignupScreen()),
});

final loggedinRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: HomeScreen()),
  "/addhospital": (_) => const MaterialPage(child: AddHospitalScreen()),
  "/adddoctor/:id": (routeData) => MaterialPage(
        child: AddDoctorsScreen(
          id: routeData.pathParameters['id']!,
        ),
      ),
  "/seedoctor/:id": (routeData) => MaterialPage(
        child: SeeDoctorsScreen(
          id: routeData.pathParameters['id']!,
        ),
      ),
  "/appointment/:id": (routeData) => MaterialPage(
        child: AppointmentScreen(
          id: routeData.pathParameters['id']!,
        ),
      ),
});
