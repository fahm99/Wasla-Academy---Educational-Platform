import 'package:equatable/equatable.dart';

/// نموذج التقييم
class ReviewModel extends Equatable {
  final String id;
  final String courseId;
  final String studentId;
  final int rating; // 1-5
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  // معلومات إضافية من Join
  final String? studentName;
  final String? studentAvatar;

  const ReviewModel({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.studentName,
    this.studentAvatar,
  });

  /// إنشاء من JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      studentId: json['student_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      studentName: json['students']?['name'] as String?,
      studentAvatar: json['students']?['avatar_url'] as String?,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'student_id': studentId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// نسخ مع تعديل
  ReviewModel copyWith({
    String? id,
    String? courseId,
    String? studentId,
    int? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? studentName,
    String? studentAvatar,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      studentId: studentId ?? this.studentId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      studentName: studentName ?? this.studentName,
      studentAvatar: studentAvatar ?? this.studentAvatar,
    );
  }

  /// التحقق من صحة التقييم
  bool get isValidRating => rating >= 1 && rating <= 5;

  @override
  List<Object?> get props => [
        id,
        courseId,
        studentId,
        rating,
        comment,
        createdAt,
        updatedAt,
        studentName,
        studentAvatar,
      ];

  @override
  String toString() {
    return 'ReviewModel(id: $id, courseId: $courseId, rating: $rating)';
  }
}
