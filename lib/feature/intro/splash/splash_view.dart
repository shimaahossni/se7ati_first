// feature/intro/splash/splash_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/services/local_storage/local_storage.dart';
import 'package:flutter_application/feature/intro/onboard/presentation/onboard_view.dart';
import 'package:flutter_application/feature/intro/welcome/presentation/welcome_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      bool isOnboardingShown =
          AppLocalStorage.getCachedData(key: AppLocalStorage.onboarding) ??
              false;

      if (isOnboardingShown) {
        pushReplacement(context, const WelcomeView());
      } else {
        pushReplacement(context, const OnboardView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 250,
        ),
      ),
    );
  }
}
