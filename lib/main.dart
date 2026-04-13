import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/network/api_client.dart';
import 'core/constants/app_colors.dart';
import 'core/di/injection_container.dart' as di;

// Blocs
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/courses/presentation/bloc/courses_bloc.dart';
import 'features/payments/presentation/bloc/payments_bloc.dart';
import 'features/learning/presentation/bloc/learning_bloc.dart';
import 'features/exams/presentation/bloc/exams_bloc.dart';
import 'features/certificates/presentation/bloc/certificates_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

// Screens
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/main_page.dart';
import 'features/info/presentation/pages/about_screen.dart';
import 'features/info/presentation/pages/contact_screen.dart';
import 'features/info/presentation/pages/help_screen.dart';
import 'features/info/presentation/pages/terms_screen.dart';
import 'features/settings/presentation/pages/settings_screen.dart';
import 'features/payments/presentation/pages/payment_info_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Supabase
  try {
    await ApiClient.initialize();
    debugPrint('✅ Supabase initialized successfully');
  } catch (e) {
    debugPrint('❌ Supabase initialization failed: $e');
  }

  // تهيئة Dependency Injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => di.sl<AuthBloc>()..add(const LoadCurrentUser())),
        BlocProvider(create: (_) => di.sl<CoursesBloc>()),
        BlocProvider(create: (_) => di.sl<PaymentsBloc>()),
        BlocProvider(create: (_) => di.sl<LearningBloc>()),
        BlocProvider(create: (_) => di.sl<ExamsBloc>()),
        BlocProvider(create: (_) => di.sl<CertificatesBloc>()),
        BlocProvider(create: (_) => di.sl<NotificationsBloc>()),
        BlocProvider(create: (_) => di.sl<ProfileBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        rebuildFactor: RebuildFactors.change,
        ensureScreenSize: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'منصة وصلة أكاديمي (Wasla Academy)',
            theme: ThemeData(
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.light,
              fontFamily: 'Cairo',
            ),
            locale: const Locale('ar'),
            supportedLocales: const [
              Locale('ar', ''),
              Locale('en', ''),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/main': (context) {
                final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
                return MainPage(initialTab: args?['initialTab']);
              },
              '/payment-info': (context) {
                final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
                return PaymentInfoPage(
                  providerId: args?['providerId'] ?? '',
                  courseId: args?['courseId'] ?? '',
                  courseName: args?['courseName'] ?? '',
                  amount: args?['amount'] ?? 0.0,
                );
              },
              '/about': (context) => const AboutScreen(),
              '/contact': (context) => const ContactScreen(),
              '/help': (context) => const HelpScreen(),
              '/terms': (context) => const TermsScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const SplashScreen();
        }

        if (state is Authenticated) {
          return const MainPage();
        }

        return const LoginPage();
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 60,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              'قيد التطوير',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'هذه الصفحة قيد التطوير وسيتم إضافتها قريباً',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
