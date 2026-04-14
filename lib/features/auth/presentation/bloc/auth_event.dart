part of 'auth_bloc.dart';

/// أحداث المصادقة
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// حدث تسجيل الدخول
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// حدث تسجيل حساب جديد
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String? phone;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
  });

  @override
  List<Object?> get props => [email, password, name, phone];
}

/// حدث تسجيل الخروج
class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

/// حدث استعادة كلمة المرور
class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// حدث تحميل المستخدم الحالي
class LoadCurrentUser extends AuthEvent {
  const LoadCurrentUser();
}

/// حدث التحقق من حالة المصادقة
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

/// حدث فرض تسجيل الخروج (Session Timeout / Token Expired)
class ForceLogout extends AuthEvent {
  final String? reason;

  const ForceLogout({this.reason});

  @override
  List<Object?> get props => [reason];
}
