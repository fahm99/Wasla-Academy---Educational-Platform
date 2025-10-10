import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:waslaacademy/src/user/models/course.dart';

class CourseData {
  static List<Course> courses = [];

  static Future<void> initialize() async {
    try {
      // Load courses from JSON file
      final String jsonString =
          await rootBundle.loadString('assets/data/courses.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      if (jsonMap.containsKey('courses')) {
        final List<dynamic> coursesJson = jsonMap['courses'];
        courses = coursesJson.map((courseJson) {
          // Parse lessons
          final List<Lesson> lessons = courseJson['lessons'] != null
              ? List<Lesson>.from(
                  courseJson['lessons'].map((lessonJson) => Lesson(
                        id: lessonJson['id'],
                        title: lessonJson['title'],
                        duration: lessonJson['duration'],
                        type: lessonJson['type'],
                        completed: lessonJson['completed'] ?? false,
                        description: lessonJson['description'],
                      )))
              : [];

          // Parse exams
          final List<Exam> exams = courseJson['exams'] != null
              ? List<Exam>.from(courseJson['exams'].map((examJson) => Exam(
                    id: examJson['id'],
                    title: examJson['title'],
                    duration: examJson['duration'],
                    questions: examJson['questions'],
                    type: examJson['type'],
                    locked: examJson['locked'] ?? true,
                  )))
              : [];

          // Parse resources
          final List<Resource> resources = courseJson['resources'] != null
              ? List<Resource>.from(
                  courseJson['resources'].map((resourceJson) => Resource(
                        id: resourceJson['id'],
                        name: resourceJson['name'],
                        type: resourceJson['type'],
                        size: resourceJson['size'],
                        date: resourceJson['date'],
                        courseId: resourceJson['courseId'],
                      )))
              : [];

          return Course(
            id: courseJson['id'],
            title: courseJson['title'],
            description: courseJson['description'],
            category: courseJson['category'],
            level: courseJson['level'],
            price: courseJson['price'],
            image: courseJson['image'],
            instructor: courseJson['instructor'],
            instructorImage: courseJson['instructorImage'],
            rating: courseJson['rating']?.toDouble() ?? 0.0,
            students: courseJson['students'],
            duration: courseJson['duration'],
            free: courseJson['free'],
            lessons: lessons,
            exams: exams,
            resources: resources,
            type: courseJson['type'],
            provider: courseJson['provider'],
            providerImage: courseJson['providerImage'],
            providerRating: courseJson['providerRating']?.toDouble() ?? 0.0,
            providerCourses: courseJson['providerCourses'],
          );
        }).toList();
      }
    } catch (e) {
      // If there's an error loading from JSON, use empty list
      courses = [];
      print('Error loading courses from JSON: $e');
    }
  }
}
