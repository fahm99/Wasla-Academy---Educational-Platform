import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/views/course_detail_screen.dart';
import 'package:waslaacademy/src/views/advanced_search_screen.dart';
import 'package:waslaacademy/src/widgets/course_card.dart';
import 'package:waslaacademy/src/widgets/search_bar_widget.dart';
import 'package:waslaacademy/src/widgets/filter_chip_widget.dart';
import 'package:waslaacademy/src/widgets/empty_state.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'الكل';
  final List<Course> _filteredCourses = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

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
    context.read<CourseBloc>().add(LoadCourses());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreCourses();
    }
  }

  void _loadMoreCourses() {
    if (!_isLoading && _hasMore) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading more courses
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _currentPage++;
            // In real app, this would load more courses from API
            if (_currentPage > 3) {
              _hasMore = false;
            }
          });
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    // This will be handled by the search bar widget
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
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
    context.read<CourseBloc>().add(LoadCourses());
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
  }

  List<Course> _applyFilters(List<Course> courses) {
    List<Course> filtered = courses;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((course) {
        return course.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            course.description
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'الكل') {
      final categoryKey = _getCategoryKey(_selectedCategory);
      filtered =
          filtered.where((course) => course.category == categoryKey).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: const CustomAppBar(
        title: 'الكورسات',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Search Bar
            Container(
              color: Colors.white,
              padding: screenPadding,
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: AppSizes.iconMedium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'الكورسات',
                          style: AppTextStyles.headline2(context),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdvancedSearchScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.tune,
                          size: AppSizes.iconMedium,
                        ),
                        tooltip: 'بحث متقدم',
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spaceMedium),

                  // Search Bar
                  SearchBarWidget(
                    controller: _searchController,
                    hintText: 'البحث في الكورسات...',
                    onChanged: (value) {
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),

            // Filter Chips (Scrollable horizontally)
            Container(
              color: Colors.white,
              child: FilterChipGroup(
                options: _categories,
                selectedOption: _selectedCategory,
                onSelectionChanged: _onCategoryChanged,
                padding: EdgeInsets.symmetric(
                  horizontal: screenPadding.horizontal / 2,
                  vertical: AppSizes.spaceSmall,
                ),
              ),
            ),

            // Courses List
            Expanded(
              child: BlocBuilder<CourseBloc, CourseState>(
                builder: (context, state) {
                  if (state is CourseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CourseLoaded) {
                    final filteredCourses = _applyFilters(state.courses);

                    if (filteredCourses.isEmpty) {
                      return EmptyState.noSearchResults(
                        searchQuery: _searchController.text,
                        onClearSearch: () {
                          _searchController.clear();
                          setState(() {
                            _selectedCategory = 'الكل';
                          });
                        },
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _refreshCourses();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: screenPadding,
                        itemCount:
                            filteredCourses.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == filteredCourses.length) {
                            // Loading indicator at the bottom
                            return Container(
                              padding:
                                  const EdgeInsets.all(AppSizes.spaceLarge),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return CourseCard(
                            course: filteredCourses[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailScreen(
                                    courseId: filteredCourses[index].id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else if (state is CourseError) {
                    return Center(
                      child: Padding(
                        padding: screenPadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: AppSizes.iconXXXLarge,
                              color: AppColors.danger,
                            ),
                            const SizedBox(height: AppSizes.spaceLarge),
                            Text(
                              'حدث خطأ',
                              style: AppTextStyles.headline2(context),
                            ),
                            const SizedBox(height: AppSizes.spaceSmall),
                            Text(
                              state.message,
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSizes.spaceXLarge),
                            ElevatedButton(
                              onPressed: _refreshCourses,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.spaceXXLarge,
                                  vertical: AppSizes.spaceMedium,
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
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8)
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  const Text(
                    'تصفية الكورسات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'التصنيفات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                            _onCategoryChanged(category);
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = 'الكل';
                                _searchController.clear();
                              });
                              _refreshCourses();
                              Navigator.pop(context);
                            },
                            child: const Text('إعادة تعيين'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('تطبيق'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
