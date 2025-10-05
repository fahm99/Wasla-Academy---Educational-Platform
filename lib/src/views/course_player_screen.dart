import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';
import 'package:waslaacademy/src/widgets/lesson_item.dart';

class CoursePlayerScreen extends StatefulWidget {
  final int courseId;
  final int initialLessonIndex;

  const CoursePlayerScreen({
    super.key,
    required this.courseId,
    required this.initialLessonIndex,
  });

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  Course? _course;
  int _currentLessonIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _currentLessonIndex = widget.initialLessonIndex;
    _loadCourse();
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

  void _markLessonAsCompleted() {
    // In a real app, this would update the user's progress
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم الانتهاء من الدرس')),
    );
  }

  void _navigateToNextLesson() {
    if (_course != null && _currentLessonIndex < _course!.lessons.length - 1) {
      setState(() {
        _currentLessonIndex++;
      });
    }
  }

  void _navigateToPreviousLesson() {
    if (_currentLessonIndex > 0) {
      setState(() {
        _currentLessonIndex--;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_course == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('مشغل الكورس'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentLesson = _course!.lessons[_currentLessonIndex];
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_course!.title),
        actions: [
          IconButton(
            onPressed: _markLessonAsCompleted,
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'تم الانتهاء من الدرس',
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player Area
          Container(
            height: ResponsiveHelper.isTablet(context) ? 300 : 200,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video Placeholder
                Container(
                  color: Colors.grey[900],
                  child: const Icon(
                    Icons.play_circle_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                // Play/Pause Button
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lesson Info
          Container(
            padding: screenPadding,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentLesson.title,
                  style: AppTextStyles.headline2(context),
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  '${currentLesson.duration} • الدرس ${_currentLessonIndex + 1} من ${_course!.lessons.length}',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceMedium),
                Text(
                  currentLesson.description,
                  style: AppTextStyles.bodyLarge(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceSmall),

          // Lesson Navigation
          Container(
            padding: screenPadding,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _navigateToPreviousLesson,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('الدرس السابق'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceMedium),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _navigateToNextLesson,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('الدرس التالي'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceSmall),

          // Course Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: screenPadding,
                    child: Text(
                      'محتوى الكورس',
                      style: AppTextStyles.headline3(context),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _course!.lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = _course!.lessons[index];
                        return LessonItem(
                          title: lesson.title,
                          duration: lesson.duration,
                          type: lesson.type == 'video'
                              ? LessonType.video
                              : LessonType.article,
                          isCompleted: lesson.completed,
                          isLocked: false,
                          order: index + 1,
                          onTap: () {
                            setState(() {
                              _currentLessonIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
