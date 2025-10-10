import 'package:flutter/material.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';
import 'package:waslaacademy/src/user/models/notification.dart';
import 'package:waslaacademy/src/user/widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    // Mock notifications data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _notifications = [
          NotificationModel(
            id: '1',
            title: 'كورس جديد متاح',
            content: 'تم إضافة كورس "تطوير تطبيقات Flutter" الجديد',
            time: DateTime.now().subtract(const Duration(minutes: 30)),
            type: NotificationType.newCourse,
            isRead: false,
          ),
          NotificationModel(
            id: '2',
            title: 'محاضرة مباشرة قريباً',
            content: 'ستبدأ محاضرة "أساسيات البرمجة" خلال 15 دقيقة',
            time: DateTime.now().subtract(const Duration(hours: 1)),
            type: NotificationType.liveLecture,
            isRead: false,
          ),
          NotificationModel(
            id: '3',
            title: 'تحديث الكورس',
            content: 'تم إضافة دروس جديدة لكورس "تصميم المواقع"',
            time: DateTime.now().subtract(const Duration(hours: 3)),
            type: NotificationType.courseUpdate,
            isRead: true,
          ),
          NotificationModel(
            id: '4',
            title: 'شهادة جديدة',
            content: 'تهانينا! حصلت على شهادة إتمام كورس "JavaScript"',
            time: DateTime.now().subtract(const Duration(days: 1)),
            type: NotificationType.certificate,
            isRead: true,
          ),
          NotificationModel(
            id: '5',
            title: 'واجب جديد',
            content: 'تم إضافة واجب جديد في كورس "قواعد البيانات"',
            time: DateTime.now().subtract(const Duration(days: 2)),
            type: NotificationType.assignment,
            isRead: true,
          ),
        ];
        _isLoading = false;
      });
    });
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications =
          _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notificationId);
    });
  }

  void _onNotificationTap(NotificationModel notification) {
    if (!notification.isRead) {
      _markAsRead(notification.id);
    }

    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.newCourse:
      case NotificationType.courseUpdate:
        // Navigate to course details
        break;
      case NotificationType.liveLecture:
        // Navigate to live lecture
        break;
      case NotificationType.certificate:
        // Navigate to certificates screen
        break;
      case NotificationType.assignment:
        // Navigate to assignment
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: AppTextStyles.headline2(context),
        ),
        backgroundColor: Colors.white,
        elevation: AppSizes.elevationLow,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'قراءة الكل',
                style: AppTextStyles.link(context),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? EmptyState.noNotifications(
                  onRefresh: _loadNotifications,
                )
              : Column(
                  children: [
                    // Unread count header
                    if (unreadCount > 0)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSizes.spaceMedium),
                        color: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          'لديك $unreadCount إشعار غير مقروء',
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Notifications List
                    Expanded(
                      child: ListView.builder(
                        padding: screenPadding,
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return _buildNotificationItem(notification);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Card(
        elevation: notification.isRead
            ? AppSizes.elevationLow
            : AppSizes.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: InkWell(
          onTap: () => _onNotificationTap(notification),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spaceLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              color: notification.isRead
                  ? Colors.white
                  : AppColors.primary.withOpacity(0.05),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  padding: const EdgeInsets.all(AppSizes.spaceSmall),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    size: AppSizes.iconMedium,
                    color: _getNotificationColor(notification.type),
                  ),
                ),

                const SizedBox(width: AppSizes.spaceMedium),

                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Time
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: AppTextStyles.labelLarge(context).copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            notification.getFormattedTime(),
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.spaceXSmall),

                      // Content
                      Text(
                        notification.content,
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: notification.isRead
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: AppSizes.spaceSmall),

                      // Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceSmall,
                          vertical: AppSizes.spaceXSmall / 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getNotificationColor(notification.type)
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusXSmall),
                        ),
                        child: Text(
                          notification.getTypeDisplayName(),
                          style: AppTextStyles.caption(context).copyWith(
                            color: _getNotificationColor(notification.type),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Unread Indicator
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),

                // More Options
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'mark_read':
                        _markAsRead(notification.id);
                        break;
                      case 'delete':
                        _deleteNotification(notification.id);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (!notification.isRead)
                      const PopupMenuItem(
                        value: 'mark_read',
                        child: Row(
                          children: [
                            Icon(Icons.mark_email_read,
                                size: AppSizes.iconSmall),
                            SizedBox(width: AppSizes.spaceSmall),
                            Text('تحديد كمقروء'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete,
                              size: AppSizes.iconSmall,
                              color: AppColors.danger),
                          SizedBox(width: AppSizes.spaceSmall),
                          Text('حذف',
                              style: TextStyle(color: AppColors.danger)),
                        ],
                      ),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(AppSizes.spaceXSmall),
                    child: Icon(
                      Icons.more_vert,
                      size: AppSizes.iconSmall,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.courseUpdate:
        return Icons.update;
      case NotificationType.newCourse:
        return Icons.new_releases;
      case NotificationType.assignment:
        return Icons.assignment;
      case NotificationType.certificate:
        return Icons.workspace_premium;
      case NotificationType.liveLecture:
        return Icons.live_tv;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.promotion:
        return Icons.local_offer;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.courseUpdate:
        return AppColors.primary;
      case NotificationType.newCourse:
        return AppColors.success;
      case NotificationType.assignment:
        return AppColors.warning;
      case NotificationType.certificate:
        return AppColors.secondary;
      case NotificationType.liveLecture:
        return AppColors.danger;
      case NotificationType.system:
        return AppColors.textSecondary;
      case NotificationType.promotion:
        return AppColors.warning;
    }
  }
}
