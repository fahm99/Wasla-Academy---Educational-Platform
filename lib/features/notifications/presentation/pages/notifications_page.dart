import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/notifications_bloc.dart';

/// صفحة الإشعارات
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Load notifications - will need user ID from auth
    // context.read<NotificationsBloc>().add(LoadNotificationsEvent(userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: AppTextStyles.headlineMedium(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // Mark all as read
              // context.read<NotificationsBloc>().add(MarkAllNotificationsAsReadEvent(userId));
              Helpers.showSuccessSnackbar(
                context,
                'تم تحديد جميع الإشعارات كمقروءة',
              );
            },
            tooltip: 'تحديد الكل كمقروء',
          ),
        ],
      ),
      body: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state is NotificationsError) {
            Helpers.showErrorSnackbar(context, state.message);
          } else if (state is NotificationMarkedAsRead) {
            // Reload notifications
            // context.read<NotificationsBloc>().add(LoadNotificationsEvent(userId));
          } else if (state is AllNotificationsMarkedAsRead) {
            // Reload notifications
            // context.read<NotificationsBloc>().add(LoadNotificationsEvent(userId));
          } else if (state is NotificationDeleted) {
            Helpers.showSuccessSnackbar(context, 'تم حذف الإشعار');
            // Reload notifications
            // context.read<NotificationsBloc>().add(LoadNotificationsEvent(userId));
          }
        },
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(notification);
              },
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_none,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'لا توجد إشعارات',
            style: AppTextStyles.headlineSmall(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'سيتم إشعارك بأي تحديثات جديدة',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(notification) {
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        context
            .read<NotificationsBloc>()
            .add(DeleteNotificationEvent(notification.id));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        elevation: isUnread ? 2 : 1,
        color: isUnread ? Colors.white : AppColors.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          side: isUnread
              ? BorderSide(color: AppColors.primary.withOpacity(0.3))
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: () {
            if (isUnread) {
              context
                  .read<NotificationsBloc>()
                  .add(MarkNotificationAsReadEvent(notification.id));
            }
            _handleNotificationTap(notification);
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 24,
                  ),
                ),

                const SizedBox(width: AppSizes.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        notification.message,
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        Helpers.formatTimeAgo(notification.createdAt),
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'course':
        return Icons.school;
      case 'exam':
        return Icons.quiz;
      case 'certificate':
        return Icons.workspace_premium;
      case 'payment':
        return Icons.payment;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'course':
        return AppColors.primary;
      case 'exam':
        return AppColors.warning;
      case 'certificate':
        return AppColors.success;
      case 'payment':
        return AppColors.secondary;
      case 'system':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  void _handleNotificationTap(notification) {
    // Navigate based on notification type and relatedId
    switch (notification.type) {
      case 'course':
        Helpers.showInfoSnackbar(context, 'سيتم فتح صفحة الكورس');
        break;
      case 'exam':
        Helpers.showInfoSnackbar(context, 'سيتم فتح صفحة الامتحان');
        break;
      case 'certificate':
        Helpers.showInfoSnackbar(context, 'سيتم فتح صفحة الشهادة');
        break;
      case 'payment':
        Helpers.showInfoSnackbar(context, 'سيتم فتح صفحة الدفع');
        break;
      default:
        break;
    }
  }
}
