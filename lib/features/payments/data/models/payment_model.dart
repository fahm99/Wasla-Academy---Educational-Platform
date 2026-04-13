/// نموذج الدفع
class PaymentModel {
  final String id;
  final String studentId;
  final String courseId;
  final String providerId;
  final double amount;
  final String currency;
  final String paymentMethod;
  final String? transactionId;
  final String status;
  final DateTime? paymentDate;
  final String receiptImageUrl;
  final String transactionReference;
  final String? studentName;
  final String? courseName;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final String? rejectionReason;
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.providerId,
    required this.amount,
    this.currency = 'SAR',
    required this.paymentMethod,
    this.transactionId,
    required this.status,
    this.paymentDate,
    required this.receiptImageUrl,
    required this.transactionReference,
    this.studentName,
    this.courseName,
    this.verifiedBy,
    this.verifiedAt,
    this.rejectionReason,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      courseId: json['course_id'] as String,
      providerId: json['provider_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      paymentMethod: json['payment_method'] as String,
      transactionId: json['transaction_id'] as String?,
      status: json['status'] as String,
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'] as String)
          : null,
      receiptImageUrl: json['receipt_image_url'] as String,
      transactionReference: json['transaction_reference'] as String,
      studentName: json['student_name'] as String?,
      courseName: json['course_name'] as String?,
      verifiedBy: json['verified_by'] as String?,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'course_id': courseId,
      'provider_id': providerId,
      'amount': amount,
      'currency': currency,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
      'status': status,
      'payment_date': paymentDate?.toIso8601String(),
      'receipt_image_url': receiptImageUrl,
      'transaction_reference': transactionReference,
      'student_name': studentName,
      'course_name': courseName,
      'verified_by': verifiedBy,
      'verified_at': verifiedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PaymentModel copyWith({
    String? id,
    String? studentId,
    String? courseId,
    String? providerId,
    double? amount,
    String? currency,
    String? paymentMethod,
    String? transactionId,
    String? status,
    DateTime? paymentDate,
    String? receiptImageUrl,
    String? transactionReference,
    String? studentName,
    String? courseName,
    String? verifiedBy,
    DateTime? verifiedAt,
    String? rejectionReason,
    DateTime? createdAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      providerId: providerId ?? this.providerId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      transactionReference: transactionReference ?? this.transactionReference,
      studentName: studentName ?? this.studentName,
      courseName: courseName ?? this.courseName,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
