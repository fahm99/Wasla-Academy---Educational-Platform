import 'package:equatable/equatable.dart';

/// فشل عام
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// فشل الخادم
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

/// فشل المصادقة
class AuthFailure extends Failure {
  final String? code;

  const AuthFailure({
    required String message,
    this.code,
  }) : super(message);

  @override
  List<Object?> get props => [message, code];
}

/// فشل الشبكة
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'لا يوجد اتصال بالإنترنت',
  }) : super(message);
}

/// فشل التخزين المحلي
class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
  }) : super(message);
}

/// فشل التحقق من الصحة
class ValidationFailure extends Failure {
  final Map<String, String>? errors;

  const ValidationFailure({
    required String message,
    this.errors,
  }) : super(message);

  @override
  List<Object?> get props => [message, errors];
}

/// فشل الملف
class FileFailure extends Failure {
  const FileFailure({
    required String message,
  }) : super(message);
}

/// فشل الدفع
class PaymentFailure extends Failure {
  final String? code;

  const PaymentFailure({
    required String message,
    this.code,
  }) : super(message);

  @override
  List<Object?> get props => [message, code];
}

/// فشل غير متوقع
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    String message = 'حدث خطأ غير متوقع',
  }) : super(message);
}

/// فشل عدم التصريح
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required String message,
  }) : super(message);
}

/// فشل عدم العثور
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required String message,
  }) : super(message);
}

/// فشل التعارض
class ConflictFailure extends Failure {
  const ConflictFailure({
    required String message,
  }) : super(message);
}
