import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../courses/presentation/pages/courses_page.dart';
import '../../../courses/presentation/pages/my_courses_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_navigation.dart';
import 'home_page.dart';

/// الصفحة الرئيسية مع نظام التنقل
class MainPage extends StatefulWidget {
  final int? initialTab;

  const MainPage({super.key, this.initialTab});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialTab != null) {
      _currentIndex = widget.initialTab!;
    }
    _notificationCount = 0;
  }

  // Build screens dynamically instead of in initState
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const CoursesPage();
      case 2:
        return const MyCoursesPage();
      case 3:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['initialTab'] != null) {
      setState(() {
        _currentIndex = args['initialTab'] as int;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated || state is AuthError) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        body: _getScreen(_currentIndex),
        bottomNavigationBar: BottomNavigation(
          currentIndex: _currentIndex,
          notificationCount: _notificationCount,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
