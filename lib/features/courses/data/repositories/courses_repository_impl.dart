import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/courses_repository.dart';
import '../datasources/courses_remote_datasource.dart';
import '../models/course_model.dart';
import '../models/module_model.dart';
import '../models/lesson_model.dart';
import '../models/enrollment_model.dart';

/// تنفيذ مستودع الكورسات
class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesRemoteDataSource remoteDataSource;

  CoursesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CourseModel>>> getAllCourses() async {
    try {
      final courses = await remoteDataSource.getAllCourses();
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CourseModel>>> searchCourses({
    String? query,
    String? category,
    String? level,
  }) async {
    try {
      final courses = await remoteDataSource.searchCourses(
        query: query,
        category: category,
        level: level,
      );
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseModel>> getCourseById(String id) async {
    try {
      final course = await remoteDataSource.getCourseById(id);
      return Right(course);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ModuleModel>>> getCourseModules(
    String courseId,
  ) async {
    try {
      final modules = await remoteDataSource.getCourseModules(courseId);
      return Right(modules);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LessonModel>>> getModuleLessons(
    String moduleId,
  ) async {
    try {
      final lessons = await remoteDataSource.getModuleLessons(moduleId);
      return Right(lessons);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EnrollmentModel>> enrollInCourse(
    String courseId,
  ) async {
    try {
      final enrollment = await remoteDataSource.enrollInCourse(courseId);
      return Right(enrollment);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EnrollmentModel>>> getMyEnrollments() async {
    try {
      final enrollments = await remoteDataSource.getMyEnrollments();
      return Right(enrollments);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EnrollmentModel>> getEnrollmentByCourseId(
    String courseId,
  ) async {
    try {
      final enrollment =
          await remoteDataSource.getEnrollmentByCourseId(courseId);
      return Right(enrollment);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
