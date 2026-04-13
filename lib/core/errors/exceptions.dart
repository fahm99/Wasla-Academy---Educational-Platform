/// استثناءات مخصصة للتطبيق
library;

/// استثناء عام للخادم
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// استثناء المصادقة
class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AuthException: $message (Code: $code)';
}

/// استثناء الشبكة
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    required this.message,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// استثناء التخزين المحلي
class CacheException implements Exception {
  final String message;

  const CacheException({
    required this.message,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// استثناء التحقق من الصحة
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  const ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// استثناء الملف
class FileException implements Exception {
  final String message;

  const FileException({
    required this.message,
  });

  @override
  String toString() => 'FileException: $message';
}

/// استثناء الدفع
class PaymentException implements Exception {
  final String message;
  final String? code;

  const PaymentException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'PaymentException: $message (Code: $code)';
}

/// استثناء غير متوقع
class UnexpectedException implements Exception {
  final String message;
  final dynamic originalException;

  const UnexpectedException({
    required this.message,
    this.originalException,
  });

  @override
  String toString() => 'UnexpectedException: $message';
}

/// استثناء عدم التصريح
class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({
    required this.message,
  });

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// استثناء عدم العثور
class NotFoundException implements Exception {
  final String message;

  const NotFoundException({
    required this.message,
  });

  @override
  String toString() => 'NotFoundException: $message';
}

/// استثناء التعارض
class ConflictException implements Exception {
  final String message;

  const ConflictException({
    required this.message,
  });

  @override
  String toString() => 'ConflictException: $message';
}
