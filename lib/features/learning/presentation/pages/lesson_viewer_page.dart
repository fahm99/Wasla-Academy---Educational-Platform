import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/video_player_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/learning_bloc.dart';

/// صفحة عرض الدرس
class LessonViewerPage extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final String lessonType;
  final String? videoUrl;
  final String? content;
  final String courseId;

  const LessonViewerPage({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonType,
    this.videoUrl,
    this.content,
    required this.courseId,
  });

  @override
  State<LessonViewerPage> createState() => _LessonViewerPageState();
}

class _LessonViewerPageState extends State<LessonViewerPage> {
  bool _isCompleted = false;
  int _watchedDuration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProgress();
    });
  }

  void _loadProgress() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<LearningBloc>().add(
            LoadLessonProgressEvent(
              studentId: authState.user.id,
              lessonId: widget.lessonId,
            ),
          );
    }
  }

  void _markAsCompleted() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<LearningBloc>().add(
            UpdateLessonProgressEvent(
              studentId: authState.user.id,
              lessonId: widget.lessonId,
              watchedDuration: _watchedDuration,
              isCompleted: true,
            ),
          );

      setState(() {
        _isCompleted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديد الدرس كمكتمل'),
          backgroundColor: AppColors.success,
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
          widget.lessonTitle,
          style: AppTextStyles.headlineMedium(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocListener<LearningBloc, LearningState>(
        listener: (context, state) {
          if (state is LessonProgressLoaded && state.progress != null) {
            setState(() {
              _isCompleted = state.progress!.isCompleted;
              _watchedDuration = state.progress!.watchedDuration;
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player or Content Area
              if (widget.lessonType == 'video' && widget.videoUrl != null)
                _buildVideoPlayer()
              else if (widget.lessonType == 'text')
                _buildTextContent()
              else
                _buildPlaceholder(),

              // Lesson Details
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.lessonTitle,
                            style: AppTextStyles.headlineSmall(context),
                          ),
                        ),
                        if (_isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: AppSizes.xs),
                                Text(
                                  'مكتمل',
                                  style:
                                      AppTextStyles.bodySmall(context).copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (widget.content != null) ...[
                      const SizedBox(height: AppSizes.lg),
                      Text(
                        widget.content!,
                        style: AppTextStyles.bodyLarge(context),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.md),

              // Mark as Complete Button
              if (!_isCompleted)
                Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _markAsCompleted,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('تحديد كمكتمل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.lg,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return SimpleVideoPlayer(
      videoUrl: widget.videoUrl,
      title: widget.lessonTitle,
      autoPlay: false,
      onVideoCompleted: () {
        // Auto mark as completed when video finishes
        if (!_isCompleted) {
          _markAsCompleted();
        }
      },
      onPositionChanged: (position) {
        // Update watched duration
        setState(() {
          _watchedDuration = position.inSeconds;
        });
      },
    );
  }

  Widget _buildTextContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.xl),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.article_outlined,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSizes.lg),
          if (widget.content != null)
            Text(
              widget.content!,
              style: AppTextStyles.bodyLarge(context),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 250,
      color: AppColors.light,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getLessonIcon(widget.lessonType),
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'محتوى الدرس',
            style: AppTextStyles.bodyLarge(context),
          ),
        ],
      ),
    );
  }

  IconData _getLessonIcon(String type) {
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
}
