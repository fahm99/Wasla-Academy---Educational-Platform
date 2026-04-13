import 'package:equatable/equatable.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/provider_payment_settings_model.dart';

/// حالات المدفوعات
abstract class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class PaymentsInitial extends PaymentsState {}

/// جاري التحميل
class PaymentsLoading extends PaymentsState {}

/// تم تحميل إعدادات الدفع
class PaymentSettingsLoaded extends PaymentsState {
  final ProviderPaymentSettingsModel settings;

  const PaymentSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// تم إرسال الدفع بنجاح
class PaymentSubmitted extends PaymentsState {
  final PaymentModel payment;

  const PaymentSubmitted(this.payment);

  @override
  List<Object?> get props => [payment];
}

/// تم تحميل دفع محدد
class PaymentLoaded extends PaymentsState {
  final PaymentModel payment;

  const PaymentLoaded(this.payment);

  @override
  List<Object?> get props => [payment];
}

/// تم تحميل جميع المدفوعات
class PaymentsListLoaded extends PaymentsState {
  final List<PaymentModel> payments;

  const PaymentsListLoaded(this.payments);

  @override
  List<Object?> get props => [payments];
}

/// تم إعادة إرسال الدفع
class PaymentResubmitted extends PaymentsState {
  final PaymentModel payment;

  const PaymentResubmitted(this.payment);

  @override
  List<Object?> get props => [payment];
}

/// خطأ
class PaymentsError extends PaymentsState {
  final String message;

  const PaymentsError(this.message);

  @override
  List<Object?> get props => [message];
}
