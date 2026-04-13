import 'package:equatable/equatable.dart';
import 'course_model.dart';

/// نموذج التسجيل في الكورس
class EnrollmentModel extends Equatable {
  final String id;
  final String studentId;
  final String courseId;
  final DateTime enrollmentDate;
  final int completionPercentage;
  final String status;
  final DateTime? lastAccessed;
  final String? certificateId;
  final DateTime? completedAt;
  final CourseModel? course; // Course data from join

  const EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.enrollmentDate,
    this.completionPercentage = 0,
    this.status = 'active',
    this.lastAccessed,
    this.certificateId,
    this.completedAt,
    this.course,
  });

  /// إنشاء من JSON
  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      courseId: json['course_id'] as String,
      enrollmentDate: DateTime.parse(json['enrollment_date'] as String),
      completionPercentage: json['completion_percentage'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      lastAccessed: json['last_accessed'] != null
          ? DateTime.parse(json['last_accessed'] as String)
          : null,
      certificateId: json['certificate_id'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      course: json['courses'] != null
          ? CourseModel.fromJson(json['courses'] as Map<String, dynamic>)
          : null,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'course_id': courseId,
      'enrollment_date': enrollmentDate.toIso8601String(),
      'completion_percentage': completionPercentage,
      'status': status,
      'last_accessed': lastAccessed?.toIso8601String(),
      'certificate_id': certificateId,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// نسخ مع تعديل
  EnrollmentModel copyWith({
    String? id,
    String? studentId,
    String? courseId,
    DateTime? enrollmentDate,
    int? completionPercentage,
    String? status,
    DateTime? lastAccessed,
    String? certificateId,
    DateTime? completedAt,
    CourseModel? course,
  }) {
    return EnrollmentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      status: status ?? this.status,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      certificateId: certificateId ?? this.certificateId,
      completedAt: completedAt ?? this.completedAt,
      course: course ?? this.course,
    );
  }

  /// التحقق من الحالة
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isDropped => status == 'dropped';
  bool get hasCertificate => certificateId != null;

  @override
  List<Object?> get props => [
        id,
        studentId,
        courseId,
        enrollmentDate,
        completionPercentage,
        status,
        lastAccessed,
        certificateId,
        completedAt,
        course,
      ];
}
