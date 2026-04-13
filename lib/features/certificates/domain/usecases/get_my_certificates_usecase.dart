import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/certificate.dart';
import '../repositories/certificates_repository.dart';

/// حالة استخدام: الحصول على شهاداتي
class GetMyCertificatesUseCase {
  final CertificatesRepository repository;

  GetMyCertificatesUseCase(this.repository);

  Future<Either<Failure, List<Certificate>>> call(String studentId) async {
    return await repository.getMyCertificates(studentId);
  }
}
