import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:waslaacademy/src/user/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';
import 'package:waslaacademy/src/user/models/course.dart';
import 'package:waslaacademy/src/user/views/course_detail_screen.dart';
import 'package:waslaacademy/src/user/views/payment_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  String _getLevelText(String level) {
    switch (level) {
      case 'beginner':
        return 'مبتدئ';
      case 'intermediate':
        return 'متوسط';
      case 'advanced':
        return 'متقدم';
      default:
        return level;
    }
  }

  String _getTypeText(String type) {
    switch (type) {
      case 'university':
        return 'جامعة';
      case 'institute':
        return 'معهد';
      case 'personal':
        return 'مدرب فردي';
      default:
        return type;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'university':
        return Icons.account_balance;
      case 'institute':
        return Icons.business;
      case 'personal':
        return Icons.person;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final cardPadding = AppSizes.getCardPadding(context);
    final imageHeight = ResponsiveHelper.getCourseImageHeight(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSizes.spaceLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        elevation: AppSizes.elevationMedium,
        child: InkWell(
          onTap: onTap ??
              () {
                if (course.free) {
                  context
                      .read<CourseBloc>()
                      .add(EnrollCourse(courseId: course.id));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseDetailScreen(courseId: course.id),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(course: course),
                    ),
                  );
                }
              },
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Course Image with fixed height
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusMedium),
                ),
                child: SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: course.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.error,
                        size: AppSizes.iconLarge,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              // Course Content
              Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Course title and level
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            course.title,
                            style: AppTextStyles.headline3(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceSmall,
                            vertical: AppSizes.spaceXSmall,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.light,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusXXLarge),
                          ),
                          child: Text(
                            _getLevelText(course.level),
                            style: AppTextStyles.caption(context).copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    // Provider (university, institute, independent trainer)
                    Row(
                      children: [
                        Icon(
                          _getTypeIcon(course.type),
                          size: AppSizes.iconSmall,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.spaceXSmall),
                        Expanded(
                          child: Text(
                            course.provider,
                            style: AppTextStyles.bodyMedium(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceSmall),
                        const Icon(
                          Icons.star,
                          size: AppSizes.iconSmall,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: AppSizes.spaceXSmall),
                        Text(
                          course.providerRating.toString(),
                          style: AppTextStyles.rating(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    // Students count and duration
                    Row(
                      children: [
                        const Icon(
                          Icons.people,
                          size: AppSizes.iconSmall,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.spaceXSmall),
                        Text(
                          '${course.students} طالب',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                        const SizedBox(width: AppSizes.spaceSmall),
                        const Icon(
                          Icons.access_time,
                          size: AppSizes.iconSmall,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: AppSizes.spaceXSmall),
                        Text(
                          course.duration,
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    // Price and enroll button
                    Row(
                      children: [
                        Text(
                          course.free ? 'مجاني' : '${course.price} ر.ي',
                          style: AppTextStyles.price(context,
                              isFree: course.free),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: ResponsiveHelper.getButtonHeight(context),
                          child: ElevatedButton(
                            onPressed: () {
                              if (course.free) {
                                context
                                    .read<CourseBloc>()
                                    .add(EnrollCourse(courseId: course.id));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CourseDetailScreen(
                                            courseId: course.id),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentScreen(course: course),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spaceMedium,
                                vertical: AppSizes.spaceSmall,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusSmall),
                              ),
                              elevation: AppSizes.elevationLow,
                            ),
                            child: Text(
                              'عرض',
                              style: AppTextStyles.buttonMedium(context),
                            ),
                          ),
                        ),
                      ],
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
