// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/local_storage/local_storage.dart';
import 'package:flutter_application/feature/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application/feature/intro/splash/splash_view.dart';
import 'package:flutter_application/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart' ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalStorage.init();
  //firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child:const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'se7ati App',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ar'),
        ],
        home: SplashView(),
      ),
    );
  }
}
