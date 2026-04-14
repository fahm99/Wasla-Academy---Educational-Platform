import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// معلومات الشبكة
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// تنفيذ معلومات الشبكة
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    // على الويب، نفترض أن الاتصال متاح دائماً
    if (kIsWeb) {
      return true;
    }

    try {
      final List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();

      // التحقق من وجود أي اتصال نشط
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    } catch (e) {
      // في حالة حدوث خطأ، نفترض عدم وجود اتصال
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    if (kIsWeb) {
      // على الويب، نرجع stream يبث true دائماً
      return Stream.value(true);
    }

    return _connectivity.onConnectivityChanged.map((results) {
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    }).handleError((error) {
      // في حالة حدوث خطأ، نرجع false
      return false;
    });
  }
}
