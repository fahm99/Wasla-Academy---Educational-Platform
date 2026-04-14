import 'dart:io';

/// خدمة التحقق من صحة بيانات الدفع
class PaymentValidator {
  /// التحقق من صحة رقم المعاملة
  static String? validateTransactionReference(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم المعاملة مطلوب';
    }

    final trimmed = value.trim();

    if (trimmed.length < 4) {
      return 'رقم المعاملة قصير جداً (الحد الأدنى 4 أحرف)';
    }

    if (trimmed.length > 50) {
      return 'رقم المعاملة طويل جداً (الحد الأقصى 50 حرف)';
    }

    // التحقق من أن الرقم يحتوي على أحرف وأرقام فقط
    final validPattern = RegExp(r'^[a-zA-Z0-9\-_]+$');
    if (!validPattern.hasMatch(trimmed)) {
      return 'رقم المعاملة يجب أن يحتوي على أحرف وأرقام فقط';
    }

    return null;
  }

  /// التحقق من صحة المبلغ
  static String? validateAmount(double? amount) {
    if (amount == null || amount <= 0) {
      return 'المبلغ غير صحيح';
    }

    if (amount < 10) {
      return 'الحد الأدنى للمبلغ هو 10 ريال';
    }

    if (amount > 100000) {
      return 'الحد الأقصى للمبلغ هو 100,000 ريال';
    }

    return null;
  }

  /// التحقق من صحة صورة الإيصال
  static Future<String?> validateReceiptImage(File? image) async {
    if (image == null) {
      return 'صورة الإيصال مطلوبة';
    }

    // التحقق من وجود الملف
    if (!await image.exists()) {
      return 'الملف غير موجود';
    }

    // التحقق من حجم الملف (الحد الأقصى 5 ميجا)
    final fileSize = await image.length();
    const maxSize = 5 * 1024 * 1024; // 5 MB

    if (fileSize > maxSize) {
      return 'حجم الصورة كبير جداً (الحد الأقصى 5 ميجا)';
    }

    if (fileSize < 1024) {
      return 'حجم الصورة صغير جداً';
    }

    // التحقق من نوع الملف
    final extension = image.path.split('.').last.toLowerCase();
    final validExtensions = ['jpg', 'jpeg', 'png', 'webp'];

    if (!validExtensions.contains(extension)) {
      return 'نوع الملف غير مدعوم. استخدم: ${validExtensions.join(", ")}';
    }

    return null;
  }

  /// التحقق من صحة طريقة الدفع
  static String? validatePaymentMethod(String? method) {
    if (method == null || method.trim().isEmpty) {
      return 'طريقة الدفع مطلوبة';
    }

    final validMethods = ['bank_transfer', 'local_transfer'];
    if (!validMethods.contains(method)) {
      return 'طريقة الدفع غير صحيحة';
    }

    return null;
  }

  /// التحقق الشامل من بيانات الدفع
  static Future<Map<String, String>> validatePaymentData({
    required String? transactionReference,
    required double? amount,
    required File? receiptImage,
    required String? paymentMethod,
  }) async {
    final errors = <String, String>{};

    // التحقق من رقم المعاملة
    final transactionError = validateTransactionReference(transactionReference);
    if (transactionError != null) {
      errors['transactionReference'] = transactionError;
    }

    // التحقق من المبلغ
    final amountError = validateAmount(amount);
    if (amountError != null) {
      errors['amount'] = amountError;
    }

    // التحقق من صورة الإيصال
    final imageError = await validateReceiptImage(receiptImage);
    if (imageError != null) {
      errors['receiptImage'] = imageError;
    }

    // التحقق من طريقة الدفع
    final methodError = validatePaymentMethod(paymentMethod);
    if (methodError != null) {
      errors['paymentMethod'] = methodError;
    }

    return errors;
  }

  /// الحصول على رسالة خطأ واضحة للمستخدم
  static String getErrorMessage(Map<String, String> errors) {
    if (errors.isEmpty) return '';

    if (errors.length == 1) {
      return errors.values.first;
    }

    return 'يرجى تصحيح الأخطاء التالية:\n${errors.values.join('\n')}';
  }

  /// التحقق من حالة الدفع
  static bool isPaymentPending(String status) {
    return status.toLowerCase() == 'pending';
  }

  static bool isPaymentApproved(String status) {
    return status.toLowerCase() == 'approved';
  }

  static bool isPaymentRejected(String status) {
    return status.toLowerCase() == 'rejected';
  }

  /// الحصول على لون حالة الدفع
  static String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'warning';
      case 'approved':
        return 'success';
      case 'rejected':
        return 'error';
      default:
        return 'info';
    }
  }

  /// الحصول على نص حالة الدفع بالعربية
  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد المراجعة';
      case 'approved':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }

  /// الحصول على أيقونة حالة الدفع
  static String getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'pending';
      case 'approved':
        return 'check_circle';
      case 'rejected':
        return 'cancel';
      default:
        return 'help';
    }
  }
}
