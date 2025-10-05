import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';

class LiveLectureCard extends StatefulWidget {
  final String title;
  final String instructorName;
  final String? instructorImage;
  final String? thumbnailUrl;
  final int viewerCount;
  final DateTime? startTime;
  final bool isLive;
  final VoidCallback? onJoin;
  final VoidCallback? onReminder;

  const LiveLectureCard({
    super.key,
    required this.title,
    required this.instructorName,
    this.instructorImage,
    this.thumbnailUrl,
    required this.viewerCount,
    this.startTime,
    required this.isLive,
    this.onJoin,
    this.onReminder,
  });

  @override
  State<LiveLectureCard> createState() => _LiveLectureCardState();
}

class _LiveLectureCardState extends State<LiveLectureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isLive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getTimeUntilStart() {
    if (widget.startTime == null) return '';

    final now = DateTime.now();
    final difference = widget.startTime!.difference(now);

    if (difference.isNegative) return '';

    if (difference.inDays > 0) {
      return 'خلال ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'خلال ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'خلال ${difference.inMinutes} دقيقة';
    } else {
      return 'يبدأ الآن';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardPadding = AppSizes.getCardPadding(context);
    final imageHeight = ResponsiveHelper.getCourseImageHeight(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceLarge),
      child: Card(
        elevation: AppSizes.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: InkWell(
          onTap: widget.isLive ? widget.onJoin : widget.onReminder,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail with Live Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSizes.radiusLarge),
                    ),
                    child: SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: widget.thumbnailUrl != null
                          ? CachedNetworkImage(
                              imageUrl: widget.thumbnailUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.live_tv,
                                  size: AppSizes.iconXXLarge,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.live_tv,
                                size: AppSizes.iconXXLarge,
                                color: Colors.grey[600],
                              ),
                            ),
                    ),
                  ),

                  // Live Badge with Animation
                  if (widget.isLive)
                    Positioned(
                      top: AppSizes.spaceMedium,
                      right: AppSizes.spaceMedium,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spaceSmall,
                                vertical: AppSizes.spaceXSmall,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.danger,
                                borderRadius: BorderRadius.circular(
                                    AppSizes.radiusXSmall),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.danger.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.spaceXSmall),
                                  Text(
                                    'مباشر',
                                    style: AppTextStyles.badge(context),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Viewer Count (for live lectures)
                  if (widget.isLive)
                    Positioned(
                      bottom: AppSizes.spaceMedium,
                      right: AppSizes.spaceMedium,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceSmall,
                          vertical: AppSizes.spaceXSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusXSmall),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.visibility,
                              size: AppSizes.iconXSmall,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppSizes.spaceXSmall),
                            Text(
                              '${widget.viewerCount}',
                              style: AppTextStyles.caption(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title,
                      style: AppTextStyles.headline3(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppSizes.spaceSmall),

                    // Instructor Info
                    Row(
                      children: [
                        // Instructor Avatar
                        Container(
                          width: AppSizes.avatarSmall,
                          height: AppSizes.avatarSmall,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                          child: widget.instructorImage != null &&
                                  widget.instructorImage!.isNotEmpty
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: widget.instructorImage!,
                                    fit: BoxFit.cover,
                                    width: AppSizes.avatarSmall,
                                    height: AppSizes.avatarSmall,
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.person,
                                      size: AppSizes.iconSmall,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: AppSizes.iconSmall,
                                  color: AppColors.primary,
                                ),
                        ),

                        const SizedBox(width: AppSizes.spaceSmall),

                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.instructorName,
                                style: AppTextStyles.labelMedium(context),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!widget.isLive &&
                                  widget.startTime != null) ...[
                                const SizedBox(
                                    height: AppSizes.spaceXSmall / 2),
                                Text(
                                  _getTimeUntilStart(),
                                  style:
                                      AppTextStyles.caption(context).copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.spaceMedium),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: ResponsiveHelper.getButtonHeight(context),
                      child: ElevatedButton.icon(
                        onPressed:
                            widget.isLive ? widget.onJoin : widget.onReminder,
                        icon: Icon(
                          widget.isLive
                              ? Icons.play_arrow
                              : Icons.notifications,
                          size: AppSizes.iconMedium,
                          color: Colors.white,
                        ),
                        label: Text(
                          widget.isLive ? 'انضم الآن' : 'تذكيري',
                          style: AppTextStyles.buttonLarge(context),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isLive
                              ? AppColors.danger
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMedium),
                          ),
                          elevation: AppSizes.elevationLow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// قائمة المحاضرات المباشرة
class LiveLecturesList extends StatelessWidget {
  final List<LiveLectureCard> lectures;
  final bool showEmptyState;
  final String? emptyStateTitle;
  final String? emptyStateSubtitle;
  final VoidCallback? onRefresh;

  const LiveLecturesList({
    super.key,
    required this.lectures,
    this.showEmptyState = true,
    this.emptyStateTitle,
    this.emptyStateSubtitle,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (lectures.isEmpty && showEmptyState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceXXLarge),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.live_tv_outlined,
                size: AppSizes.iconXXXLarge,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXLarge),
            Text(
              emptyStateTitle ?? 'لا توجد محاضرات مباشرة',
              style: AppTextStyles.headline2(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            Text(
              emptyStateSubtitle ?? 'لا توجد محاضرات مباشرة في الوقت الحالي',
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: AppSizes.spaceXXLarge),
              ElevatedButton(
                onPressed: onRefresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceXXLarge,
                    vertical: AppSizes.spaceMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                child: Text(
                  'تحديث',
                  style: AppTextStyles.buttonLarge(context),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.screenPaddingMobile),
      itemCount: lectures.length,
      itemBuilder: (context, index) => lectures[index],
    );
  }
}
