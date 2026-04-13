import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/certificate.dart';

/// واجهة مستودع الشهادات
abstract class CertificatesRepository {
  /// الحصول على شهادات الطالب
  Future<Either<Failure, List<Certificate>>> getMyCertificates(
      String studentId);

  /// الحصول على شهادة معينة
  Future<Either<Failure, Certificate>> getCertificate(String certificateId);

  /// التحقق من شهادة برقمها
  Future<Either<Failure, Certificate?>> verifyCertificate(
      String certificateNumber);

  /// إنشاء شهادة جديدة
  Future<Either<Failure, Certificate>> generateCertificate({
    required String courseId,
    required String studentId,
    required String providerId,
  });
}
