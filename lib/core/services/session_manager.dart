import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'local_storage_service.dart';

/// مدير الجلسات - يدير Token Refresh و Session Timeout
class SessionManager {
  final SupabaseClient _supabaseClient;
  final LocalStorageService _localStorage;

  Timer? _sessionCheckTimer;
  Timer? _tokenRefreshTimer;

  // Session timeout (30 دقيقة من عدم النشاط)
  static const Duration sessionTimeout = Duration(minutes: 30);

  // Token refresh قبل انتهاء الصلاحية بـ 5 دقائق
  static const Duration tokenRefreshBuffer = Duration(minutes: 5);

  DateTime? _lastActivityTime;
  bool _isSessionActive = false;

  // Callback لإشعار التطبيق بانتهاء الجلسة
  Function(String reason)? onForceLogout;

  SessionManager({
    required SupabaseClient supabaseClient,
    required LocalStorageService localStorage,
    this.onForceLogout,
  })  : _supabaseClient = supabaseClient,
        _localStorage = localStorage;

  /// بدء مراقبة الجلسة
  void startSessionMonitoring() {
    _isSessionActive = true;
    _lastActivityTime = DateTime.now();

    // مراقبة Session Timeout كل دقيقة
    _sessionCheckTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkSessionTimeout(),
    );

    // مراقبة Token Expiry
    _startTokenRefreshMonitoring();
  }

  /// إيقاف مراقبة الجلسة
  void stopSessionMonitoring() {
    _isSessionActive = false;
    _sessionCheckTimer?.cancel();
    _tokenRefreshTimer?.cancel();
    _sessionCheckTimer = null;
    _tokenRefreshTimer = null;
  }

  /// تحديث وقت آخر نشاط
  void updateActivity() {
    _lastActivityTime = DateTime.now();
  }

  /// التحقق من Session Timeout
  void _checkSessionTimeout() {
    if (!_isSessionActive || _lastActivityTime == null) return;

    final now = DateTime.now();
    final inactiveDuration = now.difference(_lastActivityTime!);

    if (inactiveDuration >= sessionTimeout) {
      // انتهت الجلسة بسبب عدم النشاط
      _handleSessionTimeout();
    }
  }

  /// معالجة انتهاء الجلسة
  Future<void> _handleSessionTimeout() async {
    stopSessionMonitoring();
    await forceLogout(reason: 'انتهت الجلسة بسبب عدم النشاط');
  }

  /// بدء مراقبة Token Refresh
  void _startTokenRefreshMonitoring() {
    _tokenRefreshTimer?.cancel();

    final session = _supabaseClient.auth.currentSession;
    if (session == null) return;

    // حساب متى يجب تحديث الـ Token
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return;

    final expiryTime = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    final refreshTime = expiryTime.subtract(tokenRefreshBuffer);
    final now = DateTime.now();

    if (refreshTime.isBefore(now)) {
      // يجب التحديث الآن
      _refreshToken();
    } else {
      // جدولة التحديث
      final delay = refreshTime.difference(now);
      _tokenRefreshTimer = Timer(delay, () => _refreshToken());
    }
  }

  /// تحديث الـ Token
  Future<void> _refreshToken() async {
    try {
      final response = await _supabaseClient.auth.refreshSession();

      if (response.session != null) {
        // نجح التحديث، جدول التحديث التالي
        _startTokenRefreshMonitoring();
      } else {
        // فشل التحديث
        await forceLogout(reason: 'فشل تحديث الجلسة');
      }
    } catch (e) {
      // خطأ في التحديث
      await forceLogout(reason: 'خطأ في تحديث الجلسة');
    }
  }

  /// فرض تسجيل الخروج
  Future<void> forceLogout({String? reason}) async {
    try {
      stopSessionMonitoring();

      // تسجيل الخروج من Supabase
      await _supabaseClient.auth.signOut();

      // حذف البيانات المحلية
      await _localStorage.clearUser();

      // إشعار التطبيق بانتهاء الجلسة
      if (onForceLogout != null) {
        onForceLogout!(reason ?? 'انتهت الجلسة');
      }
    } catch (e) {
      // حتى لو فشل، احذف البيانات المحلية
      await _localStorage.clearUser();

      // إشعار التطبيق بانتهاء الجلسة
      if (onForceLogout != null) {
        onForceLogout!(reason ?? 'انتهت الجلسة');
      }
    }
  }

  /// التحقق من صلاحية الجلسة
  Future<bool> isSessionValid() async {
    try {
      final session = _supabaseClient.auth.currentSession;

      if (session == null) return false;

      // التحقق من انتهاء الصلاحية
      final expiresAt = session.expiresAt;
      if (expiresAt == null) return false;

      final expiryTime = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
      final now = DateTime.now();

      return expiryTime.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  /// الحصول على الوقت المتبقي للجلسة
  Duration? getRemainingSessionTime() {
    final session = _supabaseClient.auth.currentSession;
    if (session == null) return null;

    final expiresAt = session.expiresAt;
    if (expiresAt == null) return null;

    final expiryTime = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    final now = DateTime.now();

    if (expiryTime.isBefore(now)) return Duration.zero;

    return expiryTime.difference(now);
  }

  /// التحقق من الجلسة عند بدء التطبيق
  Future<bool> validateSessionOnStartup() async {
    try {
      // محاولة الحصول على الجلسة الحالية
      final session = _supabaseClient.auth.currentSession;

      if (session == null) {
        await _localStorage.clearUser();
        return false;
      }

      // التحقق من صلاحية الجلسة
      if (!await isSessionValid()) {
        // محاولة التحديث
        try {
          final response = await _supabaseClient.auth.refreshSession();
          if (response.session != null) {
            startSessionMonitoring();
            return true;
          }
        } catch (e) {
          // فشل التحديث
        }

        await forceLogout(reason: 'انتهت صلاحية الجلسة');
        return false;
      }

      // الجلسة صالحة
      startSessionMonitoring();
      return true;
    } catch (e) {
      await _localStorage.clearUser();
      return false;
    }
  }

  /// الاستماع لتغييرات حالة المصادقة
  Stream<AuthState> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange;
  }

  /// معالجة تغييرات حالة المصادقة
  void handleAuthStateChange(AuthState authState) {
    switch (authState.event) {
      case AuthChangeEvent.signedIn:
        startSessionMonitoring();
        break;
      case AuthChangeEvent.signedOut:
        stopSessionMonitoring();
        break;
      case AuthChangeEvent.tokenRefreshed:
        _startTokenRefreshMonitoring();
        break;
      case AuthChangeEvent.userUpdated:
        updateActivity();
        break;
      default:
        break;
    }
  }

  /// تنظيف الموارد
  void dispose() {
    stopSessionMonitoring();
  }
}
