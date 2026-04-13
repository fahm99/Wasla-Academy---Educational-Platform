import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart' as app_exceptions;
import '../models/user_model.dart';

/// مصدر البيانات البعيد للمصادقة
abstract class AuthRemoteDataSource {
  /// تسجيل حساب جديد
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  /// تسجيل الدخول
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  /// تسجيل الخروج
  Future<void> signOut();

  /// استعادة كلمة المرور
  Future<void> resetPassword({required String email});

  /// الحصول على المستخدم الحالي
  Future<UserModel?> getCurrentUser();

  /// تحديث بيانات المستخدم
  Future<UserModel> updateUser({
    String? name,
    String? phone,
    String? bio,
    String? avatarUrl,
  });

  /// التحقق من البريد الإلكتروني
  Future<void> verifyEmail(String token);

  /// إعادة إرسال رابط التحقق
  Future<void> resendVerificationEmail();
}

/// تنفيذ مصدر البيانات البعيد للمصادقة
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl({SupabaseClient? client})
      : client = client ?? ApiClient.instance;

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      // تسجيل المستخدم في Supabase Auth
      final authResponse = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          'user_type': ApiConstants.userTypeStudent, // افتراضياً طالب
        },
      );

      if (authResponse.user == null) {
        throw const app_exceptions.AuthException(
          message: 'فشل إنشاء الحساب',
        );
      }

      // الانتظار قليلاً للسماح للـ trigger بإنشاء السجل في جدول users
      await Future.delayed(const Duration(seconds: 2));

      // جلب بيانات المستخدم من جدول users
      final userResponse = await client
          .from(ApiConstants.usersTable)
          .select()
          .eq('id', authResponse.user!.id)
          .single();

      return UserModel.fromJson(userResponse);
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(
        message: _getAuthErrorMessage(e.message),
        code: e.statusCode,
      );
    } on PostgrestException catch (e) {
      throw app_exceptions.ServerException(
        message: e.message,
        statusCode: int.tryParse(e.code ?? ''),
      );
    } catch (e) {
      throw app_exceptions.UnexpectedException(
        message: 'حدث خطأ غير متوقع أثناء إنشاء الحساب: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // تسجيل الدخول في Supabase Auth
      final authResponse = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw const app_exceptions.AuthException(
          message: 'فشل تسجيل الدخول',
        );
      }

      // جلب بيانات المستخدم من جدول users
      final userResponse = await client
          .from(ApiConstants.usersTable)
          .select()
          .eq('id', authResponse.user!.id)
          .single();

      // تحديث آخر تسجيل دخول في الخلفية (بدون انتظار)
      client
          .from(ApiConstants.usersTable)
          .update({'last_login': DateTime.now().toIso8601String()})
          .eq('id', authResponse.user!.id)
          .then((_) => null)
          .catchError((e) {
            // تجاهل الأخطاء في تحديث last_login
            return null;
          });

      return UserModel.fromJson(userResponse);
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(
        message: _getAuthErrorMessage(e.message),
        code: e.statusCode,
      );
    } on PostgrestException catch (e) {
      throw app_exceptions.ServerException(
        message: e.message,
        statusCode: int.tryParse(e.code ?? ''),
      );
    } catch (e) {
      throw app_exceptions.UnexpectedException(
        message: 'حدث خطأ غير متوقع أثناء تسجيل الدخول',
        originalException: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(
        message: _getAuthErrorMessage(e.message),
        code: e.statusCode,
      );
    } catch (e) {
      throw app_exceptions.UnexpectedException(
        message: 'حدث خطأ غير متوقع أثناء تسجيل الخروج',
        originalException: e,
      );
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(
        message: _getAuthErrorMessage(e.message),
        code: e.statusCode,
      );
    } catch (e) {
      throw app_exceptions.UnexpectedException(
        message: 'حدث خطأ غير متوقع أثناء إعادة تعيين كلمة المرور',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final session = client.auth.currentSession;

      if (session == null) {
        return null;
      }

      // جلب بيانات المستخدم من جدول users
      final userResponse = await client
          .from(ApiConstants.usersTable)
          .select()
          .eq('id', session.user.id)
          .single();

      return UserModel.fromJson(userResponse);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // لا يوجد سجل
        return null;
      }
      throw app_exceptions.ServerException(
        message: e.message,
        statusCode: int.tryParse(e.code ?? ''),
      );
    } catch (e) {
      throw app_exceptions.UnexpectedException(
        message: 'حدث خطأ غير متوقع أثناء جلب بيانات المستخدم',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> updateUser({
    String? name,
    String? phone,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final userId = client.auth.currentUser?.id;

      if (userId == null) {
        throw const app_exceptions.AuthException(
          message: 'المستخدم غير مسجل الدخول',
        );
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await client
          .from(ApiConstants.usersTable)
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw app_exceptions.ServerException(
        message: e.message,
        statusCode: int.tryParse(e.code ?? ''),
      );
    } catch (e) {
      throw app_exceptions.UnexpectedException(
        message: 'حدث خطأ غير متوقع أثناء تحديث البيانات',
        originalException: e,
      );
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await client.auth.verifyOTP(
        type: OtpType.email,
        token: token,
      );
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(
        message: _getAuthErrorMessage(e.message),
        code: e.statusCode,
      );
    } catch (e) {
      throw app_exceptions.UnexpectedException(
        message: 'حدث خطأ غير متوقع أثناء التحقق من البريد الإلكتروني',
        originalException: e,
      );
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      final email = client.auth.currentUser?.email;

      if (email == null) {
        throw const app_exceptions.AuthException(
          message: 'المستخدم غير مسجل الدخول',
        );
      }

      await client.auth.resend(
        type: OtpType.email,
        email: email,
      );
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(
        message: _getAuthErrorMessage(e.message),
        code: e.statusCode,
      );
    } catch (e) {
      throw app_exceptions.UnexpectedException(
        message: 'حدث خطأ غير متوقع أثناء إعادة إرسال رابط التحقق',
        originalException: e,
      );
    }
  }

  /// الحصول على رسالة خطأ مترجمة
  String _getAuthErrorMessage(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    } else if (message.contains('Email not confirmed')) {
      return 'يرجى تأكيد بريدك الإلكتروني أولاً';
    } else if (message.contains('User already registered')) {
      return 'البريد الإلكتروني مسجل مسبقاً';
    } else if (message.contains('Password should be at least')) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    } else if (message.contains('Invalid email')) {
      return 'البريد الإلكتروني غير صحيح';
    } else if (message.contains('Network request failed')) {
      return 'فشل الاتصال بالخادم';
    }

    return message;
  }
}
