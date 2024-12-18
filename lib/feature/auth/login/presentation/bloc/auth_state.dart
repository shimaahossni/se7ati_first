// feature/auth/login/presentation/bloc/auth_state.dart
part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

//register
class RegisterLoadingstate extends AuthState {}

class RegisterSuccessstate extends AuthState {}

//login
class LoginLoadingstate extends AuthState {}

class LoginSuccessstate extends AuthState {
  final String userType;
  LoginSuccessstate({required this.userType});
}

//update doctor profile
class DoctorRegisterationLoadingstate extends AuthState {}

class DoctorRegisterationSuccessstate extends AuthState {}

//error
class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState({required this.error});
}
