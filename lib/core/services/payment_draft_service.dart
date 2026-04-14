import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'error_handler.dart';

/// نموذج لحفظ مسودة الدفع
class PaymentDraft {
  final File? receiptImage;
  final String? transactionReference;
  final String? paymentMethod;
  final DateTime savedAt;

  PaymentDraft({
    this.receiptImage,
    this.transactionReference,
    this.paymentMethod,
    required this.savedAt,
  });
}

/// خدمة حفظ واسترجاع مسودات الدفع
class PaymentDraftService {
  static final PaymentDraftService _instance = PaymentDraftService._internal();
  factory PaymentDraftService() => _instance;
  PaymentDraftService._internal();

  static const String _keyPrefix = 'payment_draft_';
  static const String _imagePathSuffix = '_image_path';
  static const String _transactionRefSuffix = '_transaction_ref';
  static const String _paymentMethodSuffix = '_payment_method';
  static const String _savedAtSuffix = '_saved_at';

  /// حفظ مسودة الدفع
  Future<bool> saveDraft({
    required String courseId,
    File? receiptImage,
    String? transactionReference,
    String? paymentMethod,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$courseId';

      // حفظ مسار الصورة
      if (receiptImage != null && await receiptImage.exists()) {
        await prefs.setString('$key$_imagePathSuffix', receiptImage.path);
      }

      // حفظ رقم المعاملة
      if (transactionReference != null && transactionReference.isNotEmpty) {
        await prefs.setString(
            '$key$_transactionRefSuffix', transactionReference);
      }

      // حفظ طريقة الدفع
      if (paymentMethod != null && paymentMethod.isNotEmpty) {
        await prefs.setString('$key$_paymentMethodSuffix', paymentMethod);
      }

      // حفظ وقت الحفظ
      await prefs.setString(
        '$key$_savedAtSuffix',
        DateTime.now().toIso8601String(),
      );

      await ErrorHandler().logInfo(
        'تم حفظ مسودة الدفع للكورس: $courseId',
        context: 'PaymentDraftService.saveDraft',
      );

      return true;
    } catch (e) {
      await ErrorHandler().logError(
        e,
        null,
        context: 'PaymentDraftService.saveDraft - فشل حفظ مسودة الدفع',
      );
      return false;
    }
  }

  /// استرجاع مسودة الدفع
  Future<PaymentDraft?> loadDraft(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$courseId';

      // التحقق من وجود مسودة
      final savedAtStr = prefs.getString('$key$_savedAtSuffix');
      if (savedAtStr == null) return null;

      final savedAt = DateTime.parse(savedAtStr);

      // التحقق من عمر المسودة (حذف إذا أكثر من 7 أيام)
      if (DateTime.now().difference(savedAt).inDays > 7) {
        await deleteDraft(courseId);
        return null;
      }

      // استرجاع مسار الصورة
      File? receiptImage;
      final imagePath = prefs.getString('$key$_imagePathSuffix');
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          receiptImage = file;
        }
      }

      // استرجاع رقم المعاملة
      final transactionRef = prefs.getString('$key$_transactionRefSuffix');

      // استرجاع طريقة الدفع
      final paymentMethod = prefs.getString('$key$_paymentMethodSuffix');

      await ErrorHandler().logInfo(
        'تم استرجاع مسودة الدفع للكورس: $courseId',
        context: 'PaymentDraftService.loadDraft',
      );

      return PaymentDraft(
        receiptImage: receiptImage,
        transactionReference: transactionRef,
        paymentMethod: paymentMethod,
        savedAt: savedAt,
      );
    } catch (e) {
      await ErrorHandler().logError(
        e,
        null,
        context: 'PaymentDraftService.loadDraft - فشل استرجاع مسودة الدفع',
      );
      return null;
    }
  }

  /// حذف مسودة الدفع
  Future<bool> deleteDraft(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$courseId';

      await prefs.remove('$key$_imagePathSuffix');
      await prefs.remove('$key$_transactionRefSuffix');
      await prefs.remove('$key$_paymentMethodSuffix');
      await prefs.remove('$key$_savedAtSuffix');

      await ErrorHandler().logInfo(
        'تم حذف مسودة الدفع للكورس: $courseId',
        context: 'PaymentDraftService.deleteDraft',
      );

      return true;
    } catch (e) {
      await ErrorHandler().logError(
        e,
        null,
        context: 'PaymentDraftService.deleteDraft - فشل حذف مسودة الدفع',
      );
      return false;
    }
  }

  /// التحقق من وجود مسودة
  Future<bool> hasDraft(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$courseId';
      return prefs.containsKey('$key$_savedAtSuffix');
    } catch (e) {
      return false;
    }
  }

  /// حذف جميع المسودات القديمة (أكثر من 7 أيام)
  Future<void> cleanupOldDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_keyPrefix) && key.endsWith(_savedAtSuffix)) {
          final savedAtStr = prefs.getString(key);
          if (savedAtStr != null) {
            final savedAt = DateTime.parse(savedAtStr);
            if (DateTime.now().difference(savedAt).inDays > 7) {
              // استخراج courseId من المفتاح
              final courseId = key
                  .replaceFirst(_keyPrefix, '')
                  .replaceFirst(_savedAtSuffix, '');
              await deleteDraft(courseId);
            }
          }
        }
      }

      await ErrorHandler().logInfo(
        'تم تنظيف المسودات القديمة',
        context: 'PaymentDraftService.cleanupOldDrafts',
      );
    } catch (e) {
      await ErrorHandler().logError(
        e,
        null,
        context:
            'PaymentDraftService.cleanupOldDrafts - فشل تنظيف المسودات القديمة',
      );
    }
  }
}
