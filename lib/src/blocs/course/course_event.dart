part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

class LoadCourses extends CourseEvent {}

class EnrollCourse extends CourseEvent {
  final int courseId;

  const EnrollCourse({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class LoadUserCourses extends CourseEvent {
  final User user;

  const LoadUserCourses({required this.user});

  @override
  List<Object> get props => [user];
}
