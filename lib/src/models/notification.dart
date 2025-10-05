import 'package:equatable/equatable.dart';

enum NotificationType {
  courseUpdate,
  newCourse,
  assignment,
  certificate,
  liveLecture,
  system,
  promotion,
}

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime time;
  final bool isRead;
  final NotificationType type;
  final String? relatedId; // ID of related course, lecture, etc.
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    this.isRead = false,
    required this.type,
    this.relatedId,
    this.imageUrl,
    this.metadata,
  });

  /// Create a copy with updated fields
  NotificationModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? time,
    bool? isRead,
    NotificationType? type,
    String? relatedId,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      time: DateTime.parse(json['time'] as String),
      isRead: json['isRead'] as bool? ?? false,
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.system,
      ),
      relatedId: json['relatedId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'time': time.toIso8601String(),
      'isRead': isRead,
      'type': type.toString().split('.').last,
      'relatedId': relatedId,
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }

  /// Get formatted time string
  String getFormattedTime() {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسبوع';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months شهر';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'منذ $years سنة';
    }
  }

  /// Get notification icon based on type
  String getTypeIcon() {
    switch (type) {
      case NotificationType.courseUpdate:
        return '📚';
      case NotificationType.newCourse:
        return '🆕';
      case NotificationType.assignment:
        return '📝';
      case NotificationType.certificate:
        return '🏆';
      case NotificationType.liveLecture:
        return '📺';
      case NotificationType.system:
        return '⚙️';
      case NotificationType.promotion:
        return '🎉';
    }
  }

  /// Get notification type display name
  String getTypeDisplayName() {
    switch (type) {
      case NotificationType.courseUpdate:
        return 'تحديث الكورس';
      case NotificationType.newCourse:
        return 'كورس جديد';
      case NotificationType.assignment:
        return 'واجب';
      case NotificationType.certificate:
        return 'شهادة';
      case NotificationType.liveLecture:
        return 'محاضرة مباشرة';
      case NotificationType.system:
        return 'النظام';
      case NotificationType.promotion:
        return 'عرض خاص';
    }
  }

  /// Check if notification is recent (within last 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(time);
    return difference.inHours < 24;
  }

  /// Check if notification is urgent (live lecture starting soon, assignment due, etc.)
  bool get isUrgent {
    switch (type) {
      case NotificationType.liveLecture:
        return isRecent;
      case NotificationType.assignment:
        return isRecent;
      default:
        return false;
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        time,
        isRead,
        type,
        relatedId,
        imageUrl,
        metadata,
      ];

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, isRead: $isRead, time: $time)';
  }
}

/// Extension for list of notifications
extension NotificationListExtension on List<NotificationModel> {
  /// Get unread notifications count
  int get unreadCount => where((notification) => !notification.isRead).length;

  /// Get recent notifications (within last 24 hours)
  List<NotificationModel> get recent =>
      where((notification) => notification.isRecent).toList();

  /// Get urgent notifications
  List<NotificationModel> get urgent =>
      where((notification) => notification.isUrgent).toList();

  /// Group notifications by date
  Map<String, List<NotificationModel>> groupByDate() {
    final Map<String, List<NotificationModel>> grouped = {};
    final now = DateTime.now();

    for (final notification in this) {
      final difference = now.difference(notification.time);
      String dateKey;

      if (difference.inDays == 0) {
        dateKey = 'اليوم';
      } else if (difference.inDays == 1) {
        dateKey = 'أمس';
      } else if (difference.inDays < 7) {
        dateKey = 'هذا الأسبوع';
      } else if (difference.inDays < 30) {
        dateKey = 'هذا الشهر';
      } else {
        dateKey = 'أقدم';
      }

      grouped[dateKey] = grouped[dateKey] ?? [];
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

  /// Mark all as read
  List<NotificationModel> markAllAsRead() {
    return map((notification) => notification.copyWith(isRead: true)).toList();
  }

  /// Filter by type
  List<NotificationModel> filterByType(NotificationType type) {
    return where((notification) => notification.type == type).toList();
  }

  /// Sort by time (newest first)
  List<NotificationModel> sortByTime() {
    final sorted = List<NotificationModel>.from(this);
    sorted.sort((a, b) => b.time.compareTo(a.time));
    return sorted;
  }
}
