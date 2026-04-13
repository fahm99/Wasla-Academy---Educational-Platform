import 'dart:io';
import 'package:equatable/equatable.dart';

/// أحداث المدفوعات
abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل إعدادات الدفع للمقدم
class LoadProviderPaymentSettingsEvent extends PaymentsEvent {
  final String providerId;

  const LoadProviderPaymentSettingsEvent(this.providerId);

  @override
  List<Object?> get props => [providerId];
}

/// إرسال دفع جديد
class SubmitPaymentEvent extends PaymentsEvent {
  final String courseId;
  final File receiptImage;
  final String transactionReference;
  final String paymentMethod;
  final double amount;

  const SubmitPaymentEvent({
    required this.courseId,
    required this.receiptImage,
    required this.transactionReference,
    required this.paymentMethod,
    required this.amount,
  });

  @override
  List<Object?> get props => [
        courseId,
        receiptImage,
        transactionReference,
        paymentMethod,
        amount,
      ];
}

/// تحميل دفع محدد
class LoadPaymentByIdEvent extends PaymentsEvent {
  final String paymentId;

  const LoadPaymentByIdEvent(this.paymentId);

  @override
  List<Object?> get props => [paymentId];
}

/// تحميل جميع مدفوعاتي
class LoadMyPaymentsEvent extends PaymentsEvent {
  const LoadMyPaymentsEvent();
}

/// إعادة إرسال دفع مرفوض
class ResubmitPaymentEvent extends PaymentsEvent {
  final String paymentId;
  final File receiptImage;
  final String transactionReference;

  const ResubmitPaymentEvent({
    required this.paymentId,
    required this.receiptImage,
    required this.transactionReference,
  });

  @override
  List<Object?> get props => [paymentId, receiptImage, transactionReference];
}

/// إعادة تعيين الحالة
class ResetPaymentsStateEvent extends PaymentsEvent {
  const ResetPaymentsStateEvent();
}
