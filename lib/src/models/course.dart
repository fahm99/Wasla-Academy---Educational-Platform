import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final String level;
  final double price;
  final String image;
  final String instructor;
  final String instructorImage;
  final double rating;
  final int students;
  final String duration;
  final bool free;
  final List<Lesson> lessons;
  final List<Exam> exams;
  final List<Resource> resources; // Add resources field

  // Provider information
  final String type; // university, institute, personal
  final String provider;
  final String providerImage;
  final double providerRating;
  final int providerCourses;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.price,
    required this.image,
    required this.instructor,
    required this.instructorImage,
    required this.rating,
    required this.students,
    required this.duration,
    required this.free,
    required this.lessons,
    required this.exams,
    this.resources =
        const [], // Make resources optional with default empty list
    required this.type,
    required this.provider,
    required this.providerImage,
    required this.providerRating,
    required this.providerCourses,
  });

  Course copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? level,
    double? price,
    String? image,
    String? instructor,
    String? instructorImage,
    double? rating,
    int? students,
    String? duration,
    bool? free,
    List<Lesson>? lessons,
    List<Exam>? exams,
    List<Resource>? resources, // Add resources parameter
    String? type,
    String? provider,
    String? providerImage,
    double? providerRating,
    int? providerCourses,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      level: level ?? this.level,
      price: price ?? this.price,
      image: image ?? this.image,
      instructor: instructor ?? this.instructor,
      instructorImage: instructorImage ?? this.instructorImage,
      rating: rating ?? this.rating,
      students: students ?? this.students,
      duration: duration ?? this.duration,
      free: free ?? this.free,
      lessons: lessons ?? this.lessons,
      exams: exams ?? this.exams,
      resources: resources ?? this.resources, // Add resources parameter
      type: type ?? this.type,
      provider: provider ?? this.provider,
      providerImage: providerImage ?? this.providerImage,
      providerRating: providerRating ?? this.providerRating,
      providerCourses: providerCourses ?? this.providerCourses,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        level,
        price,
        image,
        instructor,
        instructorImage,
        rating,
        students,
        duration,
        free,
        lessons,
        exams,
        resources, // Add resources to props
        type,
        provider,
        providerImage,
        providerRating,
        providerCourses,
      ];
}

class Lesson extends Equatable {
  final int id;
  final String title;
  final String duration;
  final String type;
  final bool completed;
  final String description;

  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.type,
    required this.completed,
    required this.description,
  });

  Lesson copyWith({
    int? id,
    String? title,
    String? duration,
    String? type,
    bool? completed,
    String? description,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      completed: completed ?? this.completed,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        duration,
        type,
        completed,
        description,
      ];
}

class Exam extends Equatable {
  final int id;
  final String title;
  final String duration;
  final int questions;
  final String type;
  final bool locked; // Add locked property

  const Exam({
    required this.id,
    required this.title,
    required this.duration,
    required this.questions,
    required this.type,
    this.locked = true, // Default to locked
  });

  Exam copyWith({
    int? id,
    String? title,
    String? duration,
    int? questions,
    String? type,
    bool? locked,
  }) {
    return Exam(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      questions: questions ?? this.questions,
      type: type ?? this.type,
      locked: locked ?? this.locked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        duration,
        questions,
        type,
        locked,
      ];
}

// Add Resource class
class Resource extends Equatable {
  final int id;
  final String name;
  final String type;
  final String size;
  final String date;
  final int courseId;

  const Resource({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.date,
    required this.courseId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        size,
        date,
        courseId,
      ];
}
