// ملف بيانات المستخدمين التجريبيين
class TestUsers {
  // بيانات المستخدم التجريبي
  static const Map<String, dynamic> testUser = {
    'id': 1,
    'name': 'أحمد محمد السعيد',
    'email': 'test@waslaacademy.com',
    'phone': '+966501234567',
    'password': '123456',
    'verificationCode': '123456',
    'avatar': '',
    'isVerified': true,
    'enrolledCourses': <int>[],
    'completedCourses': <int>[],
    'certificates': <int>[],
    'createdAt': '2025-01-01T00:00:00Z',
  };

  // بيانات إضافية للاختبار
  static const List<Map<String, dynamic>> additionalTestUsers = [
    {
      'id': 2,
      'name': 'فاطمة أحمد علي',
      'email': 'fatima@waslaacademy.com',
      'phone': '+966507654321',
      'password': '123456',
      'verificationCode': '654321',
      'avatar': '',
      'isVerified': true,
      'enrolledCourses': [1, 2],
      'completedCourses': [1],
      'certificates': [1],
      'createdAt': '2025-01-02T00:00:00Z',
    },
    {
      'id': 3,
      'name': 'محمد عبدالله الأحمد',
      'email': 'mohammed@waslaacademy.com',
      'phone': '+966509876543',
      'password': '123456',
      'verificationCode': '789012',
      'avatar': '',
      'isVerified': true,
      'enrolledCourses': [2, 3, 4],
      'completedCourses': [2, 3],
      'certificates': [2, 3],
      'createdAt': '2025-01-03T00:00:00Z',
    },
  ];

  // دالة للحصول على المستخدم بالبريد الإلكتروني
  static Map<String, dynamic>? getUserByEmail(String email) {
    if (testUser['email'] == email) {
      return Map<String, dynamic>.from(testUser);
    }

    for (var user in additionalTestUsers) {
      if (user['email'] == email) {
        return Map<String, dynamic>.from(user);
      }
    }

    return null;
  }

  // دالة للتحقق من كلمة المرور
  static bool verifyPassword(String email, String password) {
    final user = getUserByEmail(email);
    return user != null && user['password'] == password;
  }

  // دالة للتحقق من رمز التأكيد
  static bool verifyCode(String email, String code) {
    final user = getUserByEmail(email);
    return user != null && user['verificationCode'] == code;
  }

  // دالة لإنشاء مستخدم جديد (محاكاة)
  static Map<String, dynamic> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    return {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'verificationCode': '123456', // رمز ثابت للاختبار
      'avatar': '',
      'isVerified': true, // يصبح محقق بعد التحقق من الرمز
      'enrolledCourses': <int>[],
      'completedCourses': <int>[],
      'certificates': <int>[],
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // معلومات تسجيل الدخول السريع للاختبار
  static const Map<String, String> quickLoginCredentials = {
    'email': 'test@waslaacademy.com',
    'password': '123456',
  };

  // رموز التحقق للاختبار
  static const Map<String, String> verificationCodes = {
    'test@waslaacademy.com': '123456',
    'fatima@waslaacademy.com': '654321',
    'mohammed@waslaacademy.com': '789012',
  };
}
