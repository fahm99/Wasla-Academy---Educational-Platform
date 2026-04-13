import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/payment_model.dart';
import '../repositories/payments_repository.dart';

class GetMyPaymentsUseCase {
  final PaymentsRepository repository;

  GetMyPaymentsUseCase(this.repository);

  Future<Either<Failure, List<PaymentModel>>> call() async {
    return await repository.getMyPayments();
  }
}
