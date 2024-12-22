// feature/auth/login/presentation/bloc/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/core/enums/user_type_enum.dart';
import 'package:flutter_application/feature/auth/login/data/doctor_model.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>(register);
    on<loginEvent>(login);
    on<UpdateDoctorDataEvent>(updateDoctorProfile);
  }

//register
  static Future<void> register(
      RegisterEvent event, Emitter<AuthState> emit) async {
    emit(RegisterLoadingstate());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      User? user = credential.user;
      user?.uid;
      await user?.updateDisplayName(event.name);
      await user?.updatePhotoURL(event.userType.toString());
      //firestore
      if (event.userType == UserType.doctor) {
        FirebaseFirestore.instance.collection('doctors').doc(user?.uid).set({
          'name': event.name,
          'email': event.email,
          'password': event.password,
          'image': '',
          'specialization': '',
          'rating': '',
          'phone1': '',
          'phone2': '',
          'bio': '',
          'openHour': '',
          'closeHour': '',
          'uid': user?.uid,
          'address': '',
        });
      } else {
        FirebaseFirestore.instance.collection('patients').doc(user?.uid).set({
          'name': event.name,
          'email': event.email,
          'image': '',
          'age': '',
          'phone': '',
          'bio': '',
          'address': '',
          'uid': user?.uid,
        });
      }

      print(user?.uid);
      emit(RegisterSuccessstate());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthErrorState(error: 'الباسورد ضعيف'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthErrorState(error: 'البريد الالكتروني مستخدم بالفعل'));
      } else {
        emit(AuthErrorState(error: 'حدث خطأ ما'));
      }
    } catch (e) {
      emit(AuthErrorState(error: 'حدث خطأ ما'));
    }
  }

//login
  static Future<void> login(loginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingstate());
    try {
      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(LoginSuccessstate(userType: credential.user!.photoURL ?? ""));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState(error: 'البريد الالكتروني غير موجود'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState(error: 'الباسورد غير صحيح'));
      } else {
        emit(AuthErrorState(error: 'حدث خطأ ما'));
      }
    }
  }

  //update doctor profile
  static Future<void> updateDoctorProfile(
      UpdateDoctorDataEvent event, Emitter<AuthState> emit) async {
    emit(DoctorRegisterationLoadingstate());
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(event.doctorModel.uid)
          .update(event.doctorModel.toJson());
      emit(DoctorRegisterationSuccessstate());
    } catch (e) {
      emit(AuthErrorState(error: 'حدث خطأ ما'));
    }
  }
}
