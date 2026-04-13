import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/certificate.dart';
import '../repositories/certificates_repository.dart';

/// حالة استخدام: التحقق من شهادة
class VerifyCertificateUseCase {
  final CertificatesRepository repository;

  VerifyCertificateUseCase(this.repository);

  Future<Either<Failure, Certificate?>> call(String certificateNumber) async {
    return await repository.verifyCertificate(certificateNumber);
  }
}
