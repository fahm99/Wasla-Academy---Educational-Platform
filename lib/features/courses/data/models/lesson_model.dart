import 'package:equatable/equatable.dart';

/// نموذج الدرس
class LessonModel extends Equatable {
  final String id;
  final String moduleId;
  final String courseId;
  final String title;
  final String? description;
  final int orderNumber;
  final String? lessonType;
  final String? videoUrl;
  final int? videoDuration;
  final String? content;
  final bool isFree;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LessonModel({
    required this.id,
    required this.moduleId,
    required this.courseId,
    required this.title,
    this.description,
    required this.orderNumber,
    this.lessonType,
    this.videoUrl,
    this.videoDuration,
    this.content,
    this.isFree = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// إنشاء من JSON
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      orderNumber: json['order_number'] as int,
      lessonType: json['lesson_type'] as String?,
      videoUrl: json['video_url'] as String?,
      videoDuration: json['video_duration'] as int?,
      content: json['content'] as String?,
      isFree: json['is_free'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'course_id': courseId,
      'title': title,
      'description': description,
      'order_number': orderNumber,
      'lesson_type': lessonType,
      'video_url': videoUrl,
      'video_duration': videoDuration,
      'content': content,
      'is_free': isFree,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// التحقق من نوع الدرس
  bool get isVideo => lessonType == 'video';
  bool get isText => lessonType == 'text';
  bool get isFile => lessonType == 'file';
  bool get isQuiz => lessonType == 'quiz';

  @override
  List<Object?> get props => [
        id,
        moduleId,
        courseId,
        title,
        description,
        orderNumber,
        lessonType,
        videoUrl,
        videoDuration,
        content,
        isFree,
        createdAt,
        updatedAt,
      ];
}
