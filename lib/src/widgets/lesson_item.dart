import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';

enum LessonType {
  video,
  article,
  quiz,
  assignment,
  live,
}

class LessonItem extends StatelessWidget {
  final String title;
  final String duration;
  final LessonType type;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;
  final int? order;
  final String? description;

  const LessonItem({
    super.key,
    required this.title,
    required this.duration,
    required this.type,
    this.isCompleted = false,
    this.isLocked = false,
    this.onTap,
    this.order,
    this.description,
  });

  IconData _getTypeIcon() {
    switch (type) {
      case LessonType.video:
        return Icons.play_circle_outline;
      case LessonType.article:
        return Icons.article_outlined;
      case LessonType.quiz:
        return Icons.quiz_outlined;
      case LessonType.assignment:
        return Icons.assignment_outlined;
      case LessonType.live:
        return Icons.live_tv;
    }
  }

  Color _getTypeColor() {
    if (isLocked) return AppColors.textLight;
    if (isCompleted) return AppColors.success;

    switch (type) {
      case LessonType.video:
        return AppColors.primary;
      case LessonType.article:
        return AppColors.info;
      case LessonType.quiz:
        return AppColors.warning;
      case LessonType.assignment:
        return AppColors.secondary;
      case LessonType.live:
        return AppColors.danger;
    }
  }

  String _getTypeText() {
    switch (type) {
      case LessonType.video:
        return 'فيديو';
      case LessonType.article:
        return 'مقال';
      case LessonType.quiz:
        return 'اختبار';
      case LessonType.assignment:
        return 'واجب';
      case LessonType.live:
        return 'مباشر';
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spaceMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              border: Border.all(
                color: AppColors.light,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Lesson Icon
                Container(
                  width: AppSizes.avatarMedium,
                  height: AppSizes.avatarMedium,
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          _getTypeIcon(),
                          size: AppSizes.iconMedium,
                          color: typeColor,
                        ),
                      ),
                      if (isCompleted)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: AppSizes.iconSmall,
                            height: AppSizes.iconSmall,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: AppSizes.iconXSmall,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (isLocked)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: AppSizes.iconSmall,
                            height: AppSizes.iconSmall,
                            decoration: BoxDecoration(
                              color: AppColors.textLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.lock,
                              size: AppSizes.iconXSmall,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSizes.spaceMedium),

                // Lesson Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Order
                      Row(
                        children: [
                          if (order != null) ...[
                            Text(
                              '$order.',
                              style:
                                  AppTextStyles.labelMedium(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: AppSizes.spaceXSmall),
                          ],
                          Expanded(
                            child: Text(
                              title,
                              style: AppTextStyles.labelLarge(context).copyWith(
                                color: isLocked
                                    ? AppColors.textLight
                                    : AppColors.textPrimary,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Description (if provided)
                      if (description != null) ...[
                        const SizedBox(height: AppSizes.spaceXSmall),
                        Text(
                          description!,
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: isLocked
                                ? AppColors.textLight
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      const SizedBox(height: AppSizes.spaceXSmall),

                      // Type and Duration
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spaceSmall,
                              vertical: AppSizes.spaceXSmall / 2,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusXSmall),
                            ),
                            child: Text(
                              _getTypeText(),
                              style: AppTextStyles.caption(context).copyWith(
                                color: typeColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceSmall),
                          const Icon(
                            Icons.access_time,
                            size: AppSizes.iconXSmall,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: AppSizes.spaceXSmall),
                          Text(
                            duration,
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Icon
                if (!isLocked)
                  Icon(
                    isCompleted ? Icons.replay : Icons.play_arrow,
                    size: AppSizes.iconMedium,
                    color: typeColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// قائمة الدروس مع إمكانية التجميع حسب الفصول
class LessonsList extends StatelessWidget {
  final List<LessonItem> lessons;
  final String? sectionTitle;
  final bool showProgress;
  final double? progress;

  const LessonsList({
    super.key,
    required this.lessons,
    this.sectionTitle,
    this.showProgress = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingMobile,
              vertical: AppSizes.spaceSmall,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    sectionTitle!,
                    style: AppTextStyles.headline3(context),
                  ),
                ),
                if (showProgress && progress != null) ...[
                  Text(
                    '${(progress! * 100).round()}%',
                    style: AppTextStyles.labelMedium(context).copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceSmall),
                  SizedBox(
                    width: 40,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.light,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.success),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusXSmall),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceSmall),
        ],
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingMobile),
          child: Column(
            children: lessons,
          ),
        ),
      ],
    );
  }
}
