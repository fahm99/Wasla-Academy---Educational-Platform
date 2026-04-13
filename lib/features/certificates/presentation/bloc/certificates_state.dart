part of 'certificates_bloc.dart';

/// حالات الشهادات
abstract class CertificatesState extends Equatable {
  const CertificatesState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class CertificatesInitial extends CertificatesState {}

/// حالة التحميل
class CertificatesLoading extends CertificatesState {}

/// حالة تحميل الشهادات بنجاح
class MyCertificatesLoaded extends CertificatesState {
  final List<Certificate> certificates;

  const MyCertificatesLoaded(this.certificates);

  @override
  List<Object?> get props => [certificates];
}

/// حالة تحميل شهادة معينة بنجاح
class CertificateLoaded extends CertificatesState {
  final Certificate certificate;

  const CertificateLoaded(this.certificate);

  @override
  List<Object?> get props => [certificate];
}

/// حالة التحقق من الشهادة
class CertificateVerified extends CertificatesState {
  final Certificate? certificate;

  const CertificateVerified(this.certificate);

  @override
  List<Object?> get props => [certificate];
}

/// حالة إنشاء الشهادة بنجاح
class CertificateGenerated extends CertificatesState {
  final Certificate certificate;

  const CertificateGenerated(this.certificate);

  @override
  List<Object?> get props => [certificate];
}

/// حالة الخطأ
class CertificatesError extends CertificatesState {
  final String message;

  const CertificatesError(this.message);

  @override
  List<Object?> get props => [message];
}
