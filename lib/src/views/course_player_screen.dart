import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/models/user.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';
import 'package:waslaacademy/src/widgets/lesson_item.dart';
import 'package:waslaacademy/src/views/exam_screen.dart';
import 'package:waslaacademy/src/views/resource_viewer_screen.dart';
import 'package:waslaacademy/src/widgets/video_player_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _currentLessonIndex = widget.initialLessonIndex;
    _loadCourse();

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
    _markLessonAsCompleted();

    // Auto-navigate to next lesson after completion
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _navigateToNextLesson();
      }
    });
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
        return _buildExamItem(exam);
      },
    );
  }

  Widget _buildExamItem(Exam exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: exam.locked
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamScreen(
                        exam: exam,
                        courseId: widget.courseId,
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
                    color: exam.locked
                        ? AppColors.textLight.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    exam.locked ? Icons.lock : Icons.quiz,
                    size: AppSizes.iconMedium,
                    color:
                        exam.locked ? AppColors.textLight : AppColors.warning,
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
                          color: exam.locked
                              ? AppColors.textLight
                              : AppColors.textPrimary,
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
                if (!exam.locked)
                  const Icon(
                    Icons.play_arrow,
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
                    if (currentLesson.completed)
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
                    onPressed: _navigateToNextLesson,
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
                          onPressed: completeCourse,
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
