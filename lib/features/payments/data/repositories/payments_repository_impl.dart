import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/payments_repository.dart';
import '../datasources/payments_remote_datasource.dart';
import '../models/payment_model.dart';
import '../models/provider_payment_settings_model.dart';

/// تنفيذ مستودع المدفوعات
class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsRemoteDataSource remoteDataSource;

  PaymentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProviderPaymentSettingsModel>>
      getProviderPaymentSettings(String providerId) async {
    try {
      final settings =
          await remoteDataSource.getProviderPaymentSettings(providerId);
      return Right(settings);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentModel>> submitPayment({
    required String courseId,
    required File receiptImage,
    required String transactionReference,
    required String paymentMethod,
    required double amount,
  }) async {
    try {
      // Use retry for payment submission
      final payment = await ApiClient.executeWithRetry(
        request: () async {
          return await remoteDataSource.submitPayment(
            courseId: courseId,
            receiptImage: receiptImage,
            transactionReference: transactionReference,
            paymentMethod: paymentMethod,
            amount: amount,
          );
        },
        maxRetries: 3,
      );
      return Right(payment);
    } on UnauthorizedException catch (e) {
      // Handle 401 - trigger force logout
      AuthInterceptors.handleError(e);
      return Left(UnauthorizedFailure(message: e.message));
    } on FileException catch (e) {
      return Left(FileFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentModel>> getPaymentById(
    String paymentId,
  ) async {
    try {
      final payment = await remoteDataSource.getPaymentById(paymentId);
      return Right(payment);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentModel>>> getMyPayments() async {
    try {
      final payments = await remoteDataSource.getMyPayments();
      return Right(payments);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentModel>> resubmitPayment({
    required String paymentId,
    required File receiptImage,
    required String transactionReference,
  }) async {
    try {
      final payment = await remoteDataSource.resubmitPayment(
        paymentId: paymentId,
        receiptImage: receiptImage,
        transactionReference: transactionReference,
      );
      return Right(payment);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on FileException catch (e) {
      return Left(FileFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
