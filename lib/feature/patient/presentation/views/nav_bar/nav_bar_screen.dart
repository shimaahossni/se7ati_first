// feature/patient/presentation/views/nav_bar/nav_bar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/feature/patient/presentation/views/appointment/views/patient_appointment.dart';
import 'package:flutter_application/feature/patient/presentation/views/home/oresentation/views/home.dart';
import 'package:flutter_application/feature/patient/presentation/views/profile/presentation/views/patient_profile_screen.dart';
import 'package:flutter_application/feature/patient/presentation/views/search/views/patient_search.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _selectedIndex = 0;
  final List _pages = [
    PatientHome(),
    PatientSearch(),
    PatientAppointment(),
    PatientProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.2),
            ),
          ],
        ),
        child: GNav(
          curve: Curves.easeOutExpo,
          rippleColor: Colors.grey,
          hoverColor: Colors.grey,
          haptic: true,
          tabBorderRadius: 20,
          gap: 5,
          activeColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.blueColor,
          textStyle: getBodyStyle(color: AppColors.whiteColor),
          tabs: const [
            GButton(
              iconSize: 28,
              icon: Icons.home,
              text: 'الرئيسية',
            ),
            GButton(
              icon: Icons.search,
              text: 'البحث',
            ),
            GButton(
              iconSize: 28,
              icon: Icons.calendar_month_rounded,
              text: 'المواعيد',
            ),
            GButton(
              iconSize: 29,
              icon: Icons.person,
              text: 'الحساب',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
    );
    ;
  }
}
