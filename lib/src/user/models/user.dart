import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? avatar;
  final List<int> enrolledCourses;
  final List<int> completedCourses;
  final List<Certificate> certificates;
  final List<UserExam> exams;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.avatar,
    required this.enrolledCourses,
    required this.completedCourses,
    required this.certificates,
    required this.exams,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? avatar,
    List<int>? enrolledCourses,
    List<int>? completedCourses,
    List<Certificate>? certificates,
    List<UserExam>? exams,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      completedCourses: completedCourses ?? this.completedCourses,
      certificates: certificates ?? this.certificates,
      exams: exams ?? this.exams,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        phone,
        avatar,
        enrolledCourses,
        completedCourses,
        certificates,
        exams,
      ];
}

class Certificate extends Equatable {
  final int id;
  final int courseId;
  final String courseName;
  final String date;

  const Certificate({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.date,
  });

  Certificate copyWith({
    int? id,
    int? courseId,
    String? courseName,
    String? date,
  }) {
    return Certificate(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        courseName,
        date,
      ];
}

class UserExam extends Equatable {
  final int id;
  final int courseId;
  final int examId;
  final String title;
  final String date;
  final int score;
  final String status;

  const UserExam({
    required this.id,
    required this.courseId,
    required this.examId,
    required this.title,
    required this.date,
    required this.score,
    required this.status,
  });

  UserExam copyWith({
    int? id,
    int? courseId,
    int? examId,
    String? title,
    String? date,
    int? score,
    String? status,
  }) {
    return UserExam(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      examId: examId ?? this.examId,
      title: title ?? this.title,
      date: date ?? this.date,
      score: score ?? this.score,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        examId,
        title,
        date,
        score,
        status,
      ];
}
