import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// خدمة مراقبة الاتصال بالإنترنت
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _isConnected = true;

  ConnectivityService() {
    _init();
  }

  void _init() {
    // التحقق من الحالة الأولية
    checkConnection();

    // الاستماع للتغييرات
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      _isConnected = false;
      _connectionStatusController.add(false);
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool hasConnection =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    if (_isConnected != hasConnection) {
      _isConnected = hasConnection;
      _connectionStatusController.add(hasConnection);
    }
  }

  bool get isConnected => _isConnected;

  void dispose() {
    _connectionStatusController.close();
  }
}
