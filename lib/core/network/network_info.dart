import 'package:flutter/foundation.dart' show kIsWeb;

/// معلومات الشبكة
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// تنفيذ معلومات الشبكة
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // على الويب، نفترض أن الاتصال متاح دائماً
    // لأن المتصفح نفسه يتطلب اتصال بالإنترنت
    if (kIsWeb) {
      return true;
    }
    
    // على المنصات الأخرى، يمكن استخدام connectivity_plus
    // لكن حالياً نفترض الاتصال متاح
    return true;
  }
}
