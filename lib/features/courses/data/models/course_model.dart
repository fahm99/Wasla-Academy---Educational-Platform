import 'package:equatable/equatable.dart';

/// نموذج الكورس
class CourseModel extends Equatable {
  final String id;
  final String providerId;
  final String title;
  final String description;
  final String? category;
  final String? level;
  final double price;
  final String currency;
  final int? durationHours;
  final String? thumbnailUrl;
  final String? coverImageUrl;
  final Map<String, dynamic>? certificateTemplate;

  // حقول الشهادات المخصصة
  final bool certificateAutoIssue;
  final String? certificateLogoUrl;
  final String? certificateSignatureUrl;
  final String? certificateCustomColor;

  final String status;
  final int studentsCount;
  final double rating;
  final int reviewsCount;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  // معلومات المقدم (من Join)
  final String? providerName;
  final String? providerAvatar;

  const CourseModel({
    required this.id,
    required this.providerId,
    required this.title,
    required this.description,
    this.category,
    this.level,
    required this.price,
    this.currency = 'SAR',
    this.durationHours,
    this.thumbnailUrl,
    this.coverImageUrl,
    this.certificateTemplate,
    this.certificateAutoIssue = false,
    this.certificateLogoUrl,
    this.certificateSignatureUrl,
    this.certificateCustomColor,
    this.status = 'draft',
    this.studentsCount = 0,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
    this.providerName,
    this.providerAvatar,
  });

  /// إنشاء من JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String?,
      level: json['level'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'SAR',
      durationHours: json['duration_hours'] as int?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      certificateTemplate:
          json['certificate_template'] as Map<String, dynamic>?,
      certificateAutoIssue: json['certificate_auto_issue'] as bool? ?? false,
      certificateLogoUrl: json['certificate_logo_url'] as String?,
      certificateSignatureUrl: json['certificate_signature_url'] as String?,
      certificateCustomColor: json['certificate_custom_color'] as String?,
      status: json['status'] as String? ?? 'draft',
      studentsCount: json['students_count'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      providerName: json['provider']?['name'] as String?,
      providerAvatar: json['provider']?['avatar_url'] as String?,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'title': title,
      'description': description,
      'category': category,
      'level': level,
      'price': price,
      'currency': currency,
      'duration_hours': durationHours,
      'thumbnail_url': thumbnailUrl,
      'cover_image_url': coverImageUrl,
      'certificate_template': certificateTemplate,
      'certificate_auto_issue': certificateAutoIssue,
      'certificate_logo_url': certificateLogoUrl,
      'certificate_signature_url': certificateSignatureUrl,
      'certificate_custom_color': certificateCustomColor,
      'status': status,
      'students_count': studentsCount,
      'rating': rating,
      'reviews_count': reviewsCount,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// نسخ مع تعديل
  CourseModel copyWith({
    String? id,
    String? providerId,
    String? title,
    String? description,
    String? category,
    String? level,
    double? price,
    String? currency,
    int? durationHours,
    String? thumbnailUrl,
    String? coverImageUrl,
    Map<String, dynamic>? certificateTemplate,
    bool? certificateAutoIssue,
    String? certificateLogoUrl,
    String? certificateSignatureUrl,
    String? certificateCustomColor,
    String? status,
    int? studentsCount,
    double? rating,
    int? reviewsCount,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? providerName,
    String? providerAvatar,
  }) {
    return CourseModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      level: level ?? this.level,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      durationHours: durationHours ?? this.durationHours,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      certificateTemplate: certificateTemplate ?? this.certificateTemplate,
      certificateAutoIssue: certificateAutoIssue ?? this.certificateAutoIssue,
      certificateLogoUrl: certificateLogoUrl ?? this.certificateLogoUrl,
      certificateSignatureUrl:
          certificateSignatureUrl ?? this.certificateSignatureUrl,
      certificateCustomColor:
          certificateCustomColor ?? this.certificateCustomColor,
      status: status ?? this.status,
      studentsCount: studentsCount ?? this.studentsCount,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      providerName: providerName ?? this.providerName,
      providerAvatar: providerAvatar ?? this.providerAvatar,
    );
  }

  /// التحقق من نوع الكورس
  bool get isFree => price == 0;
  bool get isPublished => status == 'published';
  bool get isDraft => status == 'draft';

  /// الحصول على الصورة
  String? get displayImage => coverImageUrl ?? thumbnailUrl;

  @override
  List<Object?> get props => [
        id,
        providerId,
        title,
        description,
        category,
        level,
        price,
        currency,
        durationHours,
        thumbnailUrl,
        coverImageUrl,
        certificateTemplate,
        certificateAutoIssue,
        certificateLogoUrl,
        certificateSignatureUrl,
        certificateCustomColor,
        status,
        studentsCount,
        rating,
        reviewsCount,
        isFeatured,
        createdAt,
        updatedAt,
        providerName,
        providerAvatar,
      ];
}
