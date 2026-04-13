import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/learning_bloc.dart';
import 'lesson_viewer_page.dart';

/// صفحة محتوى الكورس (الدروس)
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLessons();
    });
  }

  void _loadLessons() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<LearningBloc>().add(
            LoadCourseLessonsEvent(
              studentId: authState.user.id,
              courseId: widget.courseId,
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
        builder: (context, state) {
          if (state is LearningLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LearningError) {
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
                      state.message,
                      style: AppTextStyles.bodyMedium(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    ElevatedButton.icon(
                      onPressed: _loadLessons,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CourseLessonsLoaded) {
            if (state.lessons.isEmpty) {
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
                      'لا توجد دروس متاحة',
                      style: AppTextStyles.bodyLarge(context),
                    ),
                  ],
                ),
              );
            }

            // تجميع الدروس حسب الوحدات
            final moduleMap = <String, List<Map<String, dynamic>>>{};
            for (var lesson in state.lessons) {
              final moduleTitle = lesson['modules']['title'] as String;
              if (!moduleMap.containsKey(moduleTitle)) {
                moduleMap[moduleTitle] = [];
              }
              moduleMap[moduleTitle]!.add(lesson);
            }

            return RefreshIndicator(
              onRefresh: () async => _loadLessons(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSizes.lg),
                itemCount: moduleMap.length,
                itemBuilder: (context, index) {
                  final moduleTitle = moduleMap.keys.elementAt(index);
                  final lessons = moduleMap[moduleTitle]!;

                  return _buildModuleSection(context, moduleTitle, lessons);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildModuleSection(
    BuildContext context,
    String moduleTitle,
    List<Map<String, dynamic>> lessons,
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
              ],
            ),
          ),

          // Lessons List
          ...lessons.asMap().entries.map((entry) {
            final index = entry.key;
            final lesson = entry.value;
            final isLast = index == lessons.length - 1;

            return _buildLessonItem(context, lesson, isLast);
          }),
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
        ).then((_) => _loadLessons());
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
