import 'package:equatable/equatable.dart';

/// كيان الملف الشخصي
class UserProfile extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatarUrl;
  final String? profileImageUrl;
  final String userType; // student, provider, admin
  final String? bio;
  final double rating;
  final bool isActive;
  final bool isVerified;

  // Student fields
  final int coursesEnrolled;
  final int certificatesCount;
  final double totalSpent;

  // Provider fields
  final int coursesCount;
  final int studentsCount;
  final double totalEarnings;

  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatarUrl,
    this.profileImageUrl,
    required this.userType,
    this.bio,
    required this.rating,
    required this.isActive,
    required this.isVerified,
    required this.coursesEnrolled,
    required this.certificatesCount,
    required this.totalSpent,
    required this.coursesCount,
    required this.studentsCount,
    required this.totalEarnings,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        avatarUrl,
        profileImageUrl,
        userType,
        bio,
        rating,
        isActive,
        isVerified,
        coursesEnrolled,
        certificatesCount,
        totalSpent,
        coursesCount,
        studentsCount,
        totalEarnings,
        createdAt,
        updatedAt,
      ];
}
