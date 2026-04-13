import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/payment_model.dart';
import '../repositories/payments_repository.dart';

class GetPaymentByIdUseCase {
  final PaymentsRepository repository;

  GetPaymentByIdUseCase(this.repository);

  Future<Either<Failure, PaymentModel>> call(String paymentId) async {
    return await repository.getPaymentById(paymentId);
  }
}
