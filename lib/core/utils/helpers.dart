import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// أدوات مساعدة عامة
class Helpers {
  /// تنسيق التاريخ
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format, 'ar').format(date);
  }

  /// تنسيق التاريخ والوقت
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm', 'ar').format(dateTime);
  }

  /// تنسيق التاريخ بالعربي
  static String formatDateArabic(DateTime date) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// تنسيق السعر
  static String formatPrice(double price, {String currency = 'ر.س'}) {
    final formatter = NumberFormat('#,##0.00', 'ar');
    return '${formatter.format(price)} $currency';
  }

  /// تنسيق الرقم
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'ar');
    return formatter.format(number);
  }

  /// تنسيق المدة (بالدقائق)
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes دقيقة';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '$hours ساعة';
    }

    return '$hours ساعة و $remainingMinutes دقيقة';
  }

  /// تنسيق حجم الملف
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes بايت';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} كيلوبايت';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} ميجابايت';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} جيجابايت';
    }
  }

  /// الحصول على الوقت النسبي (منذ)
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'منذ لحظات';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inDays < 30) {
      return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
    } else if (difference.inDays < 365) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
    } else {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    }
  }

  /// تنسيق الوقت النسبي (alias for getTimeAgo)
  static String formatTimeAgo(DateTime dateTime) {
    return getTimeAgo(dateTime);
  }

  /// عرض رسالة نجاح
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// عرض رسالة خطأ
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// عرض رسالة معلومات
  static void showInfoSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// عرض حوار تأكيد
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// عرض حوار تحميل
  static void showLoadingDialog(BuildContext context, String s,
      {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message ?? 'جاري التحميل...'),
            ],
          ),
        ),
      ),
    );
  }

  /// إخفاء حوار التحميل
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// الحصول على امتداد الملف
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  /// التحقق من نوع الملف
  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  static bool isVideoFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['mp4', 'webm', 'mov', 'avi'].contains(extension);
  }

  static bool isDocumentFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx']
        .contains(extension);
  }

  /// توليد UUID بسيط
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// تحويل النسبة المئوية إلى نص
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}%';
  }

  /// الحصول على لون حسب النسبة المئوية
  static Color getColorByPercentage(double percentage) {
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.blue;
    } else if (percentage >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
