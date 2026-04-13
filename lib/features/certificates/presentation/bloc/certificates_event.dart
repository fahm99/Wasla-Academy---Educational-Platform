part of 'certificates_bloc.dart';


/// أحداث الشهادات
abstract class CertificatesEvent extends Equatable {
  const CertificatesEvent();

  @override
  List<Object?> get props => [];
}

/// حدث: تحميل شهاداتي
class LoadMyCertificatesEvent extends CertificatesEvent {
  final String studentId;

  const LoadMyCertificatesEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

/// حدث: تحميل شهادة معينة
class LoadCertificateEvent extends CertificatesEvent {
  final String certificateId;

  const LoadCertificateEvent(this.certificateId);

  @override
  List<Object?> get props => [certificateId];
}

/// حدث: التحقق من شهادة
class VerifyCertificateEvent extends CertificatesEvent {
  final String certificateNumber;

  const VerifyCertificateEvent(this.certificateNumber);

  @override
  List<Object?> get props => [certificateNumber];
}

/// حدث: إنشاء شهادة
class GenerateCertificateEvent extends CertificatesEvent {
  final String courseId;
  final String studentId;
  final String providerId;

  const GenerateCertificateEvent({
    required this.courseId,
    required this.studentId,
    required this.providerId,
  });

  @override
  List<Object?> get props => [courseId, studentId, providerId];
}
