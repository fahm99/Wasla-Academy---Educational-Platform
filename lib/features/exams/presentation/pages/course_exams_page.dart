import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/exams_bloc.dart';
import 'exam_page.dart';

/// صفحة قائمة امتحانات الكورس
class CourseExamsPage extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CourseExamsPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseExamsPage> createState() => _CourseExamsPageState();
}

class _CourseExamsPageState extends State<CourseExamsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExams();
    });
  }

  void _loadExams() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
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
          'امتحانات ${widget.courseTitle}',
          style: AppTextStyles.headlineMedium(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocBuilder<ExamsBloc, ExamsState>(
        builder: (context, state) {
          if (state is ExamsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ExamsError) {
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
                      onPressed: _loadExams,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CourseExamsLoaded) {
            if (state.exams.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.quiz_outlined,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'لا توجد امتحانات متاحة',
                      style: AppTextStyles.bodyLarge(context),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadExams(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSizes.lg),
                itemCount: state.exams.length,
                itemBuilder: (context, index) {
                  final exam = state.exams[index];
                  final result = state.results[exam.id];
                  final canRetake = state.canRetake[exam.id] ?? true;

                  return _buildExamCard(
                    context,
                    exam: exam,
                    result: result,
                    canRetake: canRetake,
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildExamCard(
    BuildContext context, {
    required dynamic exam,
    dynamic result,
    required bool canRetake,
  }) {
    final hasAttempted = result != null;
    final passed = result?.passed ?? false;

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
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: hasAttempted
                        ? (passed
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1))
                        : AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasAttempted
                        ? (passed ? Icons.check_circle : Icons.cancel)
                        : Icons.quiz,
                    color: hasAttempted
                        ? (passed ? AppColors.success : AppColors.error)
                        : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: AppTextStyles.headlineSmall(context),
                      ),
                      if (hasAttempted) ...[
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          passed ? 'ناجح' : 'راسب',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: passed ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            if (exam.description != null) ...[
              const SizedBox(height: AppSizes.md),
              Text(
                exam.description!,
                style: AppTextStyles.bodyMedium(context),
              ),
            ],

            const SizedBox(height: AppSizes.md),

            // Info Chips
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: [
                _buildInfoChip(
                  context,
                  icon: Icons.quiz,
                  label: '${exam.totalQuestions} سؤال',
                ),
                _buildInfoChip(
                  context,
                  icon: Icons.timer,
                  label: '${exam.durationMinutes} دقيقة',
                ),
                _buildInfoChip(
                  context,
                  icon: Icons.check_circle,
                  label: 'درجة النجاح: ${exam.passingScore}%',
                ),
                if (exam.allowRetake)
                  _buildInfoChip(
                    context,
                    icon: Icons.refresh,
                    label: 'محاولات: ${exam.maxAttempts}',
                  ),
              ],
            ),

            if (hasAttempted) ...[
              const SizedBox(height: AppSizes.md),
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'النتيجة',
                          style: AppTextStyles.bodySmall(context),
                        ),
                        Text(
                          '${result.score}/${result.totalScore}',
                          style: AppTextStyles.headlineSmall(context),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'النسبة المئوية',
                          style: AppTextStyles.bodySmall(context),
                        ),
                        Text(
                          '${result.percentage.toStringAsFixed(1)}%',
                          style: AppTextStyles.headlineSmall(context).copyWith(
                            color: passed ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSizes.md),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canRetake
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamPage(examId: exam.id),
                          ),
                        ).then((_) => _loadExams());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasAttempted
                      ? (passed ? AppColors.success : AppColors.warning)
                      : AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.md,
                  ),
                ),
                child: Text(
                  hasAttempted
                      ? (canRetake ? 'إعادة المحاولة' : 'استنفذت المحاولات')
                      : 'بدء الامتحان',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSizes.xs),
          Text(
            label,
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }
}
