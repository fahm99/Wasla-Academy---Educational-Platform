import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/course_model.dart';
import '../repositories/courses_repository.dart';

/// معاملات البحث
class SearchCoursesParams {
  final String? query;
  final String? category;
  final String? level;

  SearchCoursesParams({
    this.query,
    this.category,
    this.level,
  });
}

/// حالة استخدام: البحث عن كورسات
class SearchCoursesUseCase {
  final CoursesRepository repository;

  SearchCoursesUseCase(this.repository);

  Future<Either<Failure, List<CourseModel>>> call(
    SearchCoursesParams params,
  ) async {
    return await repository.searchCourses(
      query: params.query,
      category: params.category,
      level: params.level,
    );
  }
}
