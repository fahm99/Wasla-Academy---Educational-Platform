import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/views/exam_screen.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الامتحانات',
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthSuccess) {
            return BlocBuilder<CourseBloc, CourseState>(
              builder: (context, courseState) {
                if (courseState is CourseLoaded) {
                  // Get user's exams
                  final userExams = authState.user.exams;

                  if (userExams.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: userExams.length,
                    itemBuilder: (context, index) {
                      final userExam = userExams[index];
                      // Find the course for this exam
                      final course = courseState.courses.firstWhere(
                        (c) => c.id == userExam.courseId,
                        orElse: () => courseState.courses.first,
                      );

                      return _buildExamItem(userExam, course);
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            'لا توجد امتحانات متاحة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'سجل في الكورسات لعرض الامتحانات المتاحة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to home screen
              // This would typically be handled by the bottom navigation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('تصفح الكورسات'),
          ),
        ],
      ),
    );
  }

  Widget _buildExamItem(dynamic userExam, Course course) {
    // Determine exam status
    bool isCompleted = userExam.status == 'completed';
    String statusText = isCompleted ? 'مكتمل' : 'غير مكتمل';
    Color statusColor = isCompleted ? AppColors.success : AppColors.warning;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userExam.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userExam.date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.pending,
                    size: 16,
                    color: statusColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 14,
                    ),
                  ),
                  if (isCompleted) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(${userExam.score}%)',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (isCompleted) {
                  // TODO: Show exam results
                  _showExamResults(userExam);
                } else {
                  // TODO: Start exam
                  _startExam(userExam);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                isCompleted ? 'عرض النتيجة' : 'بدء الامتحان',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExamResults(dynamic userExam) {
    // Show a dialog with exam results
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('نتائج الامتحان'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('العنوان: ${userExam.title}'),
              const SizedBox(height: 8),
              Text('التاريخ: ${userExam.date}'),
              const SizedBox(height: 8),
              Text('النتيجة: ${userExam.score}%'),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: userExam.score / 100,
                backgroundColor: AppColors.light,
                color:
                    userExam.score >= 50 ? AppColors.success : AppColors.danger,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  void _startExam(dynamic userExam) {
    // Find the course for this exam
    final courseState = context.read<CourseBloc>().state;
    if (courseState is CourseLoaded) {
      final course = courseState.courses.firstWhere(
        (c) => c.id == userExam.courseId,
        orElse: () => courseState.courses.first,
      );

      // Find the exam
      final exam = course.exams.firstWhere(
        (e) => e.id == userExam.examId,
        orElse: () => course.exams.first,
      );

      // Navigate to exam screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamScreen(
            courseId: course.id,
            exam: exam,
          ),
        ),
      );
    }
  }
}
