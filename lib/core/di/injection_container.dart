import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../services/local_storage_service.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Courses
import '../../features/courses/data/datasources/courses_remote_datasource.dart';
import '../../features/courses/data/repositories/courses_repository_impl.dart';
import '../../features/courses/domain/repositories/courses_repository.dart';
import '../../features/courses/domain/usecases/get_all_courses_usecase.dart';
import '../../features/courses/domain/usecases/search_courses_usecase.dart';
import '../../features/courses/domain/usecases/get_course_details_usecase.dart';
import '../../features/courses/domain/usecases/get_course_modules_usecase.dart';
import '../../features/courses/domain/usecases/get_module_lessons_usecase.dart';
import '../../features/courses/domain/usecases/enroll_in_course_usecase.dart';
import '../../features/courses/domain/usecases/get_my_enrollments_usecase.dart';
import '../../features/courses/presentation/bloc/courses_bloc.dart';

// Payments
import '../../features/payments/data/datasources/payments_remote_datasource.dart';
import '../../features/payments/data/repositories/payments_repository_impl.dart';
import '../../features/payments/domain/repositories/payments_repository.dart';
import '../../features/payments/domain/usecases/get_provider_payment_settings_usecase.dart';
import '../../features/payments/domain/usecases/submit_payment_usecase.dart';
import '../../features/payments/domain/usecases/get_payment_by_id_usecase.dart';
import '../../features/payments/domain/usecases/get_my_payments_usecase.dart';
import '../../features/payments/domain/usecases/resubmit_payment_usecase.dart';
import '../../features/payments/presentation/bloc/payments_bloc.dart';

// Learning
import '../../features/learning/data/datasources/learning_remote_datasource.dart';
import '../../features/learning/data/repositories/learning_repository_impl.dart';
import '../../features/learning/domain/repositories/learning_repository.dart';
import '../../features/learning/domain/usecases/get_course_lessons_usecase.dart';
import '../../features/learning/domain/usecases/update_lesson_progress_usecase.dart';
import '../../features/learning/domain/usecases/get_lesson_progress_usecase.dart';
import '../../features/learning/domain/usecases/get_enrollment_progress_usecase.dart';
import '../../features/learning/presentation/bloc/learning_bloc.dart';

// Exams
import '../../features/exams/data/datasources/exams_remote_datasource.dart';
import '../../features/exams/data/repositories/exams_repository_impl.dart';
import '../../features/exams/domain/repositories/exams_repository.dart';
import '../../features/exams/domain/usecases/get_course_exams_usecase.dart';
import '../../features/exams/domain/usecases/get_exam_with_questions_usecase.dart';
import '../../features/exams/domain/usecases/submit_exam_answers_usecase.dart';
import '../../features/exams/domain/usecases/get_my_exam_results_usecase.dart';
import '../../features/exams/domain/usecases/can_retake_exam_usecase.dart';
import '../../features/exams/presentation/bloc/exams_bloc.dart';

// Certificates
import '../../features/certificates/data/datasources/certificates_remote_datasource.dart';
import '../../features/certificates/data/repositories/certificates_repository_impl.dart';
import '../../features/certificates/domain/repositories/certificates_repository.dart';
import '../../features/certificates/domain/usecases/get_my_certificates_usecase.dart';
import '../../features/certificates/domain/usecases/get_certificate_usecase.dart';
import '../../features/certificates/domain/usecases/verify_certificate_usecase.dart';
import '../../features/certificates/domain/usecases/generate_certificate_usecase.dart';
import '../../features/certificates/presentation/bloc/certificates_bloc.dart';

// Notifications
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_my_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/mark_as_read_usecase.dart';
import '../../features/notifications/domain/usecases/mark_all_as_read_usecase.dart';
import '../../features/notifications/domain/usecases/get_unread_count_usecase.dart';
import '../../features/notifications/domain/usecases/delete_notification_usecase.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';

