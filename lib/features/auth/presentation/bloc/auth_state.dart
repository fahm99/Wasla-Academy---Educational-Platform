part of 'auth_bloc.dart';

/// حالات المصادقة
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class AuthInitial extends AuthState {}

/// حالة التحميل
class AuthLoading extends AuthState {}

/// حالة المصادقة الناجحة
class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// حالة عدم المصادقة
class Unauthenticated extends AuthState {}

/// حالة الخطأ
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// حالة إرسال رابط استعادة كلمة المرور
class PasswordResetSent extends AuthState {
  final String email;

  const PasswordResetSent({required this.email});

  @override
  List<Object?> get props => [email];
}
