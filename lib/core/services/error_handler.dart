import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// مستوى الخطأ
enum ErrorLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// نموذج الخطأ
class ErrorLog {
  final String id;
  final DateTime timestamp;
  final ErrorLevel level;
  final String message;
  final String? error;
  final String? stackTrace;
  final String? context;
  final Map<String, dynamic>? extra;
  final String? userId;

  ErrorLog({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    this.context,
    this.extra,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'level': level.name,
        'message': message,
        'error': error,
        'stackTrace': stackTrace,
        'context': context,
        'extra': extra,
        'userId': userId,
      };

  String toLogString() {
    final buffer = StringBuffer();
    buffer.writeln(
        '[$level] ${DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp)}');
    buffer.writeln('Message: $message');
    if (context != null) buffer.writeln('Context: $context');
    if (error != null) buffer.writeln('Error: $error');
    if (stackTrace != null) buffer.writeln('Stack Trace:\n$stackTrace');
    if (extra != null) buffer.writeln('Extra: $extra');
    if (userId != null) buffer.writeln('User ID: $userId');
    buffer.writeln('${'=' * 80}');
    return buffer.toString();
  }
}

/// خدمة معالجة الأخطاء المركزية (بدون حزم خارجية)
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  final List<ErrorLog> _errorLogs = [];
  String? _currentUserId;
  File? _logFile;
  bool _isInitialized = false;

  static const int _maxLogsInMemory = 100;
  static const int _maxLogFileSize = 5 * 1024 * 1024; // 5 MB

  /// تهيئة Error Handler
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // إنشاء ملف الـ logs
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _logFile = File('${logsDir.path}/app_log_$dateStr.txt');

      // تنظيف الملفات القديمة (أكثر من 7 أيام)
      await _cleanOldLogs(logsDir);

      _isInitialized = true;

