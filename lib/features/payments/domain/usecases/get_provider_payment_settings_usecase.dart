import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/provider_payment_settings_model.dart';
import '../repositories/payments_repository.dart';

class GetProviderPaymentSettingsUseCase {
  final PaymentsRepository repository;

  GetProviderPaymentSettingsUseCase(this.repository);

  Future<Either<Failure, ProviderPaymentSettingsModel>> call(
    String providerId,
  ) async {
    return await repository.getProviderPaymentSettings(providerId);
  }
}
