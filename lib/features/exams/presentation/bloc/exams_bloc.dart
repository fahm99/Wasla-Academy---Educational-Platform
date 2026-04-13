import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/exam.dart';
import '../../domain/entities/exam_question.dart';
import '../../domain/entities/exam_result.dart';
import '../../domain/usecases/get_course_exams_usecase.dart';
import '../../domain/usecases/get_exam_with_questions_usecase.dart';
import '../../domain/usecases/submit_exam_answers_usecase.dart';
import '../../domain/usecases/get_my_exam_results_usecase.dart';
import '../../domain/usecases/can_retake_exam_usecase.dart';

part 'exams_event.dart';
part 'exams_state.dart';

/// Bloc لإدارة حالة الامتحانات
class ExamsBloc extends Bloc<ExamsEvent, ExamsState> {
  final GetCourseExamsUseCase getCourseExamsUseCase;
  final GetExamWithQuestionsUseCase getExamWithQuestionsUseCase;
  final SubmitExamAnswersUseCase submitExamAnswersUseCase;
  final GetMyExamResultsUseCase getMyExamResultsUseCase;
  final CanRetakeExamUseCase canRetakeExamUseCase;

  ExamsBloc({
    required this.getCourseExamsUseCase,
    required this.getExamWithQuestionsUseCase,
    required this.submitExamAnswersUseCase,
    required this.getMyExamResultsUseCase,
    required this.canRetakeExamUseCase,
  }) : super(ExamsInitial()) {
    on<LoadCourseExamsEvent>(_onLoadCourseExams);
    on<LoadExamWithQuestionsEvent>(_onLoadExamWithQuestions);
    on<SubmitExamAnswersEvent>(_onSubmitExamAnswers);
    on<LoadMyExamResultsEvent>(_onLoadMyExamResults);
  }

  Future<void> _onLoadCourseExams(
    LoadCourseExamsEvent event,
    Emitter<ExamsState> emit,
  ) async {
    emit(ExamsLoading());

    final result = await getCourseExamsUseCase(event.courseId);

    result.fold(
      (failure) => emit(ExamsError(failure.message)),
      (exams) => emit(CourseExamsLoaded(exams)),
    );
  }

  Future<void> _onLoadExamWithQuestions(
    LoadExamWithQuestionsEvent event,
    Emitter<ExamsState> emit,
  ) async {
    emit(ExamsLoading());

    final result = await getExamWithQuestionsUseCase(event.examId);

    await result.fold(
      (failure) async => emit(ExamsError(failure.message)),
      (data) async {
        final exam = data['exam'] as Exam;
        final questions = data['questions'] as List<ExamQuestion>;

        // التحقق من إمكانية إعادة الامتحان
        final canRetakeResult =
            await canRetakeExamUseCase(event.examId, event.studentId);

        canRetakeResult.fold(
          (failure) => emit(ExamsError(failure.message)),
          (canRetake) => emit(ExamWithQuestionsLoaded(
            exam: exam,
            questions: questions,
            canRetake: canRetake,
          )),
        );
      },
    );
  }

  Future<void> _onSubmitExamAnswers(
    SubmitExamAnswersEvent event,
    Emitter<ExamsState> emit,
  ) async {
    emit(ExamsLoading());

    final result = await submitExamAnswersUseCase(
      examId: event.examId,
      studentId: event.studentId,
      answers: event.answers,
    );

    result.fold(
      (failure) => emit(ExamsError(failure.message)),
      (examResult) => emit(ExamSubmitted(examResult)),
    );
  }

  Future<void> _onLoadMyExamResults(
    LoadMyExamResultsEvent event,
    Emitter<ExamsState> emit,
  ) async {
    emit(ExamsLoading());

    final result = await getMyExamResultsUseCase(event.studentId);

    result.fold(
      (failure) => emit(ExamsError(failure.message)),
      (results) => emit(MyExamResultsLoaded(results)),
    );
  }
}
