import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/user/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/user/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/models/course.dart';
import 'package:waslaacademy/src/user/models/user.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';

class ExamScreen extends StatefulWidget {
  final Exam exam;
  final int courseId;

  const ExamScreen({
    super.key,
    required this.exam,
    required this.courseId,
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  bool _isExamStarted = false;
  bool _isExamCompleted = false;
  late AnimationController _timerController;
  Duration _remainingTime = Duration.zero;

  // Sample questions for demo
  final List<ExamQuestion> _questions = [
    ExamQuestion(
      id: 1,
      question: 'ما هي لغة البرمجة الأكثر شيوعاً في تطوير تطبيقات الويب؟',
      options: ['Python', 'JavaScript', 'Java', 'C++'],
      correctAnswer: 1,
    ),
    ExamQuestion(
      id: 2,
      question: 'أي من التالي يُستخدم لتصميم واجهات المستخدم في Flutter؟',
      options: ['Widgets', 'Components', 'Elements', 'Views'],
      correctAnswer: 0,
    ),
    ExamQuestion(
      id: 3,
      question: 'ما هو الغرض من استخدام Git في البرمجة؟',
      options: [
        'تشغيل التطبيقات',
        'إدارة قواعد البيانات',
        'إدارة الإصدارات',
        'تصميم الواجهات'
      ],
      correctAnswer: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: _parseDuration(widget.exam.duration),
      vsync: this,
    );
    _remainingTime = _parseDuration(widget.exam.duration);
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  Duration _parseDuration(String duration) {
    // Parse duration like "30 دقيقة" to Duration
    final minutes = int.tryParse(duration.split(' ')[0]) ?? 30;
    return Duration(minutes: minutes);
  }

  void _startExam() {
    setState(() {
      _isExamStarted = true;
    });

    _timerController.addListener(() {
      setState(() {
        _remainingTime = Duration(
          seconds: (_parseDuration(widget.exam.duration).inSeconds *
                  (1 - _timerController.value))
              .round(),
        );
      });

      if (_timerController.isCompleted) {
        _completeExam();
      }
    });

    _timerController.forward();
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _completeExam() {
    _timerController.stop();

    // Calculate score
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswer) {
        correctAnswers++;
      }
    }

    final score = ((correctAnswers / _questions.length) * 100).round();

    setState(() {
      _isExamCompleted = true;
    });

    // Show results dialog
    _showResultsDialog(score, correctAnswers);
  }

  void _showResultsDialog(int score, int correctAnswers) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'نتائج الامتحان',
          style: AppTextStyles.headline2(context),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: score >= 60 ? AppColors.success : AppColors.danger,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$score%',
                  style: AppTextStyles.headline1(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            Text(
              score >= 60
                  ? 'مبروك! لقد نجحت في الامتحان'
                  : 'للأسف، لم تحصل على الدرجة المطلوبة',
              style: AppTextStyles.bodyLarge(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            Text(
              'الإجابات الصحيحة: $correctAnswers من ${_questions.length}',
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          if (score < 60)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetExam();
              },
              child: Text(
                'إعادة المحاولة',
                style: AppTextStyles.buttonMedium(context).copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();

              // If passed, complete the course and generate certificate
              if (score >= 60) {
                _completeCourseAndGenerateCertificate(score);
              }

              Navigator.of(context).pop(); // Go back to course player
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              score >= 60 ? 'عرض الشهادة' : 'العودة للكورس',
              style: AppTextStyles.buttonMedium(context),
            ),
          ),
        ],
      ),
    );
  }

  // Complete course and generate certificate when exam is passed
  void _completeCourseAndGenerateCertificate(int score) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      // Update course completion status
      context.read<CourseBloc>().add(CompleteCourse(courseId: widget.courseId));

      // Update user progress
      final user = authState.user;
      final updatedCompletedCourses = List<int>.from(user.completedCourses);
      if (!updatedCompletedCourses.contains(widget.courseId)) {
        updatedCompletedCourses.add(widget.courseId);
      }

      // Remove from enrolled courses
      final updatedEnrolledCourses = List<int>.from(user.enrolledCourses);
      updatedEnrolledCourses.remove(widget.courseId);

      // Create certificate
      final courseState = context.read<CourseBloc>().state;
      String courseName = "كورس غير معروف";
      if (courseState is CourseLoaded) {
        final course = courseState.courses.firstWhere(
          (c) => c.id == widget.courseId,
          orElse: () => courseState.courses.first,
        );
        courseName = course.title;
      }

      final certificate = Certificate(
        id: DateTime.now().millisecondsSinceEpoch,
        courseId: widget.courseId,
        courseName: courseName,
        date: DateTime.now().toString().split('T')[0],
      );

