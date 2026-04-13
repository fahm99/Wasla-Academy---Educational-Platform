import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/course_model.dart';
import '../models/module_model.dart';
import '../models/lesson_model.dart';
import '../models/enrollment_model.dart';

/// مصدر البيانات البعيد للكورسات
abstract class CoursesRemoteDataSource {
  Future<List<CourseModel>> getAllCourses();
  Future<List<CourseModel>> searchCourses({
    String? query,
    String? category,
    String? level,
  });
  Future<CourseModel> getCourseById(String id);
  Future<List<ModuleModel>> getCourseModules(String courseId);
  Future<List<LessonModel>> getModuleLessons(String moduleId);
  Future<EnrollmentModel> enrollInCourse(String courseId);
  Future<List<EnrollmentModel>> getMyEnrollments();
  Future<EnrollmentModel> getEnrollmentByCourseId(String courseId);
}

class CoursesRemoteDataSourceImpl implements CoursesRemoteDataSource {
  final SupabaseClient client;

  CoursesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CourseModel>> getAllCourses() async {
    try {
      final response = await client
          .from(ApiConstants.coursesTable)
          .select('*, provider:provider_id(name, avatar_url)')
          .eq('status', ApiConstants.courseStatusPublished)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CourseModel>> searchCourses({
    String? query,
    String? category,
    String? level,
  }) async {
    try {
      var queryBuilder = client
          .from(ApiConstants.coursesTable)
          .select('*, provider:provider_id(name, avatar_url)')
          .eq('status', ApiConstants.courseStatusPublished);

      if (query != null && query.isNotEmpty) {
        queryBuilder = queryBuilder.or(
          'title.ilike.%$query%,description.ilike.%$query%',
        );
      }

      if (category != null && category.isNotEmpty) {
        queryBuilder = queryBuilder.eq('category', category);
      }

      if (level != null && level.isNotEmpty) {
        queryBuilder = queryBuilder.eq('level', level);
      }

      final response = await queryBuilder.order('created_at', ascending: false);

      return (response as List)
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CourseModel> getCourseById(String id) async {
    try {
      final response = await client
          .from(ApiConstants.coursesTable)
          .select('*, provider:provider_id(name, avatar_url)')
          .eq('id', id)
          .single();

      return CourseModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const NotFoundException(message: 'Course not found');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ModuleModel>> getCourseModules(String courseId) async {
    try {
      final response = await client
          .from(ApiConstants.modulesTable)
          .select()
          .eq('course_id', courseId)
          .order('order_number', ascending: true);

      return (response as List)
          .map((json) => ModuleModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LessonModel>> getModuleLessons(String moduleId) async {
    try {
      final response = await client
          .from(ApiConstants.lessonsTable)
          .select()
          .eq('module_id', moduleId)
          .order('order_number', ascending: true);

      return (response as List)
          .map((json) => LessonModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<EnrollmentModel> enrollInCourse(String courseId) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw const UnauthorizedException(message: 'User not authenticated');
      }

      final response = await client
          .from(ApiConstants.enrollmentsTable)
          .insert({
            'student_id': userId,
            'course_id': courseId,
            'enrollment_date': DateTime.now().toIso8601String(),
            'status': ApiConstants.enrollmentStatusActive,
          })
          .select()
          .single();

      return EnrollmentModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw const ConflictException(
            message: 'Already enrolled in this course');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ConflictException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<EnrollmentModel>> getMyEnrollments() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw const UnauthorizedException(message: 'User not authenticated');
      }

      final response = await client
          .from(ApiConstants.enrollmentsTable)
          .select('*, courses(*)')
          .eq('student_id', userId)
          .order('enrollment_date', ascending: false);

      return (response as List)
          .map((json) => EnrollmentModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<EnrollmentModel> getEnrollmentByCourseId(String courseId) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw const UnauthorizedException(message: 'User not authenticated');
      }

      final response = await client
          .from(ApiConstants.enrollmentsTable)
          .select()
          .eq('student_id', userId)
          .eq('course_id', courseId)
          .single();

      return EnrollmentModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const NotFoundException(message: 'Enrollment not found');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
