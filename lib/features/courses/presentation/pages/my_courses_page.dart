import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/core/constants/app_text_styles.dart';
import 'package:waslaacademy/core/utils/responsive_helper.dart';
import 'package:waslaacademy/core/widgets/empty_state.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_event.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_state.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../learning/presentation/pages/course_content_page.dart';

import 'courses_page.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load data in initState for first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursesBloc>().add(LoadMyEnrollmentsEvent());
    });
  }

  void _refreshData() {
    context.read<CoursesBloc>().add(LoadMyEnrollmentsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'كورساتي',
          style: AppTextStyles.headline2(context),
        ),
        backgroundColor: Colors.white,
        elevation: AppSizes.elevationLow,
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

          // Tab Content
          Expanded(
            child: BlocConsumer<CoursesBloc, CoursesState>(
              listener: (context, state) {
                if (state is CoursesError) {
                  Helpers.showErrorSnackbar(context, state.message);
                }
              },
              builder: (context, state) {
                // Handle initial state and loading
                if (state is CoursesInitial || state is CoursesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is EnrollmentsLoaded) {
                  final enrollments = state.enrollments;

                  if (enrollments.isEmpty) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        EmptyState.noCourses(
                          onBrowsePressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CoursesPage(),
                              ),
                            ).then((_) => _refreshData());
                          },
                        ),
                        const EmptyState(
                          icon: Icons.workspace_premium,
                          title: 'لا توجد كورسات مكتملة',
                          subtitle: 'أكمل الكورسات الحالية للحصول على شهادات',
                          iconColor: AppColors.success,
                        ),
                      ],
                    );
                  }

                  // Separate ongoing and completed
                  final ongoingEnrollments = enrollments
                      .where((e) => e.completionPercentage < 100)
                      .toList();
                  final completedEnrollments = enrollments
                      .where((e) => e.completionPercentage >= 100)
                      .toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // Ongoing
                      ongoingEnrollments.isEmpty
                          ? EmptyState.noCourses(
                              onBrowsePressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CoursesPage(),
                                  ),
                                ).then((_) => _refreshData());
                              },
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(screenPadding),
                              itemCount: ongoingEnrollments.length,
                              itemBuilder: (context, index) {
                                return _buildEnrollmentCard(
                                  ongoingEnrollments[index],
                                );
                              },
                            ),

                      // Completed
                      completedEnrollments.isEmpty
                          ? const EmptyState(
                              icon: Icons.workspace_premium,
                              title: 'لا توجد كورسات مكتملة',
                              subtitle:
                                  'أكمل الكورسات الحالية للحصول على شهادات',
                              iconColor: AppColors.success,
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(screenPadding),
                              itemCount: completedEnrollments.length,
                              itemBuilder: (context, index) {
                                return _buildEnrollmentCard(
                                  completedEnrollments[index],
                                );
                              },
                            ),
                    ],
                  );
                }

                return const Center(
                  child: Text('لا توجد كورسات'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentCard(enrollment) {
    final isCompleted = enrollment.completionPercentage >= 100;
    final progress = enrollment.completionPercentage / 100;

    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.spaceLarge.h),
      elevation: AppSizes.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: InkWell(
        onTap: enrollment.course != null
            ? () {
                // Navigate to course content
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseContentPage(
                      courseId: enrollment.courseId,
                      courseTitle: enrollment.course!.title,
                    ),
                  ),
                ).then((_) => _refreshData());
              }
            : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spaceLarge.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      color: AppColors.light,
                      child: const Icon(
                        Icons.school,
                        size: AppSizes.iconLarge,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  SizedBox(width: AppSizes.spaceMedium.w),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enrollment.course?.title ??
                              'كورس ${enrollment.courseId.substring(0, 8)}',
                          style: AppTextStyles.headline3(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppSizes.spaceSmall.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceSmall.w,
                            vertical: AppSizes.spaceXSmall.h / 2,
                          ),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusXSmall),
                          ),
                          child: Text(
                            isCompleted
                                ? 'مكتمل'
                                : enrollment.status == 'active'
                                    ? 'مستمر'
                                    : 'جديد',
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
                      padding: EdgeInsets.all(AppSizes.spaceSmall.w),
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

              SizedBox(height: AppSizes.spaceLarge.h),

              // Progress
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
                        '${enrollment.completionPercentage}%',
                        style: AppTextStyles.labelLarge(context).copyWith(
                          color: isCompleted
                              ? AppColors.success
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceSmall.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusXSmall),
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

              SizedBox(height: AppSizes.spaceXLarge.h),

              // Buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: enrollment.course != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseContentPage(
                                    courseId: enrollment.courseId,
                                    courseTitle: enrollment.course!.title,
                                  ),
                                ),
                              ).then((_) => _refreshData());
                            }
                          : null,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceMedium.w,
                          vertical: AppSizes.spaceMedium.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.spaceMedium.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isCompleted
                          ? () {
                              Helpers.showInfoSnackbar(
                                context,
                                'سيتم إضافة نظام الشهادات قريباً',
                              );
                            }
                          : null,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceMedium.w,
                          vertical: AppSizes.spaceMedium.h,
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
    );
  }
}
