import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_courses_usecase.dart';
import '../../domain/usecases/search_courses_usecase.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import '../../domain/usecases/get_course_modules_usecase.dart';
import '../../domain/usecases/get_module_lessons_usecase.dart';
import '../../domain/usecases/enroll_in_course_usecase.dart';
import '../../domain/usecases/get_my_enrollments_usecase.dart';
import 'courses_event.dart';
import 'courses_state.dart';

/// Bloc للكورسات
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetAllCoursesUseCase getAllCoursesUseCase;
  final SearchCoursesUseCase searchCoursesUseCase;
  final GetCourseDetailsUseCase getCourseDetailsUseCase;
  final GetCourseModulesUseCase getCourseModulesUseCase;
  final GetModuleLessonsUseCase getModuleLessonsUseCase;
  final EnrollInCourseUseCase enrollInCourseUseCase;
  final GetMyEnrollmentsUseCase getMyEnrollmentsUseCase;

  CoursesBloc({
    required this.getAllCoursesUseCase,
    required this.searchCoursesUseCase,
    required this.getCourseDetailsUseCase,
    required this.getCourseModulesUseCase,
    required this.getModuleLessonsUseCase,
    required this.enrollInCourseUseCase,
    required this.getMyEnrollmentsUseCase,
  }) : super(CoursesInitial()) {
    on<LoadAllCoursesEvent>(_onLoadAllCourses);
    on<SearchCoursesEvent>(_onSearchCourses);
    on<LoadCourseDetailsEvent>(_onLoadCourseDetails);
    on<LoadCourseModulesEvent>(_onLoadCourseModules);
    on<LoadModuleLessonsEvent>(_onLoadModuleLessons);
    on<EnrollInCourseEvent>(_onEnrollInCourse);
    on<LoadMyEnrollmentsEvent>(_onLoadMyEnrollments);
    on<ResetCoursesStateEvent>(_onResetState);
  }

  Future<void> _onLoadAllCourses(
    LoadAllCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());

    final result = await getAllCoursesUseCase();

    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }

  Future<void> _onSearchCourses(
    SearchCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());

    final params = SearchCoursesParams(
      query: event.query,
      category: event.category,
      level: event.level,
    );

    final result = await searchCoursesUseCase(params);

    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }

  Future<void> _onLoadCourseDetails(
    LoadCourseDetailsEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());

    final result = await getCourseDetailsUseCase(event.courseId);

    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (course) => emit(CourseDetailsLoaded(course)),
    );
  }

  Future<void> _onLoadCourseModules(
    LoadCourseModulesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());

    final result = await getCourseModulesUseCase(event.courseId);

    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (modules) => emit(CourseModulesLoaded(modules)),
    );
  }

  Future<void> _onLoadModuleLessons(
    LoadModuleLessonsEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());

    final result = await getModuleLessonsUseCase(event.moduleId);

    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (lessons) => emit(ModuleLessonsLoaded(lessons)),
    );
  }

  Future<void> _onEnrollInCourse(
    EnrollInCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());

    final result = await enrollInCourseUseCase(event.courseId);

    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (enrollment) => emit(EnrollmentSuccess(enrollment)),
    );
  }

  Future<void> _onLoadMyEnrollments(
    LoadMyEnrollmentsEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());

    final result = await getMyEnrollmentsUseCase();

    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (enrollments) => emit(EnrollmentsLoaded(enrollments)),
    );
  }

  void _onResetState(
    ResetCoursesStateEvent event,
    Emitter<CoursesState> emit,
  ) {
    emit(CoursesInitial());
  }
}
