import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/views/splash_screen.dart';
import 'package:waslaacademy/src/views/login_screen.dart';
import 'package:waslaacademy/src/views/register_screen.dart';
import 'package:waslaacademy/src/views/main_screen.dart';
import 'package:waslaacademy/src/views/home_screen.dart';
import 'package:waslaacademy/src/views/notifications_screen.dart';
import 'package:waslaacademy/src/views/certificates_screen.dart';
import 'package:waslaacademy/src/views/live_lectures_screen.dart';
import 'package:waslaacademy/src/views/about_screen.dart';
import 'package:waslaacademy/src/views/contact_screen.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => CourseBloc(),
        ),
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
            theme: AppTheme.theme,
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
            routes: {
              '/': (context) => const AuthWrapper(),
              '/main': (context) {
                final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
                return MainScreen(initialTab: args?['initialTab']);
              },
              '/home': (context) => const HomeScreen(),
              '/courses': (context) => const HomeScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/certificates': (context) => const CertificatesScreen(),
              '/live-lectures': (context) => const LiveLecturesScreen(),
              '/about': (context) => const AboutScreen(),
              '/contact': (context) => const ContactScreen(),
              '/login': (context) => BlocProvider.value(
                    value: context.read<AuthBloc>(),
                    child: LoginScreen(
                      onRegisterTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                              onLoginTap: () {
                                Navigator.pop(context);
                              },
                              onRegisterSuccess: () {
                                // Handle registration success
                              },
                            ),
                          ),
                        );
                      },
                      onLoginSuccess: () {
                        // Handle login success
                      },
                    ),
                  ),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSplash = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize services here
      // For example: ServiceLocator.setup();
    });
  }

  void _navigateFromSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(onSplashFinished: _navigateFromSplash);
    }

    if (!_isLoggedIn) {
      return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            _onLoginSuccess();
          }
        },
        child: LoginScreen(
          onRegisterTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(
                  onLoginTap: () {
                    Navigator.pop(context);
                  },
                  onRegisterSuccess: _onLoginSuccess,
                ),
              ),
            );
          },
          onLoginSuccess: _onLoginSuccess,
        ),
      );
    }

    return KeyedSubtree(
      key: ValueKey(_isLoggedIn),
      child: const MainScreen(),
    );
  }
}

// Placeholder screen for routes that haven't been implemented yet
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
          onPressed: () {
            Navigator.pop(context);
          },
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
