import 'package:equatable/equatable.dart';

/// نموذج الوحدة
class ModuleModel extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int orderNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ModuleModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.orderNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  /// إنشاء من JSON
  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      orderNumber: json['order_number'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'order_number': orderNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        title,
        description,
        orderNumber,
        createdAt,
        updatedAt,
      ];
}
