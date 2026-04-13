import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson_progress.dart';
import '../../domain/entities/enrollment_progress.dart';
import '../../domain/usecases/get_course_lessons_usecase.dart';
import '../../domain/usecases/update_lesson_progress_usecase.dart';
import '../../domain/usecases/get_lesson_progress_usecase.dart';
import '../../domain/usecases/get_enrollment_progress_usecase.dart';

part 'learning_event.dart';
part 'learning_state.dart';

/// Bloc لإدارة حالة التعلم
class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final GetCourseLessonsUseCase getCourseLessonsUseCase;
  final UpdateLessonProgressUseCase updateLessonProgressUseCase;
  final GetLessonProgressUseCase getLessonProgressUseCase;
  final GetEnrollmentProgressUseCase getEnrollmentProgressUseCase;

  LearningBloc({
    required this.getCourseLessonsUseCase,
    required this.updateLessonProgressUseCase,
    required this.getLessonProgressUseCase,
    required this.getEnrollmentProgressUseCase,
  }) : super(LearningInitial()) {
    on<LoadCourseLessonsEvent>(_onLoadCourseLessons);
    on<UpdateLessonProgressEvent>(_onUpdateLessonProgress);
    on<LoadLessonProgressEvent>(_onLoadLessonProgress);
    on<LoadEnrollmentProgressEvent>(_onLoadEnrollmentProgress);
  }

  Future<void> _onLoadCourseLessons(
    LoadCourseLessonsEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoading());

    final result =
        await getCourseLessonsUseCase(event.studentId, event.courseId);

    result.fold(
      (failure) => emit(LearningError(failure.message)),
      (lessons) => emit(CourseLessonsLoaded(lessons)),
    );
  }

  Future<void> _onUpdateLessonProgress(
    UpdateLessonProgressEvent event,
    Emitter<LearningState> emit,
  ) async {
    final result = await updateLessonProgressUseCase(
      studentId: event.studentId,
      lessonId: event.lessonId,
      watchedDuration: event.watchedDuration,
      isCompleted: event.isCompleted,
    );

    result.fold(
      (failure) => emit(LearningError(failure.message)),
      (progress) => emit(LessonProgressUpdated(progress)),
    );
  }

  Future<void> _onLoadLessonProgress(
    LoadLessonProgressEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoading());

    final result =
        await getLessonProgressUseCase(event.studentId, event.lessonId);

    result.fold(
      (failure) => emit(LearningError(failure.message)),
      (progress) => emit(LessonProgressLoaded(progress)),
    );
  }

  Future<void> _onLoadEnrollmentProgress(
    LoadEnrollmentProgressEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoading());

    final result =
        await getEnrollmentProgressUseCase(event.studentId, event.courseId);

    result.fold(
      (failure) => emit(LearningError(failure.message)),
      (progress) => emit(EnrollmentProgressLoaded(progress)),
    );
  }
}
