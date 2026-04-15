import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../exams/presentation/bloc/exams_bloc.dart';
import '../../../exams/presentation/pages/exam_page.dart';
import '../bloc/learning_bloc.dart';
import 'lesson_viewer_page.dart';

/// صفحة محتوى الكورس (الدروس والامتحانات)
class CourseContentPage extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CourseContentPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    // Prevent over-fetching: only load once
    if (_hasLoadedData) return;
    _hasLoadedData = true;
    
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      // تحميل الدروس
      context.read<LearningBloc>().add(
            LoadCourseLessonsEvent(
              studentId: authState.user.id,
              courseId: widget.courseId,
            ),
          );

      // تحميل الامتحانات
      context.read<ExamsBloc>().add(
            LoadCourseExamsEvent(
              courseId: widget.courseId,
              studentId: authState.user.id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          widget.courseTitle,
          style: AppTextStyles.headlineMedium(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocBuilder<LearningBloc, LearningState>(
        builder: (context, learningState) {
          if (learningState is LearningLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (learningState is LearningError) {
            return _buildErrorState(learningState.message);
          }

          if (learningState is CourseLessonsLoaded) {
            return BlocBuilder<ExamsBloc, ExamsState>(
              builder: (context, examsState) {
                // تجميع البيانات
                final moduleMap = _groupLessonsByModule(learningState.lessons);
                final exams =
                    examsState is CourseExamsLoaded ? examsState.exams : [];
                final examResults = examsState is CourseExamsLoaded
                    ? Map<String, dynamic>.from(examsState.results)
                    : <String, dynamic>{};
                final canRetake = examsState is CourseExamsLoaded
                    ? Map<String, bool>.from(examsState.canRetake)
                    : <String, bool>{};

                // تجميع الامتحانات حسب الوحدة
                final Map<String?, List<dynamic>> examsByModule = {};
                for (var exam in exams) {
                  final moduleId = exam.moduleId;
                  if (!examsByModule.containsKey(moduleId)) {
                    examsByModule[moduleId] = [];
                  }
                  examsByModule[moduleId]!.add(exam);
                }

                if (moduleMap.isEmpty && exams.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadData(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    children: [
                      // امتحانات الكورس بالكامل (module_id = null)
                      if (examsByModule[null] != null &&
                          examsByModule[null]!.isNotEmpty)
                        _buildCourseExamsSection(
                          context,
                          examsByModule[null]!,
                          examResults,
                          canRetake,
                        ),

                      // الوحدات مع دروسها وامتحاناتها
                      ...moduleMap.entries.map((entry) {
                        final moduleData = entry.value.first['modules'];
                        final moduleId = moduleData['id'] as String;
                        final moduleTitle = moduleData['title'] as String;
                        final lessons = entry.value;
                        final moduleExams = examsByModule[moduleId] ?? [];

                        return _buildModuleSection(
                          context,
                          moduleTitle: moduleTitle,
                          lessons: lessons,
                          exams: moduleExams,
                          examResults: examResults,
                          canRetake: canRetake,
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupLessonsByModule(
    List<Map<String, dynamic>> lessons,
  ) {
    final moduleMap = <String, List<Map<String, dynamic>>>{};
    for (var lesson in lessons) {
      final moduleTitle = lesson['modules']['title'] as String;
      if (!moduleMap.containsKey(moduleTitle)) {
        moduleMap[moduleTitle] = [];
      }
      moduleMap[moduleTitle]!.add(lesson);
    }
    return moduleMap;
  }

  Widget _buildCourseExamsSection(
    BuildContext context,
    List<dynamic> exams,
    Map<String, dynamic> examResults,
    Map<String, bool> canRetake,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.lg),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusLg),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.quiz,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Text(
                    'امتحانات الكورس',
                    style: AppTextStyles.headlineSmall(context).copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ),
                Text(
                  '${exams.length} امتحان',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),

          // Exams List
          ...exams.asMap().entries.map((entry) {
            final index = entry.key;
            final exam = entry.value;
            final isLast = index == exams.length - 1;

            return _buildExamItem(
              context,
              exam: exam,
              result: examResults[exam.id],
              canRetake: canRetake[exam.id] ?? true,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildModuleSection(
    BuildContext context, {
    required String moduleTitle,
    required List<Map<String, dynamic>> lessons,
    required List<dynamic> exams,
    required Map<String, dynamic> examResults,
    required Map<String, bool> canRetake,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.lg),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Header
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusLg),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.folder_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Text(
                    moduleTitle,
                    style: AppTextStyles.headlineSmall(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  '${lessons.length} دروس',
                  style: AppTextStyles.bodySmall(context),
                ),
                if (exams.isNotEmpty) ...[
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    '• ${exams.length} امتحان',
                    style: AppTextStyles.bodySmall(context),
                  ),
                ],
              ],
            ),
          ),

          // Lessons List
          ...lessons.asMap().entries.map((entry) {
            final index = entry.key;
            final lesson = entry.value;
            final isLast = index == lessons.length - 1 && exams.isEmpty;

            return _buildLessonItem(context, lesson, isLast);
          }),

          // Module Exams
          if (exams.isNotEmpty) ...[
            // Divider
            Container(
              height: 1,
              color: AppColors.light,
              margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            ),

            // Exams Header
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  const Icon(
                    Icons.quiz,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    'امتحانات الوحدة',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Exams List
            ...exams.asMap().entries.map((entry) {
              final index = entry.key;
              final exam = entry.value;
              final isLast = index == exams.length - 1;

              return _buildExamItem(
                context,
                exam: exam,
                result: examResults[exam.id],
                canRetake: canRetake[exam.id] ?? true,
                isLast: isLast,
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonItem(
    BuildContext context,
    Map<String, dynamic> lesson,
    bool isLast,
  ) {
    final progress = lesson['progress'];
    final isCompleted = progress?['is_completed'] ?? false;
    final lessonType = lesson['lesson_type'] as String?;
    final isFree = lesson['is_free'] as bool? ?? false;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonViewerPage(
              lessonId: lesson['id'],
              lessonTitle: lesson['title'],
              lessonType: lessonType ?? 'video',
              videoUrl: lesson['video_url'],
              content: lesson['content'],
              courseId: widget.courseId,
            ),
          ),
        ).then((_) => _loadData());
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: AppColors.light,
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: [
            // Lesson Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.light,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : _getLessonIcon(lessonType),
                color:
                    isCompleted ? AppColors.success : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSizes.md),

            // Lesson Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title'],
                    style: AppTextStyles.bodyLarge(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Row(
                    children: [
                      if (lesson['video_duration'] != null) ...[
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          _formatDuration(lesson['video_duration']),
                          style: AppTextStyles.bodySmall(context),
                        ),
                      ],
                      if (isFree) ...[
                        const SizedBox(width: AppSizes.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSm),
                          ),
                          child: Text(
                            'مجاني',
                            style: AppTextStyles.bodySmall(context).copyWith(
                              color: AppColors.success,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamItem(
    BuildContext context, {
    required dynamic exam,
    dynamic result,
    required bool canRetake,
    required bool isLast,
  }) {
    final hasAttempted = result != null;
    final passed = result?.passed ?? false;

    return InkWell(
      onTap: canRetake
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamPage(examId: exam.id),
                ),
              ).then((_) => _loadData());
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: AppColors.light,
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: [
            // Exam Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasAttempted
                    ? (passed
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1))
                    : AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasAttempted
                    ? (passed ? Icons.check_circle : Icons.cancel)
                    : Icons.quiz,
                color: hasAttempted
                    ? (passed ? AppColors.success : AppColors.error)
                    : AppColors.warning,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSizes.md),

            // Exam Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.title,
                    style: AppTextStyles.bodyLarge(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.xs),
                      Text(
                        '${exam.durationMinutes} دقيقة',
                        style: AppTextStyles.bodySmall(context),
                      ),
                      const SizedBox(width: AppSizes.md),
                      if (hasAttempted)
                        Text(
                          passed ? 'ناجح' : 'راسب',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: passed ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: canRetake
                  ? AppColors.textLight
                  : AppColors.textLight.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'حدث خطأ',
              style: AppTextStyles.headlineSmall(context),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              message,
              style: AppTextStyles.bodyMedium(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.lg),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.school_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'لا يوجد محتوى متاح',
            style: AppTextStyles.bodyLarge(context),
          ),
        ],
      ),
    );
  }

  IconData _getLessonIcon(String? type) {
    switch (type) {
      case 'video':
        return Icons.play_circle_outline;
      case 'text':
        return Icons.article_outlined;
      case 'file':
        return Icons.file_download_outlined;
      case 'quiz':
        return Icons.quiz_outlined;
      default:
        return Icons.school_outlined;
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}
