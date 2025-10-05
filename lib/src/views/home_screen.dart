import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';
import 'package:waslaacademy/src/views/course_detail_screen.dart';
import 'package:waslaacademy/src/views/courses_screen.dart';
import 'package:waslaacademy/src/views/instructors_screen.dart';
import 'package:waslaacademy/src/views/institutes_screen.dart';
import 'package:waslaacademy/src/views/universities_screen.dart';
import 'package:waslaacademy/src/widgets/course_card.dart';
import 'package:waslaacademy/src/widgets/banner_slider.dart';
import 'package:waslaacademy/src/widgets/integrated_drawer.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(LoadCourses());
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.light,
      appBar: CustomAppBar(
        title: 'وصلة أكاديمي',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        showAuthIcons: true,
      ),
      drawer: const IntegratedDrawer(),
      body: CustomScrollView(
        slivers: [
          // Top spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.spaceMedium),
          ),

          // Banner Slider Section
          const SliverToBoxAdapter(
            child: BannerSlider(),
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
              margin:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
              padding: const EdgeInsets.all(AppSizes.spaceLarge),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
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
                  _buildPartnerIcon(
                    context,
                    icon: Icons.person_outline,
                    label: 'المدربون',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InstructorsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPartnerIcon(
                    context,
                    icon: Icons.school_outlined,
                    label: 'المعاهد',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InstitutesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPartnerIcon(
                    context,
                    icon: Icons.account_balance_outlined,
                    label: 'الجامعات',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UniversitiesScreen(),
                        ),
                      );
                    },
                  ),
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
                    builder: (context) => const CoursesScreen(),
                  ),
                );
              },
            ),
          ),

          SliverPadding(
            padding: screenPadding,
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<CourseBloc, CourseState>(
                builder: (context, state) {
                  if (state is CourseLoaded) {
                    final recommendedCourses =
                        state.courses.skip(2).take(3).toList();
                    return Column(
                      children: recommendedCourses.map((course) {
                        return CourseCard(
                          course: course,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailScreen(
                                  courseId: course.id,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.spaceXXLarge),
          ),
        ],
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
      padding: ResponsiveHelper.getScreenHorizontalPadding(context).copyWith(
        top: AppSizes.spaceXXLarge,
        bottom: AppSizes.spaceMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.headline2(context),
            ),
          ),
          if (showViewAll && onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'عرض الكل',
                style: AppTextStyles.link(context),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.spaceSmall),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppSizes.iconLarge,
            color: color,
          ),
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        Text(
          value,
          style: AppTextStyles.headline3(context).copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spaceMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceLarge),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSizes.iconXXLarge,
                color: color,
              ),
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            Text(
              label,
              style: AppTextStyles.labelMedium(context).copyWith(
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
}
