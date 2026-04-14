import 'dart:async';

/// بيانات محفوظة مع وقت انتهاء الصلاحية
class CachedData<T> {
  final T data;
  final DateTime fetchedAt;
  final Duration ttl;

  CachedData({
    required this.data,
    required this.ttl,
  }) : fetchedAt = DateTime.now();

  bool get isExpired => DateTime.now().difference(fetchedAt) > ttl;

  Duration get remainingTime {
    final elapsed = DateTime.now().difference(fetchedAt);
    final remaining = ttl - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

/// مدير الـ Cache المركزي
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final Map<String, CachedData> _cache = {};
  final Map<String, Timer> _expiryTimers = {};

  /// حفظ بيانات في الـ cache
  void put<T>(
    String key,
    T data, {
    Duration ttl = const Duration(minutes: 5),
  }) {
    // إلغاء Timer القديم إن وجد
    _expiryTimers[key]?.cancel();

    // حفظ البيانات
    _cache[key] = CachedData<T>(data: data, ttl: ttl);

    // إنشاء timer لحذف البيانات عند انتهاء الصلاحية
    _expiryTimers[key] = Timer(ttl, () {
      _cache.remove(key);
      _expiryTimers.remove(key);
    });
  }

  /// الحصول على بيانات من الـ cache
  T? get<T>(String key) {
    final cached = _cache[key];

    if (cached == null) return null;

    if (cached.isExpired) {
      remove(key);
      return null;
    }

    return cached.data as T?;
  }

  /// التحقق من وجود بيانات صالحة
  bool has(String key) {
    final cached = _cache[key];
    if (cached == null) return false;

    if (cached.isExpired) {
      remove(key);
      return false;
    }

    return true;
  }

  /// حذف بيانات من الـ cache
  void remove(String key) {
    _cache.remove(key);
    _expiryTimers[key]?.cancel();
    _expiryTimers.remove(key);
  }

  /// مسح جميع الـ cache
  void clear() {
    _cache.clear();
    for (final timer in _expiryTimers.values) {
      timer.cancel();
    }
    _expiryTimers.clear();
  }

  /// مسح الـ cache المنتهي فقط
  void clearExpired() {
    final expiredKeys = <String>[];

    _cache.forEach((key, cached) {
      if (cached.isExpired) {
        expiredKeys.add(key);
      }
    });

    for (final key in expiredKeys) {
      remove(key);
    }
  }

  /// الحصول على حجم الـ cache
  int get size => _cache.length;

  /// الحصول على جميع المفاتيح
  List<String> get keys => _cache.keys.toList();
}

/// Extension لتسهيل استخدام Cache
extension CacheManagerExtension on CacheManager {
  /// حفظ قائمة
  void putList<T>(String key, List<T> list, {Duration? ttl}) {
    put(key, list, ttl: ttl ?? const Duration(minutes: 5));
  }

  /// الحصول على قائمة
  List<T>? getList<T>(String key) {
    return get<List<T>>(key);
  }

  /// حفظ Map
  void putMap<K, V>(String key, Map<K, V> map, {Duration? ttl}) {
    put(key, map, ttl: ttl ?? const Duration(minutes: 5));
  }

  /// الحصول على Map
  Map<K, V>? getMap<K, V>(String key) {
    return get<Map<K, V>>(key);
  }
}
