/// نموذج إعدادات الدفع للمقدم
class ProviderPaymentSettingsModel {
  final String id;
  final String providerId;
  final bool acceptBankTransfer;
  final bool acceptLocalTransfer;
  final String? bankName;
  final String? accountNumber;
  final String? iban;
  final String? accountHolderName;
  final String? instructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProviderPaymentSettingsModel({
    required this.id,
    required this.providerId,
    required this.acceptBankTransfer,
    required this.acceptLocalTransfer,
    this.bankName,
    this.accountNumber,
    this.iban,
    this.accountHolderName,
    this.instructions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderPaymentSettingsModel.fromJson(Map<String, dynamic> json) {
    return ProviderPaymentSettingsModel(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      acceptBankTransfer: json['accept_bank_transfer'] as bool? ?? false,
      acceptLocalTransfer: json['accept_local_transfer'] as bool? ?? false,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      iban: json['iban'] as String?,
      accountHolderName: json['account_holder_name'] as String?,
      instructions: json['instructions'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'accept_bank_transfer': acceptBankTransfer,
      'accept_local_transfer': acceptLocalTransfer,
      'bank_name': bankName,
      'account_number': accountNumber,
      'iban': iban,
      'account_holder_name': accountHolderName,
      'instructions': instructions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
