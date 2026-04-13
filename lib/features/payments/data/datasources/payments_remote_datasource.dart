import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/payment_model.dart';
import '../models/provider_payment_settings_model.dart';

/// مصدر البيانات البعيد للمدفوعات
abstract class PaymentsRemoteDataSource {
  Future<ProviderPaymentSettingsModel> getProviderPaymentSettings(
      String providerId);
  Future<PaymentModel> submitPayment({
    required String courseId,
    required File receiptImage,
    required String transactionReference,
    required String paymentMethod,
    required double amount,
  });
  Future<PaymentModel> getPaymentById(String paymentId);
  Future<List<PaymentModel>> getMyPayments();
  Future<PaymentModel> resubmitPayment({
    required String paymentId,
    required File receiptImage,
    required String transactionReference,
  });
}

class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  final SupabaseClient client;

  PaymentsRemoteDataSourceImpl({required this.client});

  @override
  Future<ProviderPaymentSettingsModel> getProviderPaymentSettings(
    String providerId,
  ) async {
    try {
      final response = await client
          .from('provider_payment_settings')
          .select()
          .eq('provider_id', providerId)
          .single();

      return ProviderPaymentSettingsModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const NotFoundException(message: 'إعدادات الدفع غير موجودة');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaymentModel> submitPayment({
    required String courseId,
    required File receiptImage,
    required String transactionReference,
    required String paymentMethod,
    required double amount,
  }) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw const UnauthorizedException(message: 'المستخدم غير مسجل الدخول');
      }

      // جلب معلومات الكورس
      final courseResponse = await client
          .from(ApiConstants.coursesTable)
          .select('id, title, provider_id, price')
          .eq('id', courseId)
          .single();

      final providerId = courseResponse['provider_id'] as String;

      // رفع صورة الإيصال
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'receipts/$fileName';

      await client.storage
          .from('payment-receipts')
          .upload(filePath, receiptImage);

      final receiptUrl =
          client.storage.from('payment-receipts').getPublicUrl(filePath);

      // إنشاء سجل الدفع
      final response = await client
          .from(ApiConstants.paymentsTable)
          .insert({
            'student_id': userId,
            'course_id': courseId,
            'provider_id': providerId,
            'amount': amount,
            'payment_method': paymentMethod,
            'receipt_image_url': receiptUrl,
            'transaction_reference': transactionReference,
            'status': ApiConstants.paymentStatusPending,
            'payment_date': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } on StorageException catch (e) {
      throw FileException(message: 'فشل رفع صورة الإيصال: ${e.message}');
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is FileException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaymentModel> getPaymentById(String paymentId) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw const UnauthorizedException(message: 'المستخدم غير مسجل الدخول');
      }

      final response = await client
          .from(ApiConstants.paymentsTable)
          .select()
          .eq('id', paymentId)
          .eq('student_id', userId)
          .single();

      return PaymentModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const NotFoundException(message: 'الدفع غير موجود');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PaymentModel>> getMyPayments() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw const UnauthorizedException(message: 'المستخدم غير مسجل الدخول');
      }

      final response = await client
          .from(ApiConstants.paymentsTable)
          .select()
          .eq('student_id', userId)
          .order('payment_date', ascending: false);

      return (response as List)
          .map((json) => PaymentModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaymentModel> resubmitPayment({
    required String paymentId,
    required File receiptImage,
    required String transactionReference,
  }) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw const UnauthorizedException(message: 'المستخدم غير مسجل الدخول');
      }

      // التحقق من أن الدفع مرفوض
      final existingPayment = await getPaymentById(paymentId);
      if (existingPayment.status != ApiConstants.paymentStatusRejected) {
        throw const ValidationException(
          message: 'لا يمكن إعادة إرسال دفع غير مرفوض',
        );
      }

      // رفع صورة الإيصال الجديدة
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'receipts/$fileName';

      await client.storage
          .from('payment-receipts')
          .upload(filePath, receiptImage);

      final receiptUrl =
          client.storage.from('payment-receipts').getPublicUrl(filePath);

      // تحديث سجل الدفع
      final response = await client
          .from(ApiConstants.paymentsTable)
          .update({
            'receipt_image_url': receiptUrl,
            'transaction_reference': transactionReference,
            'status': ApiConstants.paymentStatusPending,
            'rejection_reason': null,
            'verified_at': null,
            'verified_by': null,
            'payment_date': DateTime.now().toIso8601String(),
          })
          .eq('id', paymentId)
          .eq('student_id', userId)
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } on StorageException catch (e) {
      throw FileException(message: 'فشل رفع صورة الإيصال: ${e.message}');
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ValidationException) rethrow;
      if (e is FileException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
