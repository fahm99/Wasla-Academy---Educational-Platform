import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_provider_payment_settings_usecase.dart';
import '../../domain/usecases/submit_payment_usecase.dart';
import '../../domain/usecases/get_payment_by_id_usecase.dart';
import '../../domain/usecases/get_my_payments_usecase.dart';
import '../../domain/usecases/resubmit_payment_usecase.dart';
import 'payments_event.dart';
import 'payments_state.dart';

/// Bloc للمدفوعات
class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final GetProviderPaymentSettingsUseCase getProviderPaymentSettingsUseCase;
  final SubmitPaymentUseCase submitPaymentUseCase;
  final GetPaymentByIdUseCase getPaymentByIdUseCase;
  final GetMyPaymentsUseCase getMyPaymentsUseCase;
  final ResubmitPaymentUseCase resubmitPaymentUseCase;

  PaymentsBloc({
    required this.getProviderPaymentSettingsUseCase,
    required this.submitPaymentUseCase,
    required this.getPaymentByIdUseCase,
    required this.getMyPaymentsUseCase,
    required this.resubmitPaymentUseCase,
  }) : super(PaymentsInitial()) {
    on<LoadProviderPaymentSettingsEvent>(_onLoadProviderPaymentSettings);
    on<SubmitPaymentEvent>(_onSubmitPayment);
    on<LoadPaymentByIdEvent>(_onLoadPaymentById);
    on<LoadMyPaymentsEvent>(_onLoadMyPayments);
    on<ResubmitPaymentEvent>(_onResubmitPayment);
    on<ResetPaymentsStateEvent>(_onResetState);
  }

  Future<void> _onLoadProviderPaymentSettings(
    LoadProviderPaymentSettingsEvent event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(PaymentsLoading());

    final result = await getProviderPaymentSettingsUseCase(event.providerId);

    result.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (settings) => emit(PaymentSettingsLoaded(settings)),
    );
  }

  Future<void> _onSubmitPayment(
    SubmitPaymentEvent event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(PaymentsLoading());

    final params = SubmitPaymentParams(
      courseId: event.courseId,
      receiptImage: event.receiptImage,
      transactionReference: event.transactionReference,
      paymentMethod: event.paymentMethod,
      amount: event.amount,
    );

    final result = await submitPaymentUseCase(params);

    result.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (payment) => emit(PaymentSubmitted(payment)),
    );
  }

  Future<void> _onLoadPaymentById(
    LoadPaymentByIdEvent event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(PaymentsLoading());

    final result = await getPaymentByIdUseCase(event.paymentId);

    result.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (payment) => emit(PaymentLoaded(payment)),
    );
  }

  Future<void> _onLoadMyPayments(
    LoadMyPaymentsEvent event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(PaymentsLoading());

    final result = await getMyPaymentsUseCase();

    result.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (payments) => emit(PaymentsListLoaded(payments)),
    );
  }

  Future<void> _onResubmitPayment(
    ResubmitPaymentEvent event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(PaymentsLoading());

    final params = ResubmitPaymentParams(
      paymentId: event.paymentId,
      receiptImage: event.receiptImage,
      transactionReference: event.transactionReference,
    );

    final result = await resubmitPaymentUseCase(params);

    result.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (payment) => emit(PaymentResubmitted(payment)),
    );
  }

  void _onResetState(
    ResetPaymentsStateEvent event,
    Emitter<PaymentsState> emit,
  ) {
    emit(PaymentsInitial());
  }
}
