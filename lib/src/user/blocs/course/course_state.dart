part of 'course_bloc.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<Course> courses;

  const CourseLoaded({required this.courses});

  @override
  List<Object> get props => [courses];
}

class UserCoursesLoaded extends CourseState {
  final List<Course> courses;

  const UserCoursesLoaded({required this.courses});

  @override
  List<Object> get props => [courses];
}

class CourseEnrolled extends CourseState {
  final int courseId;

  const CourseEnrolled({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class CourseCompleted extends CourseState {
  final int courseId;

  const CourseCompleted({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class CourseError extends CourseState {
  final String message;

  const CourseError({required this.message});

  @override
  List<Object> get props => [message];
}
