import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/certificate.dart';
import '../repositories/certificates_repository.dart';

/// حالة استخدام: إنشاء شهادة
class GenerateCertificateUseCase {
  final CertificatesRepository repository;

  GenerateCertificateUseCase(this.repository);

  Future<Either<Failure, Certificate>> call({
    required String courseId,
    required String studentId,
    required String providerId,
  }) async {
    return await repository.generateCertificate(
      courseId: courseId,
      studentId: studentId,
      providerId: providerId,
    );
  }
}
