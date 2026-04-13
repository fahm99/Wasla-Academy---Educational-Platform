import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/payment_model.dart';
import '../repositories/payments_repository.dart';

class SubmitPaymentParams {
  final String courseId;
  final File receiptImage;
  final String transactionReference;
  final String paymentMethod;
  final double amount;

  SubmitPaymentParams({
    required this.courseId,
    required this.receiptImage,
    required this.transactionReference,
    required this.paymentMethod,
    required this.amount,
  });
}

class SubmitPaymentUseCase {
  final PaymentsRepository repository;

  SubmitPaymentUseCase(this.repository);

  Future<Either<Failure, PaymentModel>> call(
    SubmitPaymentParams params,
  ) async {
    return await repository.submitPayment(
      courseId: params.courseId,
      receiptImage: params.receiptImage,
      transactionReference: params.transactionReference,
      paymentMethod: params.paymentMethod,
      amount: params.amount,
    );
  }
}
