import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';

/// واجهة مستودع الملف الشخصي
abstract class ProfileRepository {
  /// الحصول على الملف الشخصي
  Future<Either<Failure, UserProfile>> getProfile(String userId);

  /// تحديث الملف الشخصي
  Future<Either<Failure, UserProfile>> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? bio,
  });

  /// رفع صورة الملف الشخصي
  Future<Either<Failure, String>> uploadAvatar(String userId, XFile imageFile);

  /// حذف صورة الملف الشخصي
  Future<Either<Failure, void>> deleteAvatar(String userId);
}
