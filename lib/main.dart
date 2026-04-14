import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

// Core
import 'core/config/supabase_config.dart';
import 'core/constants/app_colors.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/session_manager.dart';
import 'core/services/error_handler.dart';

// Features - Auth
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/auth/presentation/pages/verification_screen.dart';

// Features - Splash
import 'features/splash/presentation/pages/splash_screen.dart';

// Features - Home
import 'features/home/presentation/pages/main_page.dart';
import 'features/home/presentation/pages/home_page.dart';

// Features - Courses
import 'features/courses/presentation/bloc/courses_bloc.dart';
import 'features/courses/presentation/pages/courses_page.dart';
import 'features/courses/presentation/pages/course_detail_page.dart';
import 'features/courses/presentation/pages/my_courses_page.dart';

// Features - Learning
import 'features/learning/presentation/bloc/learning_bloc.dart';
import 'features/learning/presentation/pages/course_content_page.dart';
import 'features/learning/presentation/pages/lesson_viewer_page.dart';

// Features - Exams
import 'features/exams/presentation/bloc/exams_bloc.dart';
import 'features/exams/presentation/pages/course_exams_page.dart';
import 'features/exams/presentation/pages/exam_page.dart';

// Features - Payments
import 'features/payments/presentation/bloc/payments_bloc.dart';
import 'features/payments/presentation/pages/payment_info_page.dart';
import 'features/payments/presentation/pages/payment_upload_page.dart';
import 'features/payments/presentation/pages/payment_status_page.dart';
import 'features/payments/presentation/pages/my_payments_page.dart';

// Features - Certificates
import 'features/certificates/presentation/bloc/certificates_bloc.dart';
import 'features/certificates/presentation/pages/certificates_page.dart';
import 'features/certificates/presentation/pages/certificate_detail_page.dart';
import 'features/certificates/domain/entities/certificate.dart';

// Features - Notifications
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/notifications/presentation/pages/notifications_page.dart';

// Features - Profile
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/pages/profile_page.dart';

// Features - Settings & Info
import 'features/settings/presentation/pages/settings_screen.dart';
import 'features/info/presentation/pages/about_screen.dart';
import 'features/info/presentation/pages/contact_screen.dart';
import 'features/info/presentation/pages/help_screen.dart';
import 'features/info/presentation/pages/terms_screen.dart';

