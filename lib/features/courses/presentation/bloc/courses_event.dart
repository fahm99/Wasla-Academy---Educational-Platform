import 'package:equatable/equatable.dart';

/// أحداث الكورسات
abstract class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل جميع الكورسات
class LoadAllCoursesEvent extends CoursesEvent {}

/// البحث عن كورسات
class SearchCoursesEvent extends CoursesEvent {
  final String? query;
  final String? category;
  final String? level;

  const SearchCoursesEvent({
    this.query,
    this.category,
    this.level,
  });

  @override
  List<Object?> get props => [query, category, level];
}

/// تحميل تفاصيل كورس
class LoadCourseDetailsEvent extends CoursesEvent {
  final String courseId;

  const LoadCourseDetailsEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// تحميل وحدات الكورس
class LoadCourseModulesEvent extends CoursesEvent {
  final String courseId;

  const LoadCourseModulesEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// تحميل دروس الوحدة
class LoadModuleLessonsEvent extends CoursesEvent {
  final String moduleId;

  const LoadModuleLessonsEvent(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}

/// التسجيل في كورس
class EnrollInCourseEvent extends CoursesEvent {
  final String courseId;

  const EnrollInCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

/// تحميل تسجيلاتي
class LoadMyEnrollmentsEvent extends CoursesEvent {}

/// إعادة تعيين الحالة
class ResetCoursesStateEvent extends CoursesEvent {}
