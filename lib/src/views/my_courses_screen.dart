import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/views/course_player_screen.dart';
import 'package:waslaacademy/src/views/courses_screen.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';
import 'package:waslaacademy/src/widgets/empty_state.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Show welcome message if user just enrolled in a course
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForNewEnrollment();
    });
  }

  void _checkForNewEnrollment() {
    // Check if user was redirected here after enrollment
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['showWelcome'] == true) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.celebration, color: Colors.white),
                  SizedBox(width: AppSizes.spaceSmall),
                  Expanded(
                    child: Text('مرحباً بك في رحلة التعلم! ابدأ أول درس الآن'),
                  ),
                ],
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: const CustomAppBar(
        title: 'التعلم',
        showAuthIcons: true,
      ),
      body: Column(
        children: [
          // Tab Bar
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
                Tab(text: 'قيد التعلم'),
                Tab(text: 'مكتملة'),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthSuccess) {
                  return BlocBuilder<CourseBloc, CourseState>(
                    builder: (context, courseState) {
                      if (courseState is CourseLoaded) {
                        // Filter courses that the user is enrolled in
                        final enrolledCourses = courseState.courses
                            .where((course) => authState.user.enrolledCourses
                                .contains(course.id))
                            .toList();

                        // Separate ongoing and completed courses
                        final ongoingCourses = enrolledCourses
                            .where((course) => !_isCourseCompleted(course))
                            .toList();

                        final completedCourses = enrolledCourses
                            .where((course) => _isCourseCompleted(course))
                            .toList();

                        return TabBarView(
                          controller: _tabController,
                          children: [
                            // Ongoing Courses Tab
                            ongoingCourses.isEmpty
                                ? EmptyState.noCourses(
                                    onBrowsePressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CoursesScreen(),
                                        ),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    padding: screenPadding,
                                    itemCount: ongoingCourses.length,
                                    itemBuilder: (context, index) {
                                      final course = ongoingCourses[index];
                                      final progress = _calculateProgress(
                                          course, authState.user);
                                      return _buildCourseItem(course, progress);
                                    },
                                  ),

                            // Completed Courses Tab
                            completedCourses.isEmpty
                                ? const EmptyState(
                                    icon: Icons.workspace_premium,
                                    title: 'لا توجد كورسات مكتملة',
                                    subtitle:
                                        'أكمل الكورسات الحالية للحصول على شهادات',
                                    iconColor: AppColors.success,
                                  )
                                : ListView.builder(
                                    padding: screenPadding,
                                    itemCount: completedCourses.length,
                                    itemBuilder: (context, index) {
                                      final course = completedCourses[index];
                                      final progress = _calculateProgress(
                                          course, authState.user);
                                      return _buildCourseItem(course, progress);
                                    },
                                  ),
                          ],
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(Course course, double progress) {
    final isCompleted = _isCourseCompleted(course);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceLarge),
      child: Card(
        elevation: AppSizes.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoursePlayerScreen(
                  courseId: course.id,
                  initialLessonIndex: 0,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Image
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                      child: SizedBox(
                        width: ResponsiveHelper.isTablet(context) ? 100 : 80,
                        height: ResponsiveHelper.isTablet(context) ? 100 : 80,
                        child: Image.network(
                          course.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.light,
                              child: const Icon(
                                Icons.image,
                                size: AppSizes.iconLarge,
                                color: AppColors.textLight,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSizes.spaceMedium),

                    // Course Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            course.title,
                            style: AppTextStyles.headline3(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: AppSizes.spaceSmall),

                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: AppSizes.iconSmall,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: AppSizes.spaceXSmall),
                              Text(
                                course.rating.toString(),
                                style: AppTextStyles.bodyMedium(context),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.spaceXSmall),

                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spaceSmall,
                              vertical: AppSizes.spaceXSmall / 2,
                            ),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.success.withOpacity(0.1)
                                  : AppColors.primary.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusXSmall),
                            ),
                            child: Text(
                              _getCourseStatus(course),
                              style: AppTextStyles.caption(context).copyWith(
                                color: isCompleted
                                    ? AppColors.success
                                    : AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Completion Icon
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.all(AppSizes.spaceSmall),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: AppSizes.iconSmall,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSizes.spaceLarge),

                // Progress Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'التقدم',
                          style: AppTextStyles.labelMedium(context),
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

                    // Progress Bar
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusXSmall),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.light,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? AppColors.success : AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.spaceXLarge),

                // Action Buttons
                Row(
                  children: [
                    // Continue/Start Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoursePlayerScreen(
                                courseId: course.id,
                                initialLessonIndex: 0,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          progress > 0
                              ? Icons.play_arrow
                              : Icons.play_circle_outline,
                          size: AppSizes.iconMedium,
                        ),
                        label: Text(
                          progress > 0 ? 'متابعة' : 'ابدأ',
                          style: AppTextStyles.buttonLarge(context),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spaceMedium,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMedium),
                          ),
                          elevation: AppSizes.elevationLow,
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSizes.spaceMedium),

                    // Certificate Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            isCompleted ? () => _viewCertificate(course) : null,
                        icon: Icon(
                          Icons.workspace_premium,
                          size: AppSizes.iconMedium,
                          color: isCompleted
                              ? AppColors.secondary
                              : AppColors.textLight,
                        ),
                        label: Text(
                          'شهادة',
                          style: AppTextStyles.buttonMedium(context).copyWith(
                            color: isCompleted
                                ? AppColors.secondary
                                : AppColors.textLight,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isCompleted
                                ? AppColors.secondary
                                : AppColors.textLight,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spaceMedium,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMedium),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to calculate actual progress based on completed lessons
  double _calculateProgress(Course course, dynamic user) {
    if (course.lessons.isEmpty) return 0.0;

    // Count completed lessons
    int completedLessons =
        course.lessons.where((lesson) => lesson.completed).length;
    double progress = completedLessons / course.lessons.length;

    // If all lessons are completed, check exams
    if (progress == 1.0) {
      // Check if all exams are completed
      bool allExamsCompleted = course.exams.every((exam) => !exam.locked);
      if (allExamsCompleted) {
        return 1.0; // 100% completed
      }
    }

    return progress;
  }

  // Helper method to get course status
  String _getCourseStatus(Course course) {
    if (_isCourseCompleted(course)) {
      return 'مكتمل';
    } else if (course.lessons.any((lesson) => lesson.completed)) {
      return 'مستمر';
    } else {
      return 'جديد';
    }
  }

  // Helper method to check if course is completed
  bool _isCourseCompleted(Course course) {
    // Course is completed if all lessons are completed and all exams are unlocked
    bool allLessonsCompleted =
        course.lessons.every((lesson) => lesson.completed);
    bool allExamsUnlocked = course.exams.every((exam) => !exam.locked);

    return allLessonsCompleted && allExamsUnlocked;
  }

  // Helper method to view certificate
  void _viewCertificate(Course course) {
    // In a real app, this would navigate to the certificate screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عرض شهادة الكورس: ${course.title}'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
