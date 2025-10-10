import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/user/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/user/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/user/views/splash_screen.dart';
import 'package:waslaacademy/src/user/views/login_screen.dart';
import 'package:waslaacademy/src/user/views/register_screen.dart';
import 'package:waslaacademy/src/user/views/main_screen.dart';
import 'package:waslaacademy/src/user/views/home_screen.dart';
import 'package:waslaacademy/src/user/views/notifications_screen.dart';
import 'package:waslaacademy/src/user/views/certificates_screen.dart';
import 'package:waslaacademy/src/user/views/about_screen.dart';
import 'package:waslaacademy/src/user/views/contact_screen.dart';
import 'package:waslaacademy/src/user/widgets/test_button_screen.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_theme.dart';
import 'package:waslaacademy/src/user/providers/theme_provider.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc();
  }

  @override
  void dispose() {
    authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authBloc),
          BlocProvider(
              create: (context) =>
                  CourseBloc(authBloc: context.read<AuthBloc>())),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return ScreenUtilInit(
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
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeProvider.themeMode,
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
                    '/about': (context) => const AboutScreen(),
                    '/contact': (context) => const ContactScreen(),
                    '/test-button': (context) => const TestButtonScreen(),
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
            );
          },
        ),
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
  bool _isStorageChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  void _initializeApp() async {
    // Load user from local storage
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() async {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(LoadUserFromStorage());

    setState(() {
      _isStorageChecked = true;
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

    if (!_isStorageChecked) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          setState(() {
            _isLoggedIn = true;
          });
        } else if (state is AuthInitial) {
          setState(() {
            _isLoggedIn = false;
          });
        }
      },
      child: _isLoggedIn
          ? KeyedSubtree(
              key: ValueKey(_isLoggedIn),
              child: const MainScreen(),
            )
          : LoginScreen(
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
