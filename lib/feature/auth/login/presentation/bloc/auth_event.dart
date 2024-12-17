// feature/auth/login/presentation/bloc/auth_event.dart
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final UserType userType;
  RegisterEvent(
      {required this.email,
      required this.password,
      required this.name,
      required this.userType});
}

class loginEvent extends AuthEvent {
  final String email;
  final String password;
  loginEvent({required this.email, required this.password});
}

//update doctor profile
class UpdateDoctorDataEvent extends AuthEvent {
  final DoctorModel doctorModel;
  UpdateDoctorDataEvent({required this.doctorModel});
}