      await logInfo('Error Handler initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Error Handler: $e');
    }
  }

  /// تنظيف ملفات الـ logs القديمة
  Future<void> _cleanOldLogs(Directory logsDir) async {
    try {
      final files = await logsDir.list().toList();
      final now = DateTime.now();

      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          final age = now.difference(stat.modified);

          if (age.inDays > 7) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to clean old logs: $e');
    }
  }

  /// تعيين معلومات المستخدم
  void setUser(String? userId) {
    _currentUserId = userId;
  }

  /// مسح معلومات المستخدم
  void clearUser() {
    _currentUserId = null;
  }

  /// تسجيل خطأ
  Future<void> logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? extra,
  }) async {
    await _log(
      level: ErrorLevel.error,
      message: error.toString(),
      error: error.toString(),
      stackTrace: stackTrace?.toString(),
      context: context,
      extra: extra,
    );
  }

  /// تسجيل خطأ fatal
  Future<void> logFatal(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? extra,
  }) async {
    await _log(
      level: ErrorLevel.fatal,
      message: error.toString(),
      error: error.toString(),
      stackTrace: stackTrace?.toString(),
      context: context,
      extra: extra,
    );
  }

  /// تسجيل تحذير
  Future<void> logWarning(
    String message, {
    String? context,
    Map<String, dynamic>? extra,
  }) async {
    await _log(
      level: ErrorLevel.warning,
      message: message,
      context: context,
      extra: extra,
    );
  }

  /// تسجيل معلومة
  Future<void> logInfo(
    String message, {
    String? context,
    Map<String, dynamic>? extra,
  }) async {
    await _log(
      level: ErrorLevel.info,
      message: message,
      context: context,
      extra: extra,
    );
  }

  /// تسجيل debug
  Future<void> logDebug(
    String message, {
    String? context,
    Map<String, dynamic>? extra,
  }) async {
    if (kDebugMode) {
      await _log(
        level: ErrorLevel.debug,
        message: message,
        context: context,
        extra: extra,
      );
    }
  }

  /// التسجيل الداخلي
  Future<void> _log({
    required ErrorLevel level,
    required String message,
    String? error,
    String? stackTrace,
    String? context,
    Map<String, dynamic>? extra,
  }) async {
    final errorLog = ErrorLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      level: level,
      message: message,
      error: error,
      stackTrace: stackTrace,
      context: context,
      extra: extra,
      userId: _currentUserId,
    );

    // إضافة إلى الذاكرة
    _errorLogs.add(errorLog);
    if (_errorLogs.length > _maxLogsInMemory) {
      _errorLogs.removeAt(0);
    }

    // طباعة في Console
    _printToConsole(errorLog);

    // كتابة في الملف
    await _writeToFile(errorLog);
  }

  /// طباعة في Console
  void _printToConsole(ErrorLog log) {
    if (!kDebugMode) return;

    final icon = _getLogIcon(log.level);
    final color = _getLogColor(log.level);

    debugPrint('$icon [$color${log.level.name.toUpperCase()}] ${log.message}');
    if (log.context != null) debugPrint('   Context: ${log.context}');
    if (log.error != null) debugPrint('   Error: ${log.error}');
    if (log.stackTrace != null && log.level.index >= ErrorLevel.error.index) {
      debugPrint('   Stack Trace:\n${log.stackTrace}');
    }
  }

  String _getLogIcon(ErrorLevel level) {
    switch (level) {
      case ErrorLevel.debug:
        return '🔍';
      case ErrorLevel.info:
        return 'ℹ️';
      case ErrorLevel.warning:
        return '⚠️';
      case ErrorLevel.error:
        return '❌';
      case ErrorLevel.fatal:
        return '💀';
    }
  }

  String _getLogColor(ErrorLevel level) {
    switch (level) {
      case ErrorLevel.debug:
        return '\x1B[36m'; // Cyan
      case ErrorLevel.info:
        return '\x1B[32m'; // Green
      case ErrorLevel.warning:
        return '\x1B[33m'; // Yellow
      case ErrorLevel.error:
        return '\x1B[31m'; // Red
      case ErrorLevel.fatal:
        return '\x1B[35m'; // Magenta
    }
  }

  /// كتابة في الملف
  Future<void> _writeToFile(ErrorLog log) async {
    if (_logFile == null || !_isInitialized) return;

    try {
      // التحقق من حجم الملف
      if (await _logFile!.exists()) {
        final fileSize = await _logFile!.length();
        if (fileSize > _maxLogFileSize) {
          // إنشاء ملف جديد
          final timestamp =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
          final directory = _logFile!.parent;
          _logFile = File('${directory.path}/app_log_$timestamp.txt');
        }
      }

      // كتابة الـ log
      await _logFile!.writeAsString(
        log.toLogString(),
        mode: FileMode.append,
      );
    } catch (e) {
      debugPrint('Failed to write log to file: $e');
    }
  }

  /// الحصول على جميع الـ logs
  List<ErrorLog> getLogs({ErrorLevel? level}) {
    if (level == null) return List.from(_errorLogs);
    return _errorLogs.where((log) => log.level == level).toList();
  }

  /// مسح جميع الـ logs من الذاكرة
  void clearLogs() {
    _errorLogs.clear();
  }

  /// الحصول على ملف الـ log الحالي
  File? getLogFile() => _logFile;

  /// معالجة أخطاء Flutter Framework
  static void handleFlutterError(FlutterErrorDetails details) {
    FlutterError.presentError(details);

    ErrorHandler().logError(
      details.exception,
      details.stack,
      context: details.library ?? 'Flutter Framework',
      extra: {
        'context': details.context?.toString(),
        'informationCollector': details.informationCollector?.toString(),
      },
    );
  }

  /// معالجة أخطاء Zone
  static void handleZoneError(Object error, StackTrace stackTrace) {
    ErrorHandler().logError(
      error,
      stackTrace,
      context: 'Async Zone',
    );
  }

  /// تصدير الـ logs كـ String
  Future<String> exportLogs() async {
    final buffer = StringBuffer();
    buffer.writeln('Wasla Academy - Error Logs Export');
    buffer.writeln(
        'Generated: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}');
    buffer.writeln('${'=' * 80}\n');

    for (final log in _errorLogs) {
      buffer.write(log.toLogString());
    }

    return buffer.toString();
  }

  /// حفظ الـ logs في ملف
  Future<File?> saveLogsToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp =
          DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final file = File('${directory.path}/logs/export_$timestamp.txt');

      final content = await exportLogs();
      await file.writeAsString(content);

      return file;
    } catch (e) {
      debugPrint('Failed to save logs to file: $e');
      return null;
    }
  }
}

/// Extension لتسهيل استخدام Error Handler
extension ErrorHandlerExtension on Future {
  /// تتبع Future مع معالجة الأخطاء
  Future<T> trackError<T>(String context) async {
    try {
      return await this as T;
    } catch (e, stackTrace) {
      await ErrorHandler().logError(e, stackTrace, context: context);
      rethrow;
    }
  }
}
