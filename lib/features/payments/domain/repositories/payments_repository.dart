import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/provider_payment_settings_model.dart';

/// واجهة مستودع المدفوعات
abstract class PaymentsRepository {
  Future<Either<Failure, ProviderPaymentSettingsModel>>
      getProviderPaymentSettings(String providerId);

  Future<Either<Failure, PaymentModel>> submitPayment({
    required String courseId,
    required File receiptImage,
    required String transactionReference,
    required String paymentMethod,
    required double amount,
  });

  Future<Either<Failure, PaymentModel>> getPaymentById(String paymentId);

  Future<Either<Failure, List<PaymentModel>>> getMyPayments();

  Future<Either<Failure, PaymentModel>> resubmitPayment({
    required String paymentId,
    required File receiptImage,
    required String transactionReference,
  });
}
