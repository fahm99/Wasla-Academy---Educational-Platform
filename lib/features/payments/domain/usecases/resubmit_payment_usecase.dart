import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/payment_model.dart';
import '../repositories/payments_repository.dart';

class ResubmitPaymentParams {
  final String paymentId;
  final File receiptImage;
  final String transactionReference;

  ResubmitPaymentParams({
    required this.paymentId,
    required this.receiptImage,
    required this.transactionReference,
  });
}

class ResubmitPaymentUseCase {
  final PaymentsRepository repository;

  ResubmitPaymentUseCase(this.repository);

  Future<Either<Failure, PaymentModel>> call(
    ResubmitPaymentParams params,
  ) async {
    return await repository.resubmitPayment(
      paymentId: params.paymentId,
      receiptImage: params.receiptImage,
      transactionReference: params.transactionReference,
    );
  }
}