      final updatedCertificates = List<Certificate>.from(user.certificates);
      updatedCertificates.add(certificate);

      context.read<AuthBloc>().add(UpdateUserProgress(
            enrolledCourses: updatedEnrolledCourses,
            completedCourses: updatedCompletedCourses,
            certificates:
                updatedCertificates.isNotEmpty ? updatedCertificates : null,
          ));

      // Show certificate generation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'تهانينا! لقد أكملت الكورس "$courseName" بنجاح وتم إصدار الشهادة'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate to certificates screen
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: {
            'initialTab': 3, // Certificates tab
          },
        );
      });
    }
  }

  // Get grade level based on score
  String _getGradeLevel(int score) {
    if (score >= 90) return 'ممتاز';
    if (score >= 80) return 'جيد جداً';
    if (score >= 70) return 'جيد';
    if (score >= 60) return 'مقبول';
    return 'ضعيف';
  }

  void _resetExam() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswers.clear();
      _isExamStarted = false;
      _isExamCompleted = false;
      _remainingTime = _parseDuration(widget.exam.duration);
    });
    _timerController.reset();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExamStarted) {
      return _buildExamIntro();
    }

    if (_isExamCompleted) {
      return _buildExamCompleted();
    }

    return _buildExamContent();
  }

  Widget _buildExamIntro() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title),
      ),
      body: Padding(
        padding: ResponsiveHelper.getScreenPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            Text(
              widget.exam.title,
              style: AppTextStyles.headline1(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            _buildInfoCard('عدد الأسئلة', '${widget.exam.questions} سؤال'),
            const SizedBox(height: AppSizes.spaceSmall),
            _buildInfoCard('المدة المحددة', widget.exam.duration),
            const SizedBox(height: AppSizes.spaceSmall),
            _buildInfoCard('نوع الامتحان',
                widget.exam.type == 'mcq' ? 'اختيار من متعدد' : 'مقالي'),
            const SizedBox(height: AppSizes.spaceLarge),
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceMedium),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: AppSizes.iconLarge,
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Text(
                    'تعليمات مهمة',
                    style: AppTextStyles.labelLarge(context).copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Text(
                    '• يجب الإجابة على جميع الأسئلة\n• لا يمكن العودة بعد انتهاء الوقت\n• الدرجة المطلوبة للنجاح 60%',
                    style: AppTextStyles.bodyMedium(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startExam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSizes.spaceLarge),
                ),
                child: Text(
                  'بدء الامتحان',
                  style: AppTextStyles.buttonLarge(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.light),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.labelLarge(context),
          ),
        ],
      ),
    );
  }

  Widget _buildExamContent() {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title:
            Text('السؤال ${_currentQuestionIndex + 1} من ${_questions.length}'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMedium,
              vertical: AppSizes.spaceSmall,
            ),
            margin: const EdgeInsets.only(right: AppSizes.spaceMedium),
            decoration: BoxDecoration(
              color: _remainingTime.inMinutes < 5
                  ? AppColors.danger
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              _formatTime(_remainingTime),
              style: AppTextStyles.labelMedium(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: AppColors.light,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),

          Expanded(
            child: Padding(
              padding: ResponsiveHelper.getScreenPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.spaceLarge),

                  // Question
                  Text(
                    currentQuestion.question,
                    style: AppTextStyles.headline2(context),
                  ),

                  const SizedBox(height: AppSizes.spaceLarge),

                  // Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        final isSelected =
                            _selectedAnswers[_currentQuestionIndex] == index;

                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: AppSizes.spaceSmall),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _selectAnswer(index),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMedium),
                              child: Container(
                                padding:
                                    const EdgeInsets.all(AppSizes.spaceMedium),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.radiusMedium),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.light,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textLight,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: AppSizes.spaceMedium),
                                    Expanded(
                                      child: Text(
                                        currentQuestion.options[index],
                                        style: AppTextStyles.bodyLarge(context)
                                            .copyWith(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: ResponsiveHelper.getScreenPadding(context),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spaceMedium),
                      ),
                      child: Text(
                        'السابق',
                        style: AppTextStyles.buttonMedium(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                if (_currentQuestionIndex > 0)
                  const SizedBox(width: AppSizes.spaceMedium),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _selectedAnswers.containsKey(_currentQuestionIndex)
                            ? (_currentQuestionIndex < _questions.length - 1
                                ? _nextQuestion
                                : _completeExam)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spaceMedium),
                    ),
                    child: Text(
                      _currentQuestionIndex < _questions.length - 1
                          ? 'التالي'
                          : 'إنهاء الامتحان',
                      style: AppTextStyles.buttonMedium(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCompleted() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تم إنهاء الامتحان'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ExamQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswer;

  ExamQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}
