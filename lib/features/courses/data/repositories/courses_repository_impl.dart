import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../domain/repositories/courses_repository.dart';
import '../datasources/courses_remote_datasource.dart';
import '../models/course_model.dart';
import '../models/module_model.dart';
import '../models/lesson_model.dart';
import '../models/enrollment_model.dart';

/// تنفيذ مستودع الكورسات
class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesRemoteDataSource remoteDataSource;
  final _cache = CacheManager();

  // مفاتيح الـ Cache
  static const String _allCoursesKey = 'all_courses';
  static const String _courseDetailsPrefix = 'course_details_';
  static const String _courseModulesPrefix = 'course_modules_';
  static const String _moduleLessonsPrefix = 'module_lessons_';
  static const String _myEnrollmentsKey = 'my_enrollments';

  // مدة الـ Cache
  static const Duration _coursesCacheDuration = Duration(minutes: 10);
  static const Duration _detailsCacheDuration = Duration(minutes: 15);
  static const Duration _enrollmentsCacheDuration = Duration(minutes: 5);

  CoursesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CourseModel>>> getAllCourses() async {
    try {
      // التحقق من الـ Cache
      final cached = _cache.getList<CourseModel>(_allCoursesKey);
      if (cached != null) {
        return Right(cached);
      }

      // جلب من الخادم
      final courses = await remoteDataSource.getAllCourses();

      // حفظ في الـ Cache
      _cache.putList(_allCoursesKey, courses, ttl: _coursesCacheDuration);

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
      // التحقق من الـ Cache
      final cacheKey = '$_courseDetailsPrefix$id';
      final cached = _cache.get<CourseModel>(cacheKey);
      if (cached != null) {
        return Right(cached);
      }

      // جلب من الخادم
      final course = await remoteDataSource.getCourseById(id);

      // حفظ في الـ Cache
      _cache.put(cacheKey, course, ttl: _detailsCacheDuration);

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
      // التحقق من الـ Cache
      final cacheKey = '$_courseModulesPrefix$courseId';
      final cached = _cache.getList<ModuleModel>(cacheKey);
      if (cached != null) {
        return Right(cached);
      }

      // جلب من الخادم
      final modules = await remoteDataSource.getCourseModules(courseId);

      // حفظ في الـ Cache
      _cache.putList(cacheKey, modules, ttl: _detailsCacheDuration);

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
      // التحقق من الـ Cache
      final cacheKey = '$_moduleLessonsPrefix$moduleId';
      final cached = _cache.getList<LessonModel>(cacheKey);
      if (cached != null) {
        return Right(cached);
      }

      // جلب من الخادم
      final lessons = await remoteDataSource.getModuleLessons(moduleId);

      // حفظ في الـ Cache
      _cache.putList(cacheKey, lessons, ttl: _detailsCacheDuration);

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

      // مسح cache التسجيلات لأنها تغيرت
      _cache.remove(_myEnrollmentsKey);

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
      // التحقق من الـ Cache
      final cached = _cache.getList<EnrollmentModel>(_myEnrollmentsKey);
      if (cached != null) {
        return Right(cached);
      }

      // جلب من الخادم
      final enrollments = await remoteDataSource.getMyEnrollments();

      // حفظ في الـ Cache
      _cache.putList(_myEnrollmentsKey, enrollments,
          ttl: _enrollmentsCacheDuration);

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