// Profile
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/domain/usecases/upload_avatar_usecase.dart';
import '../../features/profile/domain/usecases/delete_avatar_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============ Core ============
  final localStorage = await LocalStorageService.getInstance();
  sl.registerLazySingleton<LocalStorageService>(() => localStorage);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<SupabaseClient>(() => ApiClient.instance);

  // ============ Auth Feature ============
  // Bloc
  sl.registerFactory(() => AuthBloc(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        signOutUseCase: sl(),
        resetPasswordUseCase: sl(),
        getCurrentUserUseCase: sl(),
        localStorageService: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // ============ Courses Feature ============
  // Bloc
  sl.registerFactory(() => CoursesBloc(
        getAllCoursesUseCase: sl(),
        searchCoursesUseCase: sl(),
        getCourseDetailsUseCase: sl(),
        getCourseModulesUseCase: sl(),
        getModuleLessonsUseCase: sl(),
        enrollInCourseUseCase: sl(),
        getMyEnrollmentsUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetAllCoursesUseCase(sl()));
  sl.registerLazySingleton(() => SearchCoursesUseCase(sl()));
  sl.registerLazySingleton(() => GetCourseDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetCourseModulesUseCase(sl()));
  sl.registerLazySingleton(() => GetModuleLessonsUseCase(sl()));
  sl.registerLazySingleton(() => EnrollInCourseUseCase(sl()));
  sl.registerLazySingleton(() => GetMyEnrollmentsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CoursesRepository>(
    () => CoursesRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<CoursesRemoteDataSource>(
    () => CoursesRemoteDataSourceImpl(client: sl()),
  );

  // ============ Payments Feature ============
  // Bloc
  sl.registerFactory(() => PaymentsBloc(
        getProviderPaymentSettingsUseCase: sl(),
        submitPaymentUseCase: sl(),
        getPaymentByIdUseCase: sl(),
        getMyPaymentsUseCase: sl(),
        resubmitPaymentUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetProviderPaymentSettingsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitPaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetMyPaymentsUseCase(sl()));
  sl.registerLazySingleton(() => ResubmitPaymentUseCase(sl()));

  // Repository
  sl.registerLazySingleton<PaymentsRepository>(
    () => PaymentsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<PaymentsRemoteDataSource>(
    () => PaymentsRemoteDataSourceImpl(client: sl()),
  );

  // ============ Learning Feature ============
  // Bloc
  sl.registerFactory(() => LearningBloc(
        getCourseLessonsUseCase: sl(),
        updateLessonProgressUseCase: sl(),
        getLessonProgressUseCase: sl(),
        getEnrollmentProgressUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetCourseLessonsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateLessonProgressUseCase(sl()));
  sl.registerLazySingleton(() => GetLessonProgressUseCase(sl()));
  sl.registerLazySingleton(() => GetEnrollmentProgressUseCase(sl()));

  // Repository
  sl.registerLazySingleton<LearningRepository>(
    () => LearningRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<LearningRemoteDataSource>(
    () => LearningRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // ============ Exams Feature ============
  // Bloc
  sl.registerFactory(() => ExamsBloc(
        getCourseExamsUseCase: sl(),
        getExamWithQuestionsUseCase: sl(),
        submitExamAnswersUseCase: sl(),
        getMyExamResultsUseCase: sl(),
        canRetakeExamUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetCourseExamsUseCase(sl()));
  sl.registerLazySingleton(() => GetExamWithQuestionsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitExamAnswersUseCase(sl()));
  sl.registerLazySingleton(() => GetMyExamResultsUseCase(sl()));
  sl.registerLazySingleton(() => CanRetakeExamUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ExamsRepository>(
    () => ExamsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<ExamsRemoteDataSource>(
    () => ExamsRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // ============ Certificates Feature ============
  // Bloc
  sl.registerFactory(() => CertificatesBloc(
        getMyCertificatesUseCase: sl(),
        getCertificateUseCase: sl(),
        verifyCertificateUseCase: sl(),
        generateCertificateUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetMyCertificatesUseCase(sl()));
  sl.registerLazySingleton(() => GetCertificateUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCertificateUseCase(sl()));
  sl.registerLazySingleton(() => GenerateCertificateUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CertificatesRepository>(
    () => CertificatesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<CertificatesRemoteDataSource>(
    () => CertificatesRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // ============ Notifications Feature ============
  // Bloc
  sl.registerFactory(() => NotificationsBloc(
        getMyNotificationsUseCase: sl(),
        markAsReadUseCase: sl(),
        markAllAsReadUseCase: sl(),
        getUnreadCountUseCase: sl(),
        deleteNotificationUseCase: sl(),
        repository: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetMyNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllAsReadUseCase(sl()));
  sl.registerLazySingleton(() => GetUnreadCountUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNotificationUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // ============ Profile Feature ============
  // Bloc
  sl.registerFactory(() => ProfileBloc(
        getProfileUseCase: sl(),
        updateProfileUseCase: sl(),
        uploadAvatarUseCase: sl(),
        deleteAvatarUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => UploadAvatarUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAvatarUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(supabaseClient: sl()),
  );
}
