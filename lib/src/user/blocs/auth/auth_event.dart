part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  List<Object> get props => [name, email, password, phone];
}

class LogoutRequested extends AuthEvent {}

class LoadUserFromStorage extends AuthEvent {}

class UpdateUserProgress extends AuthEvent {
  final List<int>? enrolledCourses;
  final List<int>? completedCourses;
  final List<Certificate>? certificates;
  final List<UserExam>? exams;

  const UpdateUserProgress({
    this.enrolledCourses,
    this.completedCourses,
    this.certificates,
    this.exams,
  });

  @override
  List<Object> get props => [
        enrolledCourses ?? [],
        completedCourses ?? [],
        certificates ?? [],
        exams ?? [],
      ];
}
