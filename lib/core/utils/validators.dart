/// أدوات التحقق من الصحة
class Validators {
  /// التحقق من البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }

    return null;
  }

  /// التحقق من كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    return null;
  }

  /// التحقق من تطابق كلمة المرور
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }

    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }

    return null;
  }

  /// التحقق من الاسم
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }

    if (value.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }

    return null;
  }

  /// التحقق من رقم الهاتف
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // اختياري
    }

    final phoneRegex = RegExp(r'^[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'رقم الهاتف غير صحيح';
    }

    return null;
  }

  /// التحقق من حقل مطلوب
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }

    return null;
  }

  /// التحقق من الحد الأدنى للطول
  static String? validateMinLength(
      String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }

    if (value.length < minLength) {
      return '$fieldName يجب أن يكون $minLength أحرف على الأقل';
    }

    return null;
  }

  /// التحقق من الحد الأقصى للطول
  static String? validateMaxLength(
      String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName يجب أن لا يتجاوز $maxLength حرف';
    }

    return null;
  }

  /// التحقق من رقم
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }

    if (double.tryParse(value) == null) {
      return '$fieldName يجب أن يكون رقماً';
    }

    return null;
  }

  /// التحقق من رقم موجب
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numberError = validateNumber(value, fieldName);
    if (numberError != null) return numberError;

    if (double.parse(value!) <= 0) {
      return '$fieldName يجب أن يكون أكبر من صفر';
    }

    return null;
  }

  /// التحقق من URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // اختياري
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'الرابط غير صحيح';
    }

    return null;
  }
}
