import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:waslaacademy/core/constants/app_colors.dart';
import 'package:waslaacademy/core/constants/app_sizes.dart';
import 'package:waslaacademy/core/constants/app_text_styles.dart';
import 'package:waslaacademy/core/utils/responsive_helper.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_event.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_state.dart';
import '../../../../core/utils/helpers.dart';

import '../../data/models/course_model.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CourseModel? _course;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Always reload data when returning to this page
    context.read<CoursesBloc>().add(LoadCourseDetailsEvent(widget.courseId));
    context.read<CoursesBloc>().add(LoadCourseModulesEvent(widget.courseId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _enrollInCourse() {
    if (_course == null) return;

    if (_course!.isFree) {
      // Show loading
      Helpers.showLoadingDialog(context, 'جاري التسجيل...');

      context.read<CoursesBloc>().add(EnrollInCourseEvent(_course!.id));
    } else {
      // Navigate to payment info page
      Navigator.pushNamed(
        context,
        '/payment-info',
        arguments: {
          'courseId': _course!.id,
          'courseName': _course!.title,
          'amount': _course!.price,
          'currency': _course!.currency,
          'providerId': _course!.providerId,
        },
      );
    }
  }

  String _getLevelText(String? level) {
    switch (level) {
      case 'beginner':
        return 'مبتدئ';
      case 'intermediate':
        return 'متوسط';
      case 'advanced':
        return 'متقدم';
      default:
        return 'مبتدئ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding =
        EdgeInsets.all(ResponsiveHelper.getScreenPadding(context));

    return Scaffold(
      backgroundColor: AppColors.light,
      body: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state is CourseDetailsLoaded) {
            setState(() {
              _course = state.course;
            });
          } else if (state is EnrollmentSuccess) {
            Navigator.pop(context); // Close loading
            Helpers.showSuccessSnackbar(
              context,
              'تم التسجيل في الكورس بنجاح!',
            );
            // Reload course details
            context
                .read<CoursesBloc>()
                .add(LoadCourseDetailsEvent(widget.courseId));
          } else if (state is CoursesError) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Close loading if open
            }
            Helpers.showErrorSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CoursesLoading && _course == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_course == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: AppSizes.iconXXXLarge,
                    color: AppColors.danger,
                  ),
                  SizedBox(height: AppSizes.spaceLarge.h),
                  Text(
                    'لم يتم العثور على الكورس',
                    style: AppTextStyles.headline2(context),
                  ),
                  SizedBox(height: AppSizes.spaceXLarge.h),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('العودة'),
                  ),
                ],
              ),
            );
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight:
                      ResponsiveHelper.getCourseImageHeight(context),
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: AppSizes.elevationLow,
                  title: Text(
                    'تفاصيل الكورس',
                    style: AppTextStyles.headline2(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _course!.displayImage != null
                        ? CachedNetworkImage(
                            imageUrl: _course!.displayImage!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.light,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.light,
                              child: const Icon(
                                Icons.image,
                                size: AppSizes.iconXXXLarge,
                                color: AppColors.textLight,
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.light,
                            child: const Icon(
                              Icons.school,
                              size: AppSizes.iconXXXLarge,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                // Course Info Header
                Container(
                  color: Colors.white,
                  padding: screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Level
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _course!.title,
                              style: AppTextStyles.headline1(context),
                            ),
                          ),
                          SizedBox(width: AppSizes.spaceMedium.w),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spaceMedium,
                              vertical: AppSizes.spaceSmall,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusXXLarge),
                            ),
                            child: Text(
                              _getLevelText(_course!.level),
                              style:
                                  AppTextStyles.labelMedium(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.spaceMedium.h),

                      // Description
                      Text(
                        _course!.description,
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Provider Info
                if (_course!.providerName != null)
                  Container(
                    color: Colors.white,
                    padding: screenPadding,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: AppSizes.avatarLarge / 2,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: _course!.providerAvatar != null
                              ? CachedNetworkImage(
                                  imageUrl: _course!.providerAvatar!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.person),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: AppSizes.iconLarge,
                                  color: AppColors.primary,
                                ),
                        ),
                        SizedBox(width: AppSizes.spaceMedium.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _course!.providerName!,
                                style: AppTextStyles.labelLarge(context),
                              ),
                              SizedBox(height: AppSizes.spaceXSmall.h),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: AppSizes.iconSmall,
                                    color: AppColors.warning,
                                  ),
                                  SizedBox(width: AppSizes.spaceXSmall.w),
                                  Text(
                                    _course!.rating.toString(),
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                  SizedBox(width: AppSizes.spaceMedium.w),
                                  const Icon(
                                    Icons.people,
                                    size: AppSizes.iconSmall,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(width: AppSizes.spaceXSmall.w),
                                  Text(
                                    '${_course!.studentsCount} طالب',
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: AppSizes.spaceSmall.h),

                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelStyle: AppTextStyles.labelLarge(context),
                    unselectedLabelStyle: AppTextStyles.labelMedium(context),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'المحتوى'),
                      Tab(text: 'الوصف'),
                      Tab(text: 'التقييمات'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildContentTab(),
                      _buildDescriptionTab(),
                      _buildReviewsTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // Bottom Button
      bottomNavigationBar: _course != null
          ? Container(
              padding: screenPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: AppSizes.elevationMedium,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: ResponsiveHelper.getButtonHeight(context),
                  child: ElevatedButton(
                    onPressed: _enrollInCourse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      elevation: AppSizes.elevationLow,
                    ),
                    child: Text(
                      _course!.isFree
                          ? 'اشترك الآن'
                          : 'اشترك الآن - ${_course!.price} ${_course!.currency}',
                      style: AppTextStyles.buttonLarge(context),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildContentTab() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CourseModulesLoaded) {
          final modules = state.modules;

          if (modules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open_rounded,
                    size: 80,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا يوجد محتوى متاح حالياً',
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(ResponsiveHelper.getScreenPadding(context)),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      module.title,
                      style: AppTextStyles.labelLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: module.description != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              module.description!,
                              style: AppTextStyles.bodySmall(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : null,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.light.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.play_circle_outline_rounded,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'سيتم عرض الدروس هنا',
                                  style: AppTextStyles.bodyMedium(context)
                                      .copyWith(
                                    color: AppColors.textSecondary,
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
              );
            },
          );
        }

        if (state is CoursesInitial || state is CoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.textLight,
              ),
              const SizedBox(height: 16),
              Text(
                'لا يوجد محتوى متاح',
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.getScreenPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // What you'll learn section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ماذا ستتعلم',
                      style: AppTextStyles.headline3(context).copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _course!.description,
                  style: AppTextStyles.bodyLarge(context).copyWith(
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Course details
          Text(
            'تفاصيل الكورس',
            style: AppTextStyles.headline3(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _buildDetailItem(
            Icons.signal_cellular_alt_rounded,
            'المستوى',
            _getLevelText(_course!.level),
          ),
          _buildDetailItem(
            Icons.language_rounded,
            'اللغة',
            'العربية',
          ),
          _buildDetailItem(
            Icons.update_rounded,
            'آخر تحديث',
            'منذ أسبوع',
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.getScreenPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Rating Overview
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.warning.withOpacity(0.1),
                  AppColors.secondary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.warning.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      _course!.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < _course!.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: AppColors.warning,
                          size: 24,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_course!.reviewsCount} تقييم',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.7),
                      _buildRatingBar(4, 0.2),
                      _buildRatingBar(3, 0.05),
                      _buildRatingBar(2, 0.03),
                      _buildRatingBar(1, 0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Coming soon message
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.rate_review_outlined,
                    size: 48,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'سيتم إضافة التقييمات قريباً',
                  style: AppTextStyles.bodyLarge(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.star_rounded,
            size: 14,
            color: AppColors.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
