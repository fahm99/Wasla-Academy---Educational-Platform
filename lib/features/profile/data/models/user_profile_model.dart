import '../../domain/entities/user_profile.dart';

/// نموذج الملف الشخصي
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    required super.name,
    super.phone,
    super.avatarUrl,
    super.profileImageUrl,
    required super.userType,
    super.bio,
    required super.rating,
    required super.isActive,
    required super.isVerified,
    required super.coursesEnrolled,
    required super.certificatesCount,
    required super.totalSpent,
    required super.coursesCount,
    required super.studentsCount,
    required super.totalEarnings,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      userType: json['user_type'] as String,
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      coursesEnrolled: json['courses_enrolled'] as int? ?? 0,
      certificatesCount: json['certificates_count'] as int? ?? 0,
      totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0.0,
      coursesCount: json['courses_count'] as int? ?? 0,
      studentsCount: json['students_count'] as int? ?? 0,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      'user_type': userType,
      if (bio != null) 'bio': bio,
      'rating': rating,
      'is_active': isActive,
      'is_verified': isVerified,
      'courses_enrolled': coursesEnrolled,
      'certificates_count': certificatesCount,
      'total_spent': totalSpent,
      'courses_count': coursesCount,
      'students_count': studentsCount,
      'total_earnings': totalEarnings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatarUrl,
    String? profileImageUrl,
    String? userType,
    String? bio,
    double? rating,
    bool? isActive,
    bool? isVerified,
    int? coursesEnrolled,
    int? certificatesCount,
    double? totalSpent,
    int? coursesCount,
    int? studentsCount,
    double? totalEarnings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      coursesEnrolled: coursesEnrolled ?? this.coursesEnrolled,
      certificatesCount: certificatesCount ?? this.certificatesCount,
      totalSpent: totalSpent ?? this.totalSpent,
      coursesCount: coursesCount ?? this.coursesCount,
      studentsCount: studentsCount ?? this.studentsCount,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
