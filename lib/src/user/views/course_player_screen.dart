import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/user/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/user/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/models/course.dart';
import 'package:waslaacademy/src/user/models/user.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';
import 'package:waslaacademy/src/user/widgets/lesson_item.dart';
import 'package:waslaacademy/src/user/views/exam_screen.dart';
import 'package:waslaacademy/src/user/views/resource_viewer_screen.dart';
import 'package:waslaacademy/src/user/widgets/video_player_widget.dart';

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

class _CoursePlayerScreenState extends State<CoursePlayerScreen>
    with TickerProviderStateMixin {
  Course? _course;
  int _currentLessonIndex = 0;
  bool _isPlaying = false;
  bool _isFullscreen = false;
  Duration _currentPosition = Duration.zero;
  final Duration _totalDuration = Duration.zero;
  late AnimationController _controlsAnimationController;
  int _selectedTabIndex = 0;
  bool _lessonCompleted =
      false; // Track if current lesson is marked as completed
  bool _autoProgressEnabled = false; // Flag to enable auto progression

  @override
  void initState() {
    super.initState();
    _currentLessonIndex = widget.initialLessonIndex;
    _loadCourse();
    _lessonCompleted = false; // Reset completion status

    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controlsAnimationController.dispose();
    super.dispose();
  }

  void _onVideoPositionChanged(Duration position) {
    setState(() {
      _currentPosition = position;
    });
  }

  void _onVideoCompleted() {
    setState(() {
      _isPlaying = false;
    });

    // Mark lesson as completed automatically when video finishes
    _markLessonAsCompleted();

    // Check if all lessons are completed to show exam prompt
    if (_areAllLessonsCompleted()) {
      // Auto-navigate to exam after a short delay
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _course != null && _course!.exams.isNotEmpty) {
          _showExamPrompt();
        }
      });
    } else if (_autoProgressEnabled) {
      // Auto-navigate to next lesson after completion
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _navigateToNextLesson(autoProgress: true);
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
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

  // Check if all lessons in the course are completed
  bool _areAllLessonsCompleted() {
    if (_course == null || _course!.lessons.isEmpty) return false;
    return _course!.lessons.every((lesson) => lesson.completed);
  }

  void _markLessonAsCompleted() {
    if (_lessonCompleted) return; // Prevent duplicate completion marking

    setState(() {
      _lessonCompleted = true;
    });

    // Update the lesson status in the course object
    if (_course != null) {
      final updatedLessons = List<Lesson>.from(_course!.lessons);
      if (_currentLessonIndex < updatedLessons.length) {
        updatedLessons[_currentLessonIndex] =
            updatedLessons[_currentLessonIndex].copyWith(completed: true);

        // Update the course with the completed lesson
        setState(() {
          _course = _course!.copyWith(lessons: updatedLessons);
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم الانتهاء من الدرس')),
    );
  }

  void _navigateToNextLesson({bool autoProgress = false}) {
    if (_course != null && _currentLessonIndex < _course!.lessons.length - 1) {
      setState(() {
        _currentLessonIndex++;
        _lessonCompleted = false; // Reset completion status for new lesson
        _autoProgressEnabled =
            autoProgress; // Enable auto progress if called automatically
      });
    } else if (autoProgress && _course != null && _course!.exams.isNotEmpty) {
      // If we've reached the end of lessons and auto progress is enabled, go to exam
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showExamPrompt();
        }
      });
    }
  }

  void _navigateToPreviousLesson() {
    if (_currentLessonIndex > 0) {
      setState(() {
        _currentLessonIndex--;
        _lessonCompleted = false; // Reset completion status for new lesson
        _autoProgressEnabled =
            false; // Disable auto progress when user manually navigates
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void completeCourse() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إكمال الكورس',
          style: AppTextStyles.headline3(context),
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في إكمال كورس "${_course?.title}"؟',
          style: AppTextStyles.bodyLarge(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyles.buttonMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              performCourseCompletion();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'إكمال',
              style: AppTextStyles.buttonMedium(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMedium,
          vertical: AppSizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.light,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.labelMedium(context).copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildLessonsTab();
      case 1:
        return _buildResourcesTab();
      case 2:
        return _buildExamsTab();
      default:
        return _buildLessonsTab();
    }
  }

  Widget _buildLessonsTab() {
    return ListView.builder(
      padding: ResponsiveHelper.getScreenPadding(context),
      itemCount: _course!.lessons.length,
      itemBuilder: (context, index) {
        final lesson = _course!.lessons[index];
        return LessonItem(
          title: lesson.title,
          duration: lesson.duration,
          type: lesson.type == 'video'
              ? LessonType.video
              : lesson.type == 'assignment'
                  ? LessonType.assignment
                  : LessonType.article,
          isCompleted: lesson.completed,
          isLocked: false,
          order: index + 1,
          description: lesson.description,
          onTap: () {
            setState(() {
              _currentLessonIndex = index;
              _lessonCompleted =
                  false; // Reset completion status for new lesson
              _autoProgressEnabled =
                  false; // Disable auto progress when user manually selects
            });
          },
        );
      },
    );
  }

  Widget _buildResourcesTab() {
    if (_course!.resources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_open,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            Text(
              'لا توجد موارد متاحة',
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: ResponsiveHelper.getScreenPadding(context),
      itemCount: _course!.resources.length,
      itemBuilder: (context, index) {
        final resource = _course!.resources[index];
        return _buildResourceItem(resource);
      },
    );
  }

  Widget _buildResourceItem(Resource resource) {
    IconData icon;
    Color iconColor;

    switch (resource.type.toLowerCase()) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        iconColor = AppColors.danger;
        break;
      case 'zip':
        icon = Icons.archive;
        iconColor = AppColors.warning;
        break;
      case 'video':
        icon = Icons.video_library;
        iconColor = AppColors.primary;
        break;
      case 'document':
      case 'docx':
        icon = Icons.description;
        iconColor = AppColors.info;
        break;
      case 'spreadsheet':
      case 'xlsx':
        icon = Icons.table_chart;
        iconColor = AppColors.success;
        break;
      default:
        icon = Icons.insert_drive_file;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResourceViewerScreen(
                  resource: resource,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spaceMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              border: Border.all(color: AppColors.light),
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.avatarMedium,
                  height: AppSizes.avatarMedium,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconMedium,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource.name,
                        style: AppTextStyles.labelLarge(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSizes.spaceXSmall),
                      Row(
                        children: [
                          Text(
                            resource.size,
                            style: AppTextStyles.caption(context),
                          ),
                          const SizedBox(width: AppSizes.spaceSmall),
                          Text(
                            '•',
                            style: AppTextStyles.caption(context),
                          ),
                          const SizedBox(width: AppSizes.spaceSmall),
                          Text(
                            resource.date,
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download,
                  size: AppSizes.iconMedium,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamsTab() {
    if (_course!.exams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            Text(
              'لا توجد امتحانات متاحة',
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: ResponsiveHelper.getScreenPadding(context),
      itemCount: _course!.exams.length,
      itemBuilder: (context, index) {
        final exam = _course!.exams[index];
        // Unlock exam only if all lessons are completed
        final isUnlocked = _areAllLessonsCompleted() || !exam.locked;

        return _buildExamItem(exam, isUnlocked);
      },
    );
  }

  Widget _buildExamItem(Exam exam, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamScreen(
                        exam: exam,
                        courseId: widget.courseId,
                      ),
                    ),
                  ).then((_) {
                    // Refresh course data after returning from exam
                    _loadCourse();
                  });
                }
              : null,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spaceMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              border: Border.all(color: AppColors.light),
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.avatarMedium,
                  height: AppSizes.avatarMedium,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? AppColors.warning.withOpacity(0.1)
                        : AppColors.textLight.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isUnlocked ? Icons.quiz : Icons.lock,
                    size: AppSizes.iconMedium,
                    color: isUnlocked ? AppColors.warning : AppColors.textLight,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: AppTextStyles.labelLarge(context).copyWith(
                          color: isUnlocked
                              ? AppColors.textPrimary
                              : AppColors.textLight,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSizes.spaceXSmall),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: AppSizes.iconXSmall,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: AppSizes.spaceXSmall),
                          Text(
                            exam.duration,
                            style: AppTextStyles.caption(context),
                          ),
                          const SizedBox(width: AppSizes.spaceSmall),
                          Text(
                            '•',
                            style: AppTextStyles.caption(context),
                          ),
                          const SizedBox(width: AppSizes.spaceSmall),
                          Text(
                            '${exam.questions} سؤال',
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isUnlocked)
                  const Icon(
                    Icons.play_arrow,
                    size: AppSizes.iconMedium,
                    color: AppColors.primary,
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceSmall,
                      vertical: AppSizes.spaceXSmall / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Text(
                      'مقفل',
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void performCourseCompletion() {
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
              'جاري إكمال الكورس...',
              style: AppTextStyles.bodyLarge(context),
            ),
          ],
        ),
      ),
    );

    // Simulate completion process
    Future.delayed(const Duration(seconds: 1), () {
      // Add course to completed courses
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthSuccess) {
        final user = authState.user;
        final updatedCompletedCourses = List<int>.from(user.completedCourses);
        if (!updatedCompletedCourses.contains(_course!.id)) {
          updatedCompletedCourses.add(_course!.id);
        }

        // Remove from enrolled courses
        final updatedEnrolledCourses = List<int>.from(user.enrolledCourses);
        updatedEnrolledCourses.remove(_course!.id);

        // Create certificate
        final certificate = Certificate(
          id: DateTime.now().millisecondsSinceEpoch,
          courseId: _course!.id,
          courseName: _course!.title,
          date: DateTime.now().toString().split('T')[0],
        );

        final updatedCertificates = List<Certificate>.from(user.certificates);
        updatedCertificates.add(certificate);

        context.read<AuthBloc>().add(UpdateUserProgress(
              enrolledCourses: updatedEnrolledCourses,
              completedCourses: updatedCompletedCourses,
              certificates: updatedCertificates,
            ));

        context.read<CourseBloc>().add(CompleteCourse(courseId: _course!.id));
      }

      Navigator.of(context).pop(); // Close loading dialog

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: AppSizes.spaceSmall),
              Expanded(
                child:
                    Text('تهانينا! لقد أكملت كورس "${_course?.title}" بنجاح!'),
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

      // Navigate back to main screen
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {
            'initialTab': 3, // Certificates tab index
          },
        );
      });
    });
  }

  // Show prompt to start exam when all lessons are completed
  void _showExamPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('تهانينا!'),
        content: const Text(
            'لقد أكملت جميع دروس الكورس. هل ترغب في بدء الامتحان النهائي الآن؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to the first available exam
              if (_course!.exams.isNotEmpty) {
                final firstUnlockedExam = _course!.exams.firstWhere(
                  (exam) => !exam.locked,
                  orElse: () => _course!.exams.first,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamScreen(
                      exam: firstUnlockedExam,
                      courseId: widget.courseId,
                    ),
                  ),
                ).then((_) {
                  // Refresh course data after returning from exam
                  _loadCourse();
                });
              }
            },
            child: const Text('ابدأ الامتحان'),
          ),
        ],
      ),
    );
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
          SizedBox(
            height: ResponsiveHelper.isTablet(context) ? 300 : 200,
            child: currentLesson.type == 'video'
                ? SimpleVideoPlayer(
                    title: currentLesson.title,
                    onVideoCompleted: _onVideoCompleted,
                    onPositionChanged: _onVideoPositionChanged,
                    autoPlay: false,
                  )
                : VideoPlaceholder(
                    title: currentLesson.title,
                    duration: currentLesson.duration,
                    onPlay: _togglePlayPause,
                  ),
          ),

          // Lesson Info
          Container(
            padding: screenPadding,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentLesson.title,
                        style: AppTextStyles.headline2(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (currentLesson.completed || _lessonCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceSmall,
                          vertical: AppSizes.spaceXSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusSmall),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: AppSizes.iconSmall,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: AppSizes.spaceXSmall),
                            Text(
                              'مكتمل',
                              style: AppTextStyles.caption(context).copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.spaceXSmall),
                    Text(
                      currentLesson.duration,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                    Text(
                      '•',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                    Text(
                      'الدرس ${_currentLessonIndex + 1} من ${_course!.lessons.length}',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                // Video Progress Bar (only for video lessons)
                if (currentLesson.type == 'video' &&
                    _totalDuration.inSeconds > 0) ...[
                  const SizedBox(height: AppSizes.spaceMedium),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_currentPosition),
                            style: AppTextStyles.caption(context),
                          ),
                          Text(
                            _formatDuration(_totalDuration),
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spaceXSmall),
                      LinearProgressIndicator(
                        value: _totalDuration.inSeconds > 0
                            ? _currentPosition.inSeconds /
                                _totalDuration.inSeconds
                            : 0.0,
                        backgroundColor: AppColors.light,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusXSmall),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: AppSizes.spaceMedium),
                Text(
                  currentLesson.description,
                  style: AppTextStyles.bodyLarge(context),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
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
                    onPressed: () => _navigateToNextLesson(autoProgress: true),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('الدرس التالي'),
                    style: OutlinedButton.styleFrom(
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

          // Course Content with Tabs
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Tab Bar
                  Container(
                    padding: screenPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _buildTabButton('الدروس', 0),
                              const SizedBox(width: AppSizes.spaceSmall),
                              _buildTabButton('الموارد', 1),
                              const SizedBox(width: AppSizes.spaceSmall),
                              _buildTabButton('الامتحانات', 2),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed:
                              _areAllLessonsCompleted() ? completeCourse : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spaceMedium,
                              vertical: AppSizes.spaceSmall,
                            ),
                          ),
                          child: Text(
                            'إكمال الكورس',
                            style: AppTextStyles.buttonMedium(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab Content
                  Expanded(
                    child: _buildTabContent(),
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
