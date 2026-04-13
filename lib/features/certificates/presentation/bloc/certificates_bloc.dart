import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/certificate.dart';
import '../../domain/usecases/get_my_certificates_usecase.dart';
import '../../domain/usecases/get_certificate_usecase.dart';
import '../../domain/usecases/verify_certificate_usecase.dart';
import '../../domain/usecases/generate_certificate_usecase.dart';

part 'certificates_event.dart';
part 'certificates_state.dart';

/// Bloc لإدارة حالة الشهادات
class CertificatesBloc extends Bloc<CertificatesEvent, CertificatesState> {
  final GetMyCertificatesUseCase getMyCertificatesUseCase;
  final GetCertificateUseCase getCertificateUseCase;
  final VerifyCertificateUseCase verifyCertificateUseCase;
  final GenerateCertificateUseCase generateCertificateUseCase;

  CertificatesBloc({
    required this.getMyCertificatesUseCase,
    required this.getCertificateUseCase,
    required this.verifyCertificateUseCase,
    required this.generateCertificateUseCase,
  }) : super(CertificatesInitial()) {
    on<LoadMyCertificatesEvent>(_onLoadMyCertificates);
    on<LoadCertificateEvent>(_onLoadCertificate);
    on<VerifyCertificateEvent>(_onVerifyCertificate);
    on<GenerateCertificateEvent>(_onGenerateCertificate);
  }

  Future<void> _onLoadMyCertificates(
    LoadMyCertificatesEvent event,
    Emitter<CertificatesState> emit,
  ) async {
    emit(CertificatesLoading());

    final result = await getMyCertificatesUseCase(event.studentId);

    result.fold(
      (failure) => emit(CertificatesError(failure.message)),
      (certificates) => emit(MyCertificatesLoaded(certificates)),
    );
  }

  Future<void> _onLoadCertificate(
    LoadCertificateEvent event,
    Emitter<CertificatesState> emit,
  ) async {
    emit(CertificatesLoading());

    final result = await getCertificateUseCase(event.certificateId);

    result.fold(
      (failure) => emit(CertificatesError(failure.message)),
      (certificate) => emit(CertificateLoaded(certificate)),
    );
  }

  Future<void> _onVerifyCertificate(
    VerifyCertificateEvent event,
    Emitter<CertificatesState> emit,
  ) async {
    emit(CertificatesLoading());

    final result = await verifyCertificateUseCase(event.certificateNumber);

    result.fold(
      (failure) => emit(CertificatesError(failure.message)),
      (certificate) => emit(CertificateVerified(certificate)),
    );
  }

  Future<void> _onGenerateCertificate(
    GenerateCertificateEvent event,
    Emitter<CertificatesState> emit,
  ) async {
    emit(CertificatesLoading());

    final result = await generateCertificateUseCase(
      courseId: event.courseId,
      studentId: event.studentId,
      providerId: event.providerId,
    );

    result.fold(
      (failure) => emit(CertificatesError(failure.message)),
      (certificate) => emit(CertificateGenerated(certificate)),
    );
  }
}
