import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';

/// مستودع المصادقة
abstract class AuthRepository {
  /// تسجيل حساب جديد
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  /// تسجيل الدخول
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  });

  /// تسجيل الخروج
  Future<Either<Failure, void>> signOut();

  /// استعادة كلمة المرور
  Future<Either<Failure, void>> resetPassword({required String email});

  /// الحصول على المستخدم الحالي
  Future<Either<Failure, UserModel?>> getCurrentUser();

  /// تحديث بيانات المستخدم
  Future<Either<Failure, UserModel>> updateUser({
    String? name,
    String? phone,
    String? bio,
    String? avatarUrl,
  });

  /// التحقق من البريد الإلكتروني
  Future<Either<Failure, void>> verifyEmail(String token);

  /// إعادة إرسال رابط التحقق
  Future<Either<Failure, void>> resendVerificationEmail();
}
