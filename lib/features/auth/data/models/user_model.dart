import 'package:equatable/equatable.dart';

/// نموذج المستخدم
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatarUrl;
  final String? profileImageUrl;
  final String userType;
  final String? bio;
  final double rating;
  final bool isActive;
  final bool isVerified;

  // حقول الطالب
  final int coursesEnrolled;
  final int certificatesCount;
  final double totalSpent;

  // حقول مقدم الخدمة
  final int coursesCount;
  final int studentsCount;
  final double totalEarnings;
  final Map<String, dynamic>? bankAccount;

  // حقول الإدمن
  final Map<String, dynamic>? permissions;
  final DateTime? lastLogin;

  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatarUrl,
    this.profileImageUrl,
    required this.userType,
    this.bio,
    this.rating = 0.0,
    this.isActive = true,
    this.isVerified = false,
    this.coursesEnrolled = 0,
    this.certificatesCount = 0,
    this.totalSpent = 0.0,
    this.coursesCount = 0,
    this.studentsCount = 0,
    this.totalEarnings = 0.0,
    this.bankAccount,
    this.permissions,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  /// إنشاء من JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
      bankAccount: json['bank_account'] as Map<String, dynamic>?,
      permissions: json['permissions'] as Map<String, dynamic>?,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar_url': avatarUrl,
      'profile_image_url': profileImageUrl,
      'user_type': userType,
      'bio': bio,
      'rating': rating,
      'is_active': isActive,
      'is_verified': isVerified,
      'courses_enrolled': coursesEnrolled,
      'certificates_count': certificatesCount,
      'total_spent': totalSpent,
      'courses_count': coursesCount,
      'students_count': studentsCount,
      'total_earnings': totalEarnings,
      'bank_account': bankAccount,
      'permissions': permissions,
      'last_login': lastLogin?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// نسخ مع تعديل
  UserModel copyWith({
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
    Map<String, dynamic>? bankAccount,
    Map<String, dynamic>? permissions,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
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
      bankAccount: bankAccount ?? this.bankAccount,
      permissions: permissions ?? this.permissions,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// التحقق من نوع المستخدم
  bool get isStudent => userType == 'student';
  bool get isProvider => userType == 'provider';
  bool get isAdmin => userType == 'admin';

  /// الحصول على الصورة الشخصية
  String? get displayAvatar => profileImageUrl ?? avatarUrl;

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
        bankAccount,
        permissions,
        lastLogin,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, userType: $userType)';
  }
}
