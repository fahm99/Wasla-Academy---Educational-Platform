import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_constants.dart';
import '../../features/auth/data/models/user_model.dart';

/// خدمة التخزين المحلي
class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService._(this._prefs);

  static LocalStorageService? _instance;

  /// الحصول على instance من الخدمة
  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = LocalStorageService._(prefs);
    }
    return _instance!;
  }

  // ==================== User ====================

  /// حفظ المستخدم
  Future<bool> saveUser(UserModel user) async {
    try {
      await _prefs.setString(StorageConstants.keyUserId, user.id);
      await _prefs.setString(StorageConstants.keyUserEmail, user.email);
      await _prefs.setString(StorageConstants.keyUserName, user.name);
      await _prefs.setString(StorageConstants.keyUserType, user.userType);

      if (user.displayAvatar != null) {
        await _prefs.setString(
            StorageConstants.keyUserAvatar, user.displayAvatar!);
      }

      await _prefs.setBool(StorageConstants.keyIsLoggedIn, true);

      // حفظ كائن المستخدم الكامل
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString('user_data', userJson);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// جلب المستخدم
  Future<UserModel?> getUser() async {
    try {
      final userJson = _prefs.getString('user_data');
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// حذف بيانات المستخدم
  Future<bool> clearUser() async {
    try {
      await _prefs.remove(StorageConstants.keyUserId);
      await _prefs.remove(StorageConstants.keyUserEmail);
      await _prefs.remove(StorageConstants.keyUserName);
      await _prefs.remove(StorageConstants.keyUserType);
      await _prefs.remove(StorageConstants.keyUserAvatar);
      await _prefs.remove(StorageConstants.keyIsLoggedIn);
      await _prefs.remove('user_data');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// التحقق من تسجيل الدخول
  bool get isLoggedIn =>
      _prefs.getBool(StorageConstants.keyIsLoggedIn) ?? false;

  /// الحصول على معرف المستخدم
  String? get userId => _prefs.getString(StorageConstants.keyUserId);

  // ==================== Settings ====================

  /// حفظ وضع الثيم
  Future<bool> saveThemeMode(String mode) async {
    return await _prefs.setString(StorageConstants.keyThemeMode, mode);
  }

  /// جلب وضع الثيم
  String get themeMode =>
      _prefs.getString(StorageConstants.keyThemeMode) ?? 'light';

  /// حفظ اللغة
  Future<bool> saveLanguage(String language) async {
    return await _prefs.setString(StorageConstants.keyLanguage, language);
  }

  /// جلب اللغة
  String get language => _prefs.getString(StorageConstants.keyLanguage) ?? 'ar';

  /// حفظ إعدادات الإشعارات
  Future<bool> saveNotificationsEnabled(bool enabled) async {
    return await _prefs.setBool(
        StorageConstants.keyNotificationsEnabled, enabled);
  }

  /// جلب إعدادات الإشعارات
  bool get notificationsEnabled =>
      _prefs.getBool(StorageConstants.keyNotificationsEnabled) ?? true;

  // ==================== Cache ====================

  /// حفظ بيانات مؤقتة
  Future<bool> saveCache(String key, String data) async {
    try {
      await _prefs.setString(key, data);
      await _prefs.setInt(
        '${key}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// جلب بيانات مؤقتة
  String? getCache(String key, {Duration? maxAge}) {
    try {
      final data = _prefs.getString(key);
      if (data == null) return null;

      if (maxAge != null) {
        final timestamp = _prefs.getInt('${key}_timestamp');
        if (timestamp != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final age = DateTime.now().difference(cacheTime);

          if (age > maxAge) {
            // انتهت صلاحية الكاش
            _prefs.remove(key);
            _prefs.remove('${key}_timestamp');
            return null;
          }
        }
      }

      return data;
    } catch (e) {
      return null;
    }
  }

  /// حذف كاش معين
  Future<bool> removeCache(String key) async {
    try {
      await _prefs.remove(key);
      await _prefs.remove('${key}_timestamp');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// حذف جميع البيانات المؤقتة
  Future<bool> clearAllCache() async {
    try {
      final keys = _prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith('cache_') || key.endsWith('_timestamp')) {
          await _prefs.remove(key);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== General ====================

  /// حذف جميع البيانات
  Future<bool> clearAll() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      return false;
    }
  }

  /// حفظ قيمة String
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// جلب قيمة String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// حفظ قيمة bool
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// جلب قيمة bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// حفظ قيمة int
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// جلب قيمة int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }
}
