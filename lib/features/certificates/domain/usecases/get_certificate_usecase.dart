import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/certificate.dart';
import '../repositories/certificates_repository.dart';

/// حالة استخدام: الحصول على شهادة معينة
class GetCertificateUseCase {
  final CertificatesRepository repository;

  GetCertificateUseCase(this.repository);

  Future<Either<Failure, Certificate>> call(String certificateId) async {
    return await repository.getCertificate(certificateId);
  }
}
