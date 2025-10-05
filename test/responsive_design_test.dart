import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/widgets/course_card.dart';
import 'package:waslaacademy/src/models/course.dart';

void main() {
  group('Responsive Design Tests', () {
    testWidgets('CourseCard adapts to different screen sizes',
        (WidgetTester tester) async {
      // Create a test course
      const testCourse = Course(
        id: 1,
        title: 'Test Course',
        description: 'Test course description',
        category: 'tech',
        level: 'beginner',
        price: 99.99,
        image: 'https://example.com/image.jpg',
        instructor: 'Test Instructor',
        instructorImage: 'https://example.com/instructor.jpg',
        rating: 4.5,
        students: 100,
        duration: '2 hours',
        free: false,
        lessons: [],
        exams: [],
        type: 'university',
        provider: 'Test University',
        providerImage: 'https://example.com/provider.jpg',
        providerRating: 4.5,
        providerCourses: 10,
      );

      // Test on a phone-sized screen
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return const MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 360,
                  child: CourseCard(course: testCourse),
                ),
              ),
            );
          },
        ),
      );

      // Verify the widget builds without errors
      expect(find.byType(CourseCard), findsOneWidget);
      expect(find.text('Test Course'), findsOneWidget);

      // Test on a tablet-sized screen
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(768, 1024),
          builder: (context, child) {
            return const MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 768,
                  child: CourseCard(course: testCourse),
                ),
              ),
            );
          },
        ),
      );

      // Verify the widget builds without errors
      expect(find.byType(CourseCard), findsOneWidget);
      expect(find.text('Test Course'), findsOneWidget);
    });

    testWidgets('Responsive text sizing works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return Text(
                      'Test Text',
                      style: TextStyle(fontSize: 16.sp),
                    );
                  },
                ),
              ),
            );
          },
        ),
      );

      // Verify the text widget builds with responsive font size
      expect(find.text('Test Text'), findsOneWidget);
    });
  });
}
