import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/lesson_progress.dart';
import '../../domain/entities/enrollment_progress.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/learning_remote_datasource.dart';

/// تطبيق مستودع التعلم
class LearningRepositoryImpl implements LearningRepository {
  final LearningRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

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
      final result =
          await remoteDataSource.getEnrollmentProgress(studentId, courseId);
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
      final result = await remoteDataSource.getCourseLessonsWithProgress(
          studentId, courseId);
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
