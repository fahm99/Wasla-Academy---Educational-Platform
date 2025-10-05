import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/widgets/course_card.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';
import 'package:waslaacademy/src/widgets/search_bar_widget.dart';
import 'package:waslaacademy/src/widgets/filter_chip_widget.dart';
import 'package:waslaacademy/src/widgets/empty_state.dart';
import 'package:waslaacademy/src/views/course_detail_screen.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final TextEditingController _keywordController = TextEditingController();
  String _selectedCategory = 'all';
  List<String> _selectedLevels = [];
  double _minPrice = 0;
  double _maxPrice = 500;
  double _minRating = 0;
  String _selectedDuration = 'all';
  bool _isFilterExpanded = false;

  List<Course> _filteredCourses = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadAllCourses();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  void _loadAllCourses() {
    final courseState = context.read<CourseBloc>().state;
    if (courseState is CourseLoaded) {
      setState(() {
        _filteredCourses = courseState.courses;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final courseState = context.read<CourseBloc>().state;
      if (courseState is CourseLoaded) {
        setState(() {
          _filteredCourses = courseState.courses.where((course) {
            // Keyword filter
            bool keywordMatch = _keywordController.text.isEmpty ||
                course.title
                    .toLowerCase()
                    .contains(_keywordController.text.toLowerCase()) ||
                course.description
                    .toLowerCase()
                    .contains(_keywordController.text.toLowerCase());

            // Category filter
            bool categoryMatch = _selectedCategory == 'all' ||
                course.category == _selectedCategory;

            // Level filter
            bool levelMatch = _selectedLevels.isEmpty ||
                _selectedLevels.contains(course.level);

            // Price filter
            bool priceMatch =
                course.price >= _minPrice && course.price <= _maxPrice;

            // Rating filter
            bool ratingMatch = course.rating >= _minRating;

            // Duration filter
            bool durationMatch = _selectedDuration == 'all' ||
                _matchesDuration(course, _selectedDuration);

            return keywordMatch &&
                categoryMatch &&
                levelMatch &&
                priceMatch &&
                ratingMatch &&
                durationMatch;
          }).toList();
          _isSearching = false;
        });
      }
    });
  }

  bool _matchesDuration(Course course, String duration) {
    // Mock duration matching based on course ID
    switch (duration) {
      case 'short': // < 5 hours
        return course.id % 4 == 0;
      case 'medium': // 5-20 hours
        return course.id % 4 == 1 || course.id % 4 == 2;
      case 'long': // > 20 hours
        return course.id % 4 == 3;
      default:
        return true;
    }
  }

  void _resetFilters() {
    setState(() {
      _keywordController.clear();
      _selectedCategory = 'all';
      _selectedLevels.clear();
      _minPrice = 0;
      _maxPrice = 500;
      _minRating = 0;
      _selectedDuration = 'all';
      _loadAllCourses();
    });
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'tech':
        return 'تقنية';
      case 'language':
        return 'لغات';
      case 'development':
        return 'تنمية بشرية';
      case 'business':
        return 'أعمال';
      default:
        return 'الكل';
    }
  }

  String _getLevelName(String level) {
    switch (level) {
      case 'beginner':
        return 'مبتدئ';
      case 'intermediate':
        return 'متوسط';
      case 'advanced':
        return 'متقدم';
      default:
        return 'الكل';
    }
  }

  String _getDurationName(String duration) {
    switch (duration) {
      case 'short':
        return 'قصير (أقل من 5 ساعات)';
      case 'medium':
        return 'متوسط (5-20 ساعة)';
      case 'long':
        return 'طويل (أكثر من 20 ساعة)';
      default:
        return 'الكل';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'بحث متقدم',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: screenPadding,
            child: SearchBarWidget(
              controller: _keywordController,
              hintText: 'البحث في الكورسات...',
              onChanged: (value) {
                _applyFilters();
              },
              onSubmitted: (value) {
                _applyFilters();
              },
            ),
          ),

          // Collapsible Filters Section
          Container(
            margin:
                EdgeInsets.symmetric(horizontal: screenPadding.horizontal / 2),
            child: Card(
              elevation: AppSizes.elevationLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                children: [
                  // Filter Header
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isFilterExpanded = !_isFilterExpanded;
                      });
                    },
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(AppSizes.radiusMedium),
                      bottom: _isFilterExpanded
                          ? Radius.zero
                          : const Radius.circular(AppSizes.radiusMedium),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.spaceLarge),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.tune,
                            size: AppSizes.iconMedium,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSizes.spaceSmall),
                          Expanded(
                            child: Text(
                              'خيارات البحث المتقدم',
                              style: AppTextStyles.headline3(context),
                            ),
                          ),
                          Icon(
                            _isFilterExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: AppSizes.iconMedium,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Filter Content
                  if (_isFilterExpanded) ...[
                    const Divider(height: 1, color: AppColors.light),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.spaceLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Filter
                          Text(
                            'التصنيف',
                            style: AppTextStyles.labelLarge(context),
                          ),
                          const SizedBox(height: AppSizes.spaceSmall),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            items: [
                              'all',
                              'tech',
                              'language',
                              'development',
                              'business',
                            ].map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  _getCategoryName(category),
                                  style: AppTextStyles.bodyLarge(context),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                                _applyFilters();
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMedium),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spaceMedium,
                                vertical: AppSizes.spaceSmall,
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSizes.spaceLarge),

                          // Level Filter (Multi-select chips)
                          Text(
                            'المستوى',
                            style: AppTextStyles.labelLarge(context),
                          ),
                          const SizedBox(height: AppSizes.spaceSmall),
                          MultiSelectFilterChipGroup(
                            options: const [
                              'beginner',
                              'intermediate',
                              'advanced'
                            ],
                            selectedOptions: _selectedLevels,
                            onSelectionChanged: (selected) {
                              setState(() {
                                _selectedLevels =
                                    selected.map((level) => level).toList();
                                _applyFilters();
                              });
                            },
                            padding: EdgeInsets.zero,
                            wrap: true,
                          ),

                          const SizedBox(height: AppSizes.spaceLarge),

                          // Price Range Slider
                          Text(
                            'السعر (${_minPrice.round()} - ${_maxPrice.round()} ر.س)',
                            style: AppTextStyles.labelLarge(context),
                          ),
                          RangeSlider(
                            values: RangeValues(_minPrice, _maxPrice),
                            min: 0,
                            max: 1000,
                            divisions: 20,
                            labels: RangeLabels(
                              '${_minPrice.round()}',
                              '${_maxPrice.round()}',
                            ),
                            onChanged: (values) {
                              setState(() {
                                _minPrice = values.start;
                                _maxPrice = values.end;
                              });
                            },
                            onChangeEnd: (values) {
                              _applyFilters();
                            },
                          ),

                          const SizedBox(height: AppSizes.spaceLarge),

                          // Rating Filter
                          Text(
                            'التقييم (${_minRating.toStringAsFixed(1)} نجوم فأعلى)',
                            style: AppTextStyles.labelLarge(context),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              final starValue = index + 1.0;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _minRating = starValue;
                                    _applyFilters();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      AppSizes.spaceXSmall),
                                  child: Icon(
                                    Icons.star,
                                    size: AppSizes.iconLarge,
                                    color: starValue <= _minRating
                                        ? AppColors.warning
                                        : AppColors.textLight,
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: AppSizes.spaceLarge),

                          // Duration Filter
                          Text(
                            'المدة',
                            style: AppTextStyles.labelLarge(context),
                          ),
                          const SizedBox(height: AppSizes.spaceSmall),
                          DropdownButtonFormField<String>(
                            value: _selectedDuration,
                            items: [
                              'all',
                              'short',
                              'medium',
                              'long',
                            ].map((duration) {
                              return DropdownMenuItem(
                                value: duration,
                                child: Text(
                                  _getDurationName(duration),
                                  style: AppTextStyles.bodyLarge(context),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDuration = value!;
                                _applyFilters();
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMedium),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spaceMedium,
                                vertical: AppSizes.spaceSmall,
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSizes.spaceXLarge),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _resetFilters,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: AppColors.primary),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSizes.spaceMedium,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.radiusMedium),
                                    ),
                                  ),
                                  child: Text(
                                    'مسح الفلاتر',
                                    style: AppTextStyles.buttonLarge(context)
                                        .copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizes.spaceMedium),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _applyFilters,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSizes.spaceMedium,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.radiusMedium),
                                    ),
                                    elevation: AppSizes.elevationLow,
                                  ),
                                  child: Text(
                                    'بحث',
                                    style: AppTextStyles.buttonLarge(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Results Header
          Padding(
            padding: screenPadding,
            child: Row(
              children: [
                Text(
                  'نتائج البحث',
                  style: AppTextStyles.headline2(context),
                ),
                const Spacer(),
                if (_filteredCourses.isNotEmpty)
                  Text(
                    '${_filteredCourses.length} كورس',
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceSmall),

          // Results List
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _filteredCourses.isEmpty
                    ? EmptyState.noSearchResults(
                        searchQuery: _keywordController.text,
                        onClearSearch: () {
                          _keywordController.clear();
                          _resetFilters();
                        },
                      )
                    : ListView.builder(
                        padding: screenPadding,
                        itemCount: _filteredCourses.length,
                        itemBuilder: (context, index) {
                          return CourseCard(
                            course: _filteredCourses[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailScreen(
                                    courseId: _filteredCourses[index].id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
