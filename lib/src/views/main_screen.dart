import 'package:flutter/material.dart';
import 'package:waslaacademy/src/views/courses_screen.dart';
import 'package:waslaacademy/src/views/home_screen.dart';
import 'package:waslaacademy/src/views/my_courses_screen.dart';
import 'package:waslaacademy/src/views/profile_screen.dart';
import 'package:waslaacademy/src/widgets/custom_bottom_nav.dart';
import 'package:waslaacademy/src/widgets/integrated_drawer.dart';

class MainScreen extends StatefulWidget {
  final int? initialTab;

  const MainScreen({super.key, this.initialTab});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _notificationCount =
      0; // This would be managed by a BLoC in real implementation

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Set initial tab if provided
    if (widget.initialTab != null) {
      _currentIndex = widget.initialTab!;
    }
    // In real implementation, this would listen to NotificationBloc
    _notificationCount = 3; // Mock notification count

    // Initialize screens
    _screens = [
      const HomeScreen(),
      const CoursesScreen(), // New courses screen with search and filtering
      const MyCoursesScreen(), // This is the "Learning" screen
      const ProfileScreen(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Handle arguments passed via Navigator
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
    return Scaffold(
      drawer: const IntegratedDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        notificationCount: _notificationCount,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
