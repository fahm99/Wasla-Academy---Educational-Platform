import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/data/exam_questions.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/models/exam_question.dart';
import 'package:waslaacademy/src/views/course_completion_screen.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class ExamScreen extends StatefulWidget {
  final Course course;
  final Exam exam;

  const ExamScreen({
    super.key,
    required this.course,
    required this.exam,
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int _currentQuestionIndex = 0;
  List<int?> _userAnswers = [];
  int _timeRemaining = 0; // in seconds
  late Timer _timer;
  bool _examSubmitted = false;
  List<ExamQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    // Load questions for this exam
    _questions = ExamQuestionsData.examQuestions[widget.exam.id] ?? [];

    // Initialize user answers list
    _userAnswers = List<int?>.filled(_questions.length, null);

    // Set exam time (assuming 1 minute per question)
    _timeRemaining = _questions.length * 60;

    // Start timer
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          // Time is up, auto submit exam
          _submitExam();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = optionIndex;
    });
  }

  void _navigateToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
    });
  }

  void _submitExam() {
    _timer.cancel();
    _examSubmitted = true;

    // Calculate score
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].correctAnswer) {
        correctAnswers++;
      }
    }

    int score = ((_questions.isNotEmpty)
            ? (correctAnswers / _questions.length) * 100
            : 0)
        .toInt();

    // Show result
    _showExamResult(score);
  }

  void _showExamResult(int score) {
    bool passed = score >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            passed ? 'مبروك! اجتزت الامتحان' : 'لم تنجح في الامتحان',
            style: TextStyle(
              color: passed ? AppColors.success : AppColors.danger,
            ),
          ),
          content: LayoutBuilder(builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'النتيجة: $score%',
                  style: TextStyle(
                    fontSize: isTablet ? 20.sp : 16.sp,
                  ),
                ),
                SizedBox(height: isTablet ? 20.h : 16.h),
                LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: AppColors.light,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    passed ? AppColors.success : AppColors.danger,
                  ),
                ),
                SizedBox(height: isTablet ? 20.h : 16.h),
                Text(
                  passed
                      ? 'لقد اجتزت الامتحان بنجاح!'
                      : 'يرجى إعادة الدراسة والمحاولة مرة أخرى',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 18.sp : 14.sp,
                  ),
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (passed) {
                  // Check if course is completed
                  _checkCourseCompletion();
                }
              },
              child: Text(
                passed ? 'متابعة' : 'إغلاق',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _checkCourseCompletion() {
    // In a real app, this would check if all lessons and exams are completed
    // For demo, we'll just navigate to course completion screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CourseCompletionScreen(
          courseName: widget.course.title,
          studentName: 'أحمد محمد', // This should come from user data
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.exam.title,
          onBack: () => Navigator.pop(context),
        ),
        body: const Center(
          child: Text('لا توجد أسئلة متاحة لهذا الامتحان'),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.exam.title,
        onBack: () {
          // Confirm before exiting
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('تأكيد الخروج'),
                content:
                    const Text('هل أنت متأكد أنك تريد الخروج من الامتحان؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('خروج'),
                  ),
                ],
              );
            },
          );
        },
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Column(
          children: [
            // Exam header with timer
            Container(
              padding: EdgeInsets.all(isTablet ? 20.w : 16.w),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'السؤال ${_currentQuestionIndex + 1} من ${_questions.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18.sp : 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16.w : 12.w,
                      vertical: isTablet ? 8.h : 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      _formatTime(_timeRemaining),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: isTablet ? 18.sp : 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: AppColors.light,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            // Question content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentQuestion.text,
                      style: TextStyle(
                        fontSize: isTablet ? 22.sp : 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 32.h : 24.h),
                    // Answer options
                    ...currentQuestion.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isSelected =
                          _userAnswers[_currentQuestionIndex] == index;
                      return Container(
                        margin: EdgeInsets.only(bottom: isTablet ? 16.h : 12.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: RadioListTile<int>(
                          title: Text(
                            option,
                            style: TextStyle(
                              fontSize: isTablet ? 18.sp : 16.sp,
                            ),
                          ),
                          value: index,
                          groupValue: _userAnswers[_currentQuestionIndex],
                          onChanged: (value) {
                            _selectAnswer(value!);
                          },
                          activeColor: AppColors.primary,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            // Navigation buttons
            Container(
              padding: EdgeInsets.all(isTablet ? 20.w : 16.w),
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0) ...[
                    ElevatedButton(
                      onPressed: () {
                        _navigateToQuestion(_currentQuestionIndex - 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 24.w : 16.w,
                          vertical: isTablet ? 16.h : 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'السابق',
                        style: TextStyle(
                          fontSize: isTablet ? 18.sp : 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (_currentQuestionIndex < _questions.length - 1) ...[
                    ElevatedButton(
                      onPressed: () {
                        _navigateToQuestion(_currentQuestionIndex + 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 24.w : 16.w,
                          vertical: isTablet ? 16.h : 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'التالي',
                        style: TextStyle(
                          fontSize: isTablet ? 18.sp : 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        // Confirm before submitting
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('تأكيد الإرسال'),
                              content: const Text(
                                  'هل أنت متأكد أنك تريد إرسال الإجابات؟'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _submitExam();
                                  },
                                  child: const Text('إرسال'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 24.w : 16.w,
                          vertical: isTablet ? 16.h : 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'إرسال الإجابات',
                        style: TextStyle(
                          fontSize: isTablet ? 18.sp : 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
