import 'package:equatable/equatable.dart';

/// كيان الإشعار
class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // course, exam, certificate, payment, system
  final String? relatedId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        message,
        type,
        relatedId,
        isRead,
        createdAt,
      ];
}
