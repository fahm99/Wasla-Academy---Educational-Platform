import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/exam_question.dart';
import '../bloc/exams_bloc.dart';
import 'exam_result_page.dart';

/// صفحة الامتحان
class ExamPage extends StatefulWidget {
  final String examId;

  const ExamPage({
    super.key,
    required this.examId,
  });

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final Map<String, String> _answers = {};
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExam();
    });
  }

  void _loadExam() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ExamsBloc>().add(
            LoadExamWithQuestionsEvent(
              examId: widget.examId,
              studentId: authState.user.id,
            ),
          );
    }
  }

  void _startTimer(int durationMinutes) {
    _remainingSeconds = durationMinutes * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitExam();
      }
    });
  }

  void _submitExam() {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    _timer?.cancel();

    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ExamsBloc>().add(
            SubmitExamAnswersEvent(
              examId: widget.examId,
              studentId: authState.user.id,
              answers: _answers,
            ),
          );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'تحذير',
              style: AppTextStyles.headlineSmall(context),
            ),
            content: Text(
              'هل أنت متأكد من الخروج؟ سيتم فقدان إجاباتك.',
              style: AppTextStyles.bodyLarge(context),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('خروج'),
              ),
            ],
          ),
        );

        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.light,
        appBar: AppBar(
          title: Text(
            'الامتحان',
            style: AppTextStyles.headlineMedium(context),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            if (_remainingSeconds > 0)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: AppSizes.lg),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: _remainingSeconds < 300
                        ? AppColors.error.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: _remainingSeconds < 300
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                      const SizedBox(width: AppSizes.xs),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: _remainingSeconds < 300
                              ? AppColors.error
                              : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        body: BlocConsumer<ExamsBloc, ExamsState>(
          listener: (context, state) {
            if (state is ExamSubmitted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamResultPage(result: state.result),
                ),
              );
            }
          },
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
                        onPressed: _loadExam,
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ExamWithQuestionsLoaded) {
              if (!state.canRetake) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.block,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSizes.md),
                        Text(
                          'لا يمكن إعادة الامتحان',
                          style: AppTextStyles.headlineSmall(context),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          'لقد استنفذت جميع المحاولات المتاحة',
                          style: AppTextStyles.bodyMedium(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.lg),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('العودة'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (_timer == null) {
                _startTimer(state.exam.durationMinutes);
              }

              return Column(
                children: [
                  // Exam Info
                  Container(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.exam.title,
                          style: AppTextStyles.headlineSmall(context),
                        ),
                        if (state.exam.description != null) ...[
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            state.exam.description!,
                            style: AppTextStyles.bodyMedium(context),
                          ),
                        ],
                        const SizedBox(height: AppSizes.md),
                        Row(
                          children: [
                            _buildInfoChip(
                              context,
                              icon: Icons.quiz,
                              label: '${state.questions.length} سؤال',
                            ),
                            const SizedBox(width: AppSizes.md),
                            _buildInfoChip(
                              context,
                              icon: Icons.check_circle,
                              label: 'درجة النجاح: ${state.exam.passingScore}%',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Questions List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      itemCount: state.questions.length,
                      itemBuilder: (context, index) {
                        final question = state.questions[index];
                        return _buildQuestionCard(context, question, index + 1);
                      },
                    ),
                  ),

                  // Submit Button
                  Container(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    color: Colors.white,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitExam,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.lg,
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('إرسال الإجابات'),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
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

  Widget _buildQuestionCard(
    BuildContext context,
    ExamQuestion question,
    int number,
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
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: AppTextStyles.bodyLarge(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            if (question.questionType == 'multiple_choice' &&
                question.options != null)
              ...question.options!.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final optionLetter = String.fromCharCode(65 + index);

                return RadioListTile<String>(
                  title: Text(
                    '$optionLetter. $option',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  value: option,
                  groupValue: _answers[question.id],
                  onChanged: (value) {
                    setState(() {
                      _answers[question.id] = value!;
                    });
                  },
                  activeColor: AppColors.primary,
                );
              }),
            if (question.questionType == 'true_false')
              Column(
                children: [
                  RadioListTile<String>(
                    title: Text(
                      'صح',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    value: 'true',
                    groupValue: _answers[question.id],
                    onChanged: (value) {
                      setState(() {
                        _answers[question.id] = value!;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'خطأ',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    value: 'false',
                    groupValue: _answers[question.id],
                    onChanged: (value) {
                      setState(() {
                        _answers[question.id] = value!;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            if (question.questionType == 'short_answer')
              TextField(
                decoration: const InputDecoration(
                  hintText: 'اكتب إجابتك هنا...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  _answers[question.id] = value;
                },
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
