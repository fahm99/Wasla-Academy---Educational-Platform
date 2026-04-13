import 'package:equatable/equatable.dart';

/// نموذج إعدادات التطبيق
class AppSettingsModel extends Equatable {
  final String id;
  final String userId;
  final String theme; // 'light', 'dark'
  final String language; // 'ar', 'en'
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool notifyNewStudents;
  final bool notifyNewReviews;
  final bool notifyNewPayments;
  final bool autoSave;
  final Map<String, dynamic>? settingsData;
  final DateTime updatedAt;

  const AppSettingsModel({
    required this.id,
    required this.userId,
    this.theme = 'light',
    this.language = 'ar',
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.notifyNewStudents = true,
    this.notifyNewReviews = true,
    this.notifyNewPayments = true,
    this.autoSave = true,
    this.settingsData,
    required this.updatedAt,
  });

  /// إنشاء من JSON
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      theme: json['theme'] as String? ?? 'light',
      language: json['language'] as String? ?? 'ar',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      notifyNewStudents: json['notify_new_students'] as bool? ?? true,
      notifyNewReviews: json['notify_new_reviews'] as bool? ?? true,
      notifyNewPayments: json['notify_new_payments'] as bool? ?? true,
      autoSave: json['auto_save'] as bool? ?? true,
      settingsData: json['settings_data'] as Map<String, dynamic>?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'theme': theme,
      'language': language,
      'notifications_enabled': notificationsEnabled,
      'email_notifications': emailNotifications,
      'push_notifications': pushNotifications,
      'notify_new_students': notifyNewStudents,
      'notify_new_reviews': notifyNewReviews,
      'notify_new_payments': notifyNewPayments,
      'auto_save': autoSave,
      'settings_data': settingsData,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// نسخ مع تعديل
  AppSettingsModel copyWith({
    String? id,
    String? userId,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? notifyNewStudents,
    bool? notifyNewReviews,
    bool? notifyNewPayments,
    bool? autoSave,
    Map<String, dynamic>? settingsData,
    DateTime? updatedAt,
  }) {
    return AppSettingsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      notifyNewStudents: notifyNewStudents ?? this.notifyNewStudents,
      notifyNewReviews: notifyNewReviews ?? this.notifyNewReviews,
      notifyNewPayments: notifyNewPayments ?? this.notifyNewPayments,
      autoSave: autoSave ?? this.autoSave,
      settingsData: settingsData ?? this.settingsData,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// التحقق من الثيم
  bool get isDarkMode => theme == 'dark';
  bool get isLightMode => theme == 'light';

  /// التحقق من اللغة
  bool get isArabic => language == 'ar';
  bool get isEnglish => language == 'en';

  /// التحقق من الإشعارات
  bool get hasAnyNotificationsEnabled =>
      notificationsEnabled ||
      emailNotifications ||
      pushNotifications ||
      notifyNewStudents ||
      notifyNewReviews ||
      notifyNewPayments;

  @override
  List<Object?> get props => [
        id,
        userId,
        theme,
        language,
        notificationsEnabled,
        emailNotifications,
        pushNotifications,
        notifyNewStudents,
        notifyNewReviews,
        notifyNewPayments,
        autoSave,
        settingsData,
        updatedAt,
      ];

  @override
  String toString() {
    return 'AppSettingsModel(id: $id, userId: $userId, theme: $theme, language: $language)';
  }
}
