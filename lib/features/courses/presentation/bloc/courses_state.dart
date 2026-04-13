import 'package:equatable/equatable.dart';
import '../../data/models/course_model.dart';
import '../../data/models/module_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/enrollment_model.dart';

/// حالات الكورسات
abstract class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class CoursesInitial extends CoursesState {}

/// جاري التحميل
class CoursesLoading extends CoursesState {}

/// تم تحميل الكورسات
class CoursesLoaded extends CoursesState {
  final List<CourseModel> courses;

  const CoursesLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

/// تم تحميل تفاصيل الكورس
class CourseDetailsLoaded extends CoursesState {
  final CourseModel course;

  const CourseDetailsLoaded(this.course);

  @override
  List<Object> get props => [course];
}

/// تم تحميل وحدات الكورس
class CourseModulesLoaded extends CoursesState {
  final List<ModuleModel> modules;

  const CourseModulesLoaded(this.modules);

  @override
  List<Object> get props => [modules];
}

/// تم تحميل دروس الوحدة
class ModuleLessonsLoaded extends CoursesState {
  final List<LessonModel> lessons;

  const ModuleLessonsLoaded(this.lessons);

  @override
  List<Object> get props => [lessons];
}

/// تم التسجيل في الكورس
class EnrollmentSuccess extends CoursesState {
  final EnrollmentModel enrollment;

  const EnrollmentSuccess(this.enrollment);

  @override
  List<Object> get props => [enrollment];
}

/// تم تحميل التسجيلات
class EnrollmentsLoaded extends CoursesState {
  final List<EnrollmentModel> enrollments;

  const EnrollmentsLoaded(this.enrollments);

  @override
  List<Object> get props => [enrollments];
}

/// خطأ
class CoursesError extends CoursesState {
  final String message;

  const CoursesError(this.message);

  @override
  List<Object> get props => [message];
}
