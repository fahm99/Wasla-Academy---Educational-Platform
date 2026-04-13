import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/core/constants/app_colors.dart';
import 'package:waslaacademy/core/constants/app_sizes.dart';
import 'package:waslaacademy/core/constants/app_text_styles.dart';
import 'package:waslaacademy/core/utils/responsive_helper.dart';
import 'package:waslaacademy/core/widgets/empty_state.dart';
import 'package:waslaacademy/core/widgets/search_bar_widget.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_event.dart';
import 'package:waslaacademy/features/courses/presentation/bloc/courses_state.dart';
import '../../../../core/utils/helpers.dart';

import '../bloc/courses_bloc.dart';
import 'course_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'الكل';

  @override
  bool get wantKeepAlive => true;

  final List<String> _categories = [
    'الكل',
    'تقنية',
    'لغات',
    'تنمية بشرية',
    'أعمال',
    'تصميم',
    'تسويق',
  ];

  @override
  void initState() {
    super.initState();
    // Load data in initState for first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursesBloc>().add(LoadAllCoursesEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });

    final categoryKey = category != 'الكل' ? _getCategoryKey(category) : null;
    final query =
        _searchController.text.isNotEmpty ? _searchController.text : null;

    if (categoryKey != null || query != null) {
      context.read<CoursesBloc>().add(
            SearchCoursesEvent(
              query: query,
              category: categoryKey,
            ),
          );
    } else {
      context.read<CoursesBloc>().add(LoadAllCoursesEvent());
    }
  }

  String _getCategoryKey(String categoryName) {
    switch (categoryName) {
      case 'تقنية':
        return 'tech';
      case 'لغات':
        return 'language';
      case 'تنمية بشرية':
        return 'development';
      case 'أعمال':
        return 'business';
      case 'تصميم':
        return 'design';
      case 'تسويق':
        return 'marketing';
      default:
        return 'all';
    }
  }

  void _refreshCourses() {
    if (_searchController.text.isNotEmpty || _selectedCategory != 'الكل') {
      context.read<CoursesBloc>().add(
            SearchCoursesEvent(
              query: _searchController.text.isNotEmpty
                  ? _searchController.text
                  : null,
              category: _selectedCategory != 'الكل'
                  ? _getCategoryKey(_selectedCategory)
                  : null,
            ),
          );
    } else {
      context.read<CoursesBloc>().add(LoadAllCoursesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'الكورسات',
          style: AppTextStyles.headline2(context),
        ),
        backgroundColor: Colors.white,
        elevation: AppSizes.elevationLow,
        actions: [
          IconButton(
            onPressed: () {
              // Advanced search
            },
            icon: const Icon(Icons.tune),
            tooltip: 'بحث متقدم',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(screenPadding),
              child: SearchBarWidget(
                controller: _searchController,
                hintText: 'البحث في الكورسات...',
                onChanged: (value) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (_searchController.text == value) {
                      if (value.isNotEmpty || _selectedCategory != 'الكل') {
                        context.read<CoursesBloc>().add(
                              SearchCoursesEvent(
                                query: value.isNotEmpty ? value : null,
                                category: _selectedCategory != 'الكل'
                                    ? _getCategoryKey(_selectedCategory)
                                    : null,
                              ),
                            );
                      } else {
                        context.read<CoursesBloc>().add(LoadAllCoursesEvent());
                      }
                    }
                  });
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty || _selectedCategory != 'الكل') {
                    context.read<CoursesBloc>().add(
                          SearchCoursesEvent(
                            query: value.isNotEmpty ? value : null,
                            category: _selectedCategory != 'الكل'
                                ? _getCategoryKey(_selectedCategory)
                                : null,
                          ),
                        );
                  } else {
                    context.read<CoursesBloc>().add(LoadAllCoursesEvent());
                  }
                },
              ),
            ),

            // Filter Chips
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: screenPadding / 2,
                  vertical: AppSizes.spaceSmall,
                ),
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: EdgeInsets.only(right: AppSizes.spaceSmall.w),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => _onCategoryChanged(category),
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: AppTextStyles.labelMedium(context).copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textLight,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Courses List
            Expanded(
              child: BlocConsumer<CoursesBloc, CoursesState>(
                listener: (context, state) {
                  if (state is CoursesError) {
                    Helpers.showErrorSnackbar(context, state.message);
                  }
                },
                builder: (context, state) {
                  // Handle initial state - show loading
                  if (state is CoursesInitial || state is CoursesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CoursesLoaded) {
                    final courses = state.courses;

                    if (courses.isEmpty) {
                      return EmptyState.noSearchResults(
                        searchQuery: _searchController.text,
                        onClearSearch: () {
                          _searchController.clear();
                          setState(() {
                            _selectedCategory = 'الكل';
                          });
                          context
                              .read<CoursesBloc>()
                              .add(LoadAllCoursesEvent());
                        },
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _refreshCourses();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(screenPadding),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return _buildCourseCard(course);
                        },
                      ),
                    );
                  }

                  if (state is CoursesError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(screenPadding),
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
                              'حدث خطأ',
                              style: AppTextStyles.headline2(context),
                            ),
                            SizedBox(height: AppSizes.spaceSmall.h),
                            Text(
                              state.message,
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppSizes.spaceXLarge.h),
                            ElevatedButton(
                              onPressed: _refreshCourses,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.spaceXXLarge.w,
                                  vertical: AppSizes.spaceMedium.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.radiusMedium),
                                ),
                              ),
                              child: Text(
                                'إعادة المحاولة',
                                style: AppTextStyles.buttonLarge(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(course) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.spaceLarge.h),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(courseId: course.id),
            ),
          ).then((_) {
            // Refresh data when returning
            _refreshCourses();
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image with Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: course.displayImage != null
                        ? CachedNetworkImage(
                            imageUrl: course.displayImage!,
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
                                size: 48,
                                color: AppColors.textLight,
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withOpacity(0.1),
                                  AppColors.secondary.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.school_rounded,
                                size: 64,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                  ),
                ),
                // Price Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          course.isFree ? AppColors.success : AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      course.isFree ? 'مجاني' : '${course.price} ر.س',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Rating Badge
                if (course.rating > 0)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Course Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    style: AppTextStyles.headline3(context).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    course.description,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  // Divider
                  Container(
                    height: 1,
                    color: AppColors.light,
                  ),

                  const SizedBox(height: 12),

                  // Stats Row
                  Row(
                    children: [
                      // Students
                      _buildStatItem(
                        Icons.people_outline_rounded,
                        '${course.studentsCount}',
                        AppColors.primary,
                      ),

                      const SizedBox(width: 20),

                      // Duration (if available)
                      if (course.durationHours != null)
                        _buildStatItem(
                          Icons.access_time_rounded,
                          '${course.durationHours} ساعة',
                          AppColors.info,
                        ),

                      const Spacer(),

                      // Enroll Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'اشترك الآن',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
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
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