void main() async {
  // تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Error Handler
  await ErrorHandler().initialize();

  // Global Error Handler
  FlutterError.onError = ErrorHandler.handleFlutterError;

  // Async Error Handler
  runZonedGuarded(() async {
    try {
      // تحميل متغيرات البيئة
      await dotenv.load(fileName: ".env");

      // Initialize Supabase
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );

      // Initialize dependency injection
      await di.init();

      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      await ErrorHandler().logInfo('App initialized successfully');
      runApp(const MyApp());
    } catch (e, stackTrace) {
      await ErrorHandler()
          .logFatal(e, stackTrace, context: 'App Initialization');
      // يمكن عرض شاشة خطأ للمستخدم هنا
    }
  }, ErrorHandler.handleZoneError);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(const LoadCurrentUser()),
        ),
        BlocProvider<CoursesBloc>(
          create: (context) => di.sl<CoursesBloc>(),
        ),
        BlocProvider<LearningBloc>(
          create: (context) => di.sl<LearningBloc>(),
        ),
        BlocProvider<ExamsBloc>(
          create: (context) => di.sl<ExamsBloc>(),
        ),
        BlocProvider<PaymentsBloc>(
          create: (context) => di.sl<PaymentsBloc>(),
        ),
        BlocProvider<CertificatesBloc>(
          create: (context) => di.sl<CertificatesBloc>(),
        ),
        BlocProvider<NotificationsBloc>(
          create: (context) => di.sl<NotificationsBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => di.sl<ProfileBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // تتبع نشاط المستخدم لإدارة الجلسة
          return GestureDetector(
            onTap: () => _updateSessionActivity(),
            onPanDown: (_) => _updateSessionActivity(),
            onScaleStart: (_) => _updateSessionActivity(),
            behavior: HitTestBehavior.translucent,
            child: MaterialApp(
              title: 'منصة وصلة أكاديمي',
              debugShowCheckedModeBanner: false,

              // Theme
              theme: ThemeData(
                primaryColor: AppColors.primary,
                scaffoldBackgroundColor: AppColors.light,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary,
                  primary: AppColors.primary,
                  secondary: AppColors.secondary,
                ),
                fontFamily: 'Cairo',
                useMaterial3: true,

                // AppBar Theme
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                  iconTheme: IconThemeData(color: AppColors.textPrimary),
                  titleTextStyle: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),

                // Input Decoration Theme
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),

                // Elevated Button Theme
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),

                // Card Theme
                cardTheme: CardTheme(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),

              // Localization
              locale: const Locale('ar', 'SA'),
              supportedLocales: const [
                Locale('ar', 'SA'),
                Locale('en', 'US'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              // Routes
              initialRoute: '/',
              routes: {
                '/': (context) => const SplashScreen(),
                '/login': (context) => const LoginPage(),
                '/register': (context) => const RegisterPage(),
                '/forgot-password': (context) => const ForgotPasswordPage(),
                // Verification screen requires email parameter, use onGenerateRoute
                '/main': (context) => const MainPage(),
                '/home': (context) => const HomePage(),
                '/courses': (context) => const CoursesPage(),
                '/my-courses': (context) => const MyCoursesPage(),
                '/certificates': (context) => const CertificatesPage(),
                '/notifications': (context) => const NotificationsPage(),
                '/profile': (context) => const ProfilePage(),
                '/settings': (context) => const SettingsScreen(),
                '/about': (context) => const AboutScreen(),
                '/contact': (context) => const ContactScreen(),
                '/help': (context) => const HelpScreen(),
                '/terms': (context) => const TermsScreen(),
                '/my-payments': (context) => const MyPaymentsPage(),
              },

              // On Generate Route for dynamic routes
              onGenerateRoute: (settings) {
                // Verification Screen
                if (settings.name == '/verification') {
                  final email = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (context) => VerificationScreen(email: email),
                  );
                }

                // Course Detail
                if (settings.name == '/course-detail') {
                  final courseId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (context) => CourseDetailPage(courseId: courseId),
                  );
                }

                // Course Content
                if (settings.name == '/course-content') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) => CourseContentPage(
                      courseId: args['courseId'] as String,
                      courseTitle: args['courseTitle'] as String,
                    ),
                  );
                }

                // Lesson Viewer
                if (settings.name == '/lesson-viewer') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) => LessonViewerPage(
                      lessonId: args['lessonId'] as String,
                      lessonTitle: args['lessonTitle'] as String,
                      lessonType: args['lessonType'] as String,
                      courseId: args['courseId'] as String,
                    ),
                  );
                }

                // Course Exams
                if (settings.name == '/course-exams') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) => CourseExamsPage(
                      courseId: args['courseId'] as String,
                      courseTitle: args['courseTitle'] as String,
                    ),
                  );
                }

                // Exam Page
                if (settings.name == '/exam') {
                  final examId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (context) => ExamPage(
                      examId: examId,
                    ),
                  );
                }

                // Payment Info
                if (settings.name == '/payment-info') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) => PaymentInfoPage(
                      providerId: args['providerId'] as String,
                      courseId: args['courseId'] as String,
                      courseName: args['courseName'] as String,
                      amount: args['amount'] as double,
                    ),
                  );
                }

                // Payment Upload
                if (settings.name == '/payment-upload') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) => PaymentUploadPage(
                      courseId: args['courseId'] as String,
                      courseName: args['courseName'] as String,
                      amount: args['amount'] as double,
                      acceptBankTransfer: args['acceptBankTransfer'] as bool,
                      acceptLocalTransfer: args['acceptLocalTransfer'] as bool,
                    ),
                  );
                }

                // Payment Status
                if (settings.name == '/payment-status') {
                  final paymentId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (context) =>
                        PaymentStatusPage(paymentId: paymentId),
                  );
                }

                // Certificate Detail
                if (settings.name == '/certificate-detail') {
                  final certificate = settings.arguments as Certificate;
                  return MaterialPageRoute(
                    builder: (context) => CertificateDetailPage(
                      certificate: certificate,
                    ),
                  );
                }

                return null;
              },
            ),
          );
        },
      ),
    );
  }

  /// تحديث نشاط المستخدم في SessionManager
  void _updateSessionActivity() {
    try {
      final sessionManager = di.sl<SessionManager>();
      sessionManager.updateActivity();
    } catch (e) {
      // SessionManager قد لا يكون متاحاً في بعض الحالات
    }
  }
}
