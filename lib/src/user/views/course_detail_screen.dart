import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waslaacademy/src/user/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/user/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';
import 'package:waslaacademy/src/user/models/course.dart';
import 'package:waslaacademy/src/user/views/course_content_screen.dart';
import 'package:waslaacademy/src/user/views/course_player_screen.dart';
import 'package:waslaacademy/src/user/views/payment_screen.dart';
import 'package:waslaacademy/src/user/widgets/lesson_item.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  Course? _course;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCourse();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadCourse() {
    final courseState = context.read<CourseBloc>().state;
    if (courseState is CourseLoaded) {
      final course =
          courseState.courses.where((c) => c.id == widget.courseId).firstOrNull;
      setState(() {
        _course = course;
      });
    }
  }

  /// Checks if the current user is enrolled in this course
  bool _isUserEnrolled() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess && _course != null) {
      return authState.user.enrolledCourses.contains(_course!.id);
    }
    return false;
  }

  bool _isCourseCompleted() {
    // Mock implementation - would check actual completion status
    return false;
  }

  double _calculateProgress() {
    // Mock implementation - would calculate actual progress
    return 0.3;
  }

  void _enrollInCourse() {
    if (_course!.free) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: AppSizes.spaceLarge),
              Text(
                'جاري التسجيل في الكورس...',
                style: AppTextStyles.bodyLarge(context),
              ),
            ],
          ),
        ),
      );

      // Enroll user in course
      context.read<CourseBloc>().add(EnrollCourse(courseId: _course!.id));

      // Show success message after a short delay to allow enrollment to process
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close loading dialog

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: AppSizes.spaceSmall),
                Expanded(
                  child: Text('تم التسجيل في كورس "${_course!.title}" بنجاح!'),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
          ),
        );

        // Refresh the UI to show enrolled state
        setState(() {});

        // Navigate directly to course content screen
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CourseContentScreen(
                courseId: _course!.id,
              ),
            ),
          );
        });
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(course: _course!),
        ),
      ).then((_) {
        // Refresh course data after returning from payment
        _loadCourse();
        setState(() {});
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    if (_course == null) {
      return Scaffold(
        backgroundColor: AppColors.light,
        appBar: AppBar(
          title: Text(
            'تفاصيل الكورس',
            style: AppTextStyles.headline2(context),
          ),
          backgroundColor: Colors.white,
          elevation: AppSizes.elevationLow,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isEnrolled = _isUserEnrolled();
    final isCompleted = _isCourseCompleted();
    final progress = _calculateProgress();
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // App Bar
            SliverAppBar(
              expandedHeight:
                  ResponsiveHelper.getCourseImageHeight(context) + 100,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: AppSizes.elevationLow,
              title: Text(
                'تفاصيل الكورس',
                style: AppTextStyles.headline2(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Course Image/Video Preview
                    Image.network(
                      _course!.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.light,
                          child: const Icon(
                            Icons.image,
                            size: AppSizes.iconXXXLarge,
                            color: AppColors.textLight,
                          ),
                        );
                      },
                    ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),

                    // Play Button (if video preview available)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.spaceLarge),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: AppSizes.iconXXXLarge,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
                      const SizedBox(width: AppSizes.spaceMedium),
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
                          style: AppTextStyles.labelMedium(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spaceMedium),

                  // Short Description
                  Text(
                    _course!.description.length > 100
                        ? '${_course!.description.substring(0, 100)}...'
                        : _course!.description,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Instructor Info
            Container(
              color: Colors.white,
              padding: screenPadding,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppSizes.avatarLarge / 2,
                    backgroundImage: NetworkImage(_course!.instructorImage),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: _course!.instructorImage.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: AppSizes.iconLarge,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: AppSizes.spaceMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _course!.instructor,
                          style: AppTextStyles.labelLarge(context),
                        ),
                        const SizedBox(height: AppSizes.spaceXSmall),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: AppSizes.iconSmall,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: AppSizes.spaceXSmall),
                            Text(
                              _course!.rating.toString(),
                              style: AppTextStyles.bodyMedium(context),
                            ),
                            const SizedBox(width: AppSizes.spaceMedium),
                            const Icon(
                              Icons.people,
                              size: AppSizes.iconSmall,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSizes.spaceXSmall),
                            Text(
                              '${_course!.students} طالب',
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

            const SizedBox(height: AppSizes.spaceSmall),

            // Progress Bar (if enrolled)
            if (isEnrolled) ...{
              Container(
                color: Colors.white,
                padding: screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تقدمك في الكورس',
                          style: AppTextStyles.labelLarge(context),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: AppTextStyles.labelLarge(context).copyWith(
                            color: isCompleted
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusXSmall),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.light,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? AppColors.success : AppColors.primary,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceSmall),
            },

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
                  // Content Tab
                  _buildContentTab(),

                  // Description Tab
                  _buildDescriptionTab(),

                  // Reviews Tab
                  _buildReviewsTab(),
                ],
              ),
            ),
          ],
        ),
      ),

      // Fixed Bottom Button
      bottomNavigationBar: Container(
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
              onPressed: isEnrolled ? _goToCourse : _enrollInCourse,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                elevation: AppSizes.elevationLow,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceLarge,
                ),
              ),
              child: Text(
                isEnrolled
                    ? 'الوصول إلى المحتوى'
                    : _course!.free
                        ? 'اشترك الآن'
                        : 'اشترك الآن - ${_course!.price} ر.س',
                style: AppTextStyles.buttonLarge(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _goToCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseContentScreen(
          courseId: _course!.id,
        ),
      ),
    );
  }

  Widget _buildContentTab() {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return SingleChildScrollView(
      padding: screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.spaceLarge),

          // Course Stats
          Row(
            children: [
              _buildStatItem(
                icon: Icons.access_time,
                label: 'المدة',
                value: _course!.duration,
              ),
              const SizedBox(width: AppSizes.spaceXLarge),
              _buildStatItem(
                icon: Icons.play_circle_outline,
                label: 'الدروس',
                value: '${_course!.lessons.length}',
              ),
              const SizedBox(width: AppSizes.spaceXLarge),
              _buildStatItem(
                icon: Icons.quiz,
                label: 'الاختبارات',
                value: '${_course!.exams.length}',
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceXXLarge),

          // Lessons List
          Text(
            'قائمة الدروس',
            style: AppTextStyles.headline3(context),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Convert course lessons to LessonItem widgets
          ...List.generate(_course!.lessons.length, (index) {
            final lesson = _course!.lessons[index];
            return LessonItem(
              title: lesson.title,
              duration: lesson.duration,
              type: lesson.type == 'video'
                  ? LessonType.video
                  : LessonType.article,
              isCompleted: lesson.completed,
              isLocked:
                  !_isUserEnrolled() && index > 0, // First lesson is preview
              order: index + 1,
              onTap: () {
                if (_isUserEnrolled() || index == 0) {
                  _goToCourse();
                }
              },
            );
          }),

          const SizedBox(height: AppSizes.spaceXLarge),

          // Exams Section
          if (_course!.exams.isNotEmpty) ...{
            Text(
              'الاختبارات',
              style: AppTextStyles.headline3(context),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            ...List.generate(_course!.exams.length, (index) {
              final exam = _course!.exams[index];
              return LessonItem(
                title: exam.title,
                duration: '${exam.questions} أسئلة • ${exam.duration}',
                type: LessonType.quiz,
                isCompleted: false, // Would need to track exam completion
                isLocked: exam.locked || !_isUserEnrolled(),
                order: index + 1,
                onTap: () {
                  if (!exam.locked && _isUserEnrolled()) {
                    // Navigate to exam
                  }
                },
              );
            }),
          },

          const SizedBox(height: AppSizes.spaceXXLarge),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return SingleChildScrollView(
      padding: screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.spaceLarge),

          // Full Description
          Text(
            'وصف الكورس',
            style: AppTextStyles.headline3(context),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          Text(
            _course!.description,
            style: AppTextStyles.bodyLarge(context).copyWith(
              height: 1.6,
            ),
          ),

          const SizedBox(height: AppSizes.spaceXXLarge),

          // What You'll Learn
          Text(
            'ماذا ستتعلم؟',
            style: AppTextStyles.headline3(context),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Mock learning outcomes
          ...{
            'فهم المفاهيم الأساسية للموضوع',
            'تطبيق المهارات العملية',
            'حل المشاكل الشائعة',
            'بناء مشاريع حقيقية',
          }.map((outcome) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: AppSizes.iconMedium,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: AppSizes.spaceMedium),
                    Expanded(
                      child: Text(
                        outcome,
                        style: AppTextStyles.bodyLarge(context),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: AppSizes.spaceXXLarge),

          // Requirements
          Text(
            'المتطلبات',
            style: AppTextStyles.headline3(context),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          Text(
            'لا توجد متطلبات مسبقة لهذا الكورس. مناسب للمبتدئين.',
            style: AppTextStyles.bodyLarge(context),
          ),

          const SizedBox(height: AppSizes.spaceXXLarge),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return SingleChildScrollView(
      padding: screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.spaceLarge),

          // Rating Summary
          Row(
            children: [
              Column(
                children: [
                  Text(
                    _course!.rating.toString(),
                    style: AppTextStyles.headline1(context).copyWith(
                      fontSize: 48,
                      color: AppColors.warning,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < _course!.rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.warning,
                        size: AppSizes.iconMedium,
                      );
                    }),
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Text(
                    '${_course!.students} تقييم',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                ],
              ),

              const SizedBox(width: AppSizes.spaceXXLarge),

              // Rating Breakdown (Mock)
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar('5 نجوم', 0.7),
                    _buildRatingBar('4 نجوم', 0.2),
                    _buildRatingBar('3 نجوم', 0.1),
                    _buildRatingBar('2 نجوم', 0.0),
                    _buildRatingBar('1 نجمة', 0.0),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceXXLarge),

          // Reviews List (Mock)
          Text(
            'التقييمات',
            style: AppTextStyles.headline3(context),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Mock reviews
          ...List.generate(
              3,
              (index) => _buildReviewItem(
                    name: 'طالب ${index + 1}',
                    rating: 5 - index,
                    comment:
                        'كورس ممتاز ومفيد جداً. أنصح به بشدة لكل من يريد تعلم هذا الموضوع.',
                    date: '${index + 1} يوم مضى',
                  )),

          const SizedBox(height: AppSizes.spaceXXLarge),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: AppSizes.iconLarge,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        Text(
          value,
          style: AppTextStyles.labelLarge(context),
        ),
        const SizedBox(height: AppSizes.spaceXSmall),
        Text(
          label,
          style: AppTextStyles.caption(context),
        ),
      ],
    );
  }

  Widget _buildRatingBar(String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTextStyles.bodySmall(context),
            ),
          ),
          const SizedBox(width: AppSizes.spaceSmall),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.light,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required int rating,
    required String comment,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceLarge),
      padding: const EdgeInsets.all(AppSizes.spaceLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.light),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppSizes.avatarSmall / 2,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  name[0],
                  style: AppTextStyles.labelMedium(context).copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spaceMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.labelLarge(context),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: AppColors.warning,
                            size: AppSizes.iconSmall,
                          );
                        }),
                        const SizedBox(width: AppSizes.spaceSmall),
                        Text(
                          date,
                          style: AppTextStyles.caption(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMedium),
          Text(
            comment,
            style: AppTextStyles.bodyLarge(context),
          ),
        ],
      ),
    );
  }
}
