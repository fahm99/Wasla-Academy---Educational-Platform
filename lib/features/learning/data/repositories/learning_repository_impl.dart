import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../domain/entities/lesson_progress.dart';
import '../../domain/entities/enrollment_progress.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/learning_remote_datasource.dart';

/// تطبيق مستودع التعلم
class LearningRepositoryImpl implements LearningRepository {
  final LearningRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final _cache = CacheManager();

  // مفاتيح الـ Cache
  static const String _enrollmentProgressPrefix = 'enrollment_progress_';
  static const String _lessonProgressPrefix = 'lesson_progress_';
  static const String _courseLessonsPrefix = 'course_lessons_';

  // مدة الـ Cache
  static const Duration _progressCacheDuration = Duration(minutes: 3);
  static const Duration _lessonsCacheDuration = Duration(minutes: 10);

  LearningRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, EnrollmentProgress>> getEnrollmentProgress(
      String studentId, String courseId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      // التحقق من الـ Cache
      final cacheKey = '$_enrollmentProgressPrefix${studentId}_$courseId';
      final cached = _cache.get<EnrollmentProgress>(cacheKey);
      if (cached != null) {
        return Right(cached);
      }

      // جلب من الخادم
      final result =
          await remoteDataSource.getEnrollmentProgress(studentId, courseId);

      // حفظ في الـ Cache
      _cache.put(cacheKey, result, ttl: _progressCacheDuration);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, LessonProgress?>> getLessonProgress(
      String studentId, String lessonId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result =
          await remoteDataSource.getLessonProgress(studentId, lessonId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, LessonProgress>> updateLessonProgress({
    required String studentId,
    required String lessonId,
    required int watchedDuration,
    required bool isCompleted,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.updateLessonProgress(
        studentId: studentId,
        lessonId: lessonId,
        watchedDuration: watchedDuration,
        isCompleted: isCompleted,
      );

      // مسح cache التقدم لأنه تغير
      final lessonCacheKey = '$_lessonProgressPrefix${studentId}_$lessonId';
      _cache.remove(lessonCacheKey);

      // مسح cache التقدم الكلي للكورس
      _cache.keys
          .where((key) =>
              key.startsWith(_enrollmentProgressPrefix) &&
              key.contains(studentId))
          .forEach(_cache.remove);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      getCourseLessonsWithProgress(String studentId, String courseId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      // التحقق من الـ Cache
      final cacheKey = '$_courseLessonsPrefix${studentId}_$courseId';
      final cached = _cache.get<List<Map<String, dynamic>>>(cacheKey);
      if (cached != null) {
        return Right(cached);
      }

      // جلب من الخادم
      final result = await remoteDataSource.getCourseLessonsWithProgress(
          studentId, courseId);

      // حفظ في الـ Cache
      _cache.put(cacheKey, result, ttl: _lessonsCacheDuration);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
