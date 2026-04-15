import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_event.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../courses/presentation/bloc/courses_bloc.dart';
import '../../../courses/presentation/pages/course_detail_page.dart';
import '../../../courses/presentation/pages/courses_page.dart';
import '../../../courses/data/models/course_model.dart';
import '../widgets/home_banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar_widget.dart';

/// الصفحة الرئيسية
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load data in initState for first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursesBloc>().add(LoadAllCoursesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.light,
      appBar: CustomAppBarWidget(
        title: 'وصلة أكاديمي',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        showAuthIcons: true,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CoursesBloc>().add(LoadAllCoursesEvent());
        },
        child: CustomScrollView(
          slivers: [
            // Top spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.md),
            ),

            // Banner Slider Section
            const SliverToBoxAdapter(
              child: HomeBanner(),
            ),

            // Partners Section
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                context,
                title: 'الشركاء',
                showViewAll: false,
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _buildPartnerIcon(
                      context,
                      icon: Icons.person_outline,
                      label: 'المدربون',
                      color: AppColors.primary,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم إضافة قائمة المدربين قريباً'),
                          ),
                        );
                      },
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _buildPartnerIcon(
                      context,
                      icon: Icons.school_outlined,
                      label: 'المعاهد',
                      color: AppColors.primary,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم إضافة قائمة المعاهد قريباً'),
                          ),
                        );
                      },
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _buildPartnerIcon(
                      context,
                      icon: Icons.account_balance_outlined,
                      label: 'الجامعات',
                      color: AppColors.primary,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم إضافة قائمة الجامعات قريباً'),
                          ),
                        );
                      },
                    )),
                  ],
                ),
              ),
            ),

            // Recommended Courses Section
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                context,
                title: 'الكورسات الموصى بها',
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoursesPage(),
                    ),
                  ).then((_) {
                    // Refresh data when returning
                    context.read<CoursesBloc>().add(LoadAllCoursesEvent());
                  });
                },
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              sliver: BlocBuilder<CoursesBloc, CoursesState>(
                builder: (context, state) {
                  // Handle initial state and loading
                  if (state is CoursesInitial || state is CoursesLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.xl),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  if (state is CoursesError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.xl),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: AppColors.error,
                              ),
                              const SizedBox(height: AppSizes.md),
                              Text(
                                'حدث خطأ في تحميل الكورسات',
                                style: AppTextStyles.bodyLarge(context),
                              ),
                              const SizedBox(height: AppSizes.sm),
                              Text(
                                state.message,
                                style: AppTextStyles.bodyMedium(context),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSizes.lg),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<CoursesBloc>()
                                      .add(LoadAllCoursesEvent());
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is CoursesLoaded) {
                    final recommendedCourses = state.courses.take(3).toList();

                    if (recommendedCourses.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.xl),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.school_outlined,
                                  size: 64,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(height: AppSizes.md),
                                Text(
                                  'لا توجد كورسات متاحة حالياً',
                                  style: AppTextStyles.bodyLarge(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverToBoxAdapter(
                      child: Column(
                        children: recommendedCourses.map((course) {
                          return _buildCourseCard(context, course);
                        }).toList(),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  );
                },
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.xxxl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    VoidCallback? onViewAll,
    bool showViewAll = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ).copyWith(
        top: AppSizes.xxxl,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.headlineMedium(context),
            ),
          ),
          if (showViewAll && onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'عرض الكل',
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPartnerIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              label,
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseModel course) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.lg),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailPage(
                  courseId: course.id,
                ),
              ),
            ).then((_) {
              // Refresh data when returning
              context.read<CoursesBloc>().add(LoadAllCoursesEvent());
            });
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusLg),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: course.thumbnailUrl != null
                      ? CachedNetworkImage(
                          imageUrl: course.thumbnailUrl!,
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
                              Icons.school,
                              size: 64,
                              color: AppColors.textLight,
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.light,
                          child: const Icon(
                            Icons.school,
                            size: 64,
                            color: AppColors.textLight,
                          ),
                        ),
                ),
              ),
              // Course Info
              Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Level
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.title,
                            style: AppTextStyles.headlineSmall(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (course.level != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: AppSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.light,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusSm),
                            ),
                            child: Text(
                              course.level!,
                              style: AppTextStyles.bodySmall(context),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    // Description
                    Text(
                      course.description,
                      style: AppTextStyles.bodyMedium(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.md),
                    // Stats
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          '${course.studentsCount} طالب',
                          style: AppTextStyles.bodySmall(context),
                        ),
                        const SizedBox(width: AppSizes.md),
                        if (course.durationHours != null) ...[
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Text(
                            '${course.durationHours} ساعة',
                            style: AppTextStyles.bodySmall(context),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    // Price and Button
                    Row(
                      children: [
                        Text(
                          course.isFree
                              ? 'مجاني'
                              : '${course.price.toStringAsFixed(0)} ر.ي',
                          style: AppTextStyles.headlineSmall(context).copyWith(
                            color: course.isFree
                                ? AppColors.success
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailPage(
                                  courseId: course.id,
                                ),
                              ),
                            ).then((_) {
                              // Refresh data when returning
                              context
                                  .read<CoursesBloc>()
                                  .add(LoadAllCoursesEvent());
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                            ),
                          ),
                          child: const Text('عرض التفاصيل'),
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
