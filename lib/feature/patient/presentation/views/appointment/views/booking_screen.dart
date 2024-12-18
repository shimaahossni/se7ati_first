// feature/patient/presentation/views/appointment/views/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/feature/auth/login/data/doctor_model.dart';

class BookingScreen extends StatelessWidget {
  DoctorModel doctor;
  BookingScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
