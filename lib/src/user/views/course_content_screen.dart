import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/user/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/user/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/models/course.dart';
import 'package:waslaacademy/src/user/views/course_player_screen.dart';
import 'package:waslaacademy/src/user/views/exam_screen.dart';
import 'package:waslaacademy/src/user/widgets/custom_app_bar.dart';

class CourseContentScreen extends StatefulWidget {
  final int courseId;

  const CourseContentScreen({super.key, required this.courseId});

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  Course? _course;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  void _loadCourse() {
    final courseState = context.read<CourseBloc>().state;
    if (courseState is CourseLoaded) {
      setState(() {
        _course = courseState.courses.firstWhere(
          (course) => course.id == widget.courseId,
          orElse: () => courseState.courses.first,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_course == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'محتوى الكورس',
          onBack: () => Navigator.pop(context),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'محتوى الكورس',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Course header with progress
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _course!.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _course!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _course!.instructor,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Progress bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _calculateProgress(),
                                backgroundColor: Colors.white30,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(_calculateProgress() * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lessons section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'الدروس',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Lessons list
          Expanded(
            child: ListView.builder(
              itemCount: _course!.lessons.length,
              itemBuilder: (context, index) {
                final lesson = _course!.lessons[index];
                final isCompleted = lesson.completed;
                // Check if lesson is unlocked
                final isUnlocked = index == 0 ||
                    (index > 0 && _course!.lessons[index - 1].completed);

                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.success
                          : (isUnlocked ? AppColors.primary : Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      lesson.type == 'video'
                          ? Icons.play_circle
                          : Icons.assignment,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${index + 1}. ${lesson.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isUnlocked ? Colors.black : Colors.grey,
                    ),
                  ),
                  subtitle: Text(
                    lesson.duration,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUnlocked ? Colors.grey : Colors.grey[400],
                    ),
                  ),
                  trailing: isCompleted
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                        )
                      : null,
                  enabled: isUnlocked,
                  onTap: isUnlocked
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoursePlayerScreen(
                                courseId: _course!.id,
                                initialLessonIndex: index,
                              ),
                            ),
                          ).then((_) {
                            // Refresh course data after returning from player
                            _loadCourse();
                          });
                        }
                      : null,
                );
              },
            ),
          ),

          // Exams section
          if (_course!.exams.isNotEmpty) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'الامتحانات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ..._course!.exams.map((exam) {
              // Unlock exam only if all lessons are completed
              final isUnlocked = _areAllLessonsCompleted() || !exam.locked;

              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isUnlocked ? AppColors.warning : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    isUnlocked ? Icons.quiz : Icons.lock,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  exam.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isUnlocked ? Colors.black : Colors.grey,
                  ),
                ),
                subtitle: Text(
                  '${exam.questions} أسئلة • ${exam.duration}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isUnlocked ? Colors.grey : Colors.grey[400],
                  ),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUnlocked ? AppColors.warning : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isUnlocked ? 'متاح' : 'مقفل',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                enabled: isUnlocked,
                onTap: isUnlocked
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamScreen(
                              courseId: _course!.id,
                              exam: exam,
                            ),
                          ),
                        ).then((_) {
                          // Refresh course data after returning from exam
                          _loadCourse();
                        });
                      }
                    : null,
              );
            }),
          ],
        ],
      ),
    );
  }

  // Helper method to calculate progress
  double _calculateProgress() {
    if (_course == null || _course!.lessons.isEmpty) return 0.0;

    int completedLessons =
        _course!.lessons.where((lesson) => lesson.completed).length;
    return completedLessons / _course!.lessons.length;
  }

  // Check if all lessons are completed
  bool _areAllLessonsCompleted() {
    if (_course == null || _course!.lessons.isEmpty) return false;
    return _course!.lessons.every((lesson) => lesson.completed);
  }
}
