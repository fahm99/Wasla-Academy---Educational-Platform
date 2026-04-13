import '../../domain/entities/certificate.dart';

/// نموذج الشهادة
class CertificateModel extends Certificate {
  const CertificateModel({
    required super.id,
    required super.courseId,
    required super.studentId,
    required super.providerId,
    required super.certificateNumber,
    required super.issueDate,
    super.expiryDate,
    super.templateDesign,
    super.certificateUrl,
    required super.status,
    required super.createdAt,
    super.providerLogoUrl,
    super.providerSignatureUrl,
    super.customColor,
    super.autoIssue,
    super.grade,
    super.completionDate,
    super.courseName,
    super.studentName,
    super.providerName,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      studentId: json['student_id'] as String,
      providerId: json['provider_id'] as String,
      certificateNumber: json['certificate_number'] as String,
      issueDate: DateTime.parse(json['issue_date'] as String),
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      templateDesign: json['template_design'] as Map<String, dynamic>?,
      certificateUrl: json['certificate_url'] as String?,
      status: json['status'] as String? ?? 'issued',
      createdAt: DateTime.parse(json['created_at'] as String),
      providerLogoUrl: json['provider_logo_url'] as String?,
      providerSignatureUrl: json['provider_signature_url'] as String?,
      customColor: json['custom_color'] as String?,
      autoIssue: json['auto_issue'] as bool? ?? false,
      grade: json['grade'] as String?,
      completionDate: json['completion_date'] != null
          ? DateTime.parse(json['completion_date'] as String)
          : null,
      courseName: json['courses']?['title'] as String?,
      studentName: json['students']?['name'] as String?,
      providerName: json['providers']?['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'student_id': studentId,
      'provider_id': providerId,
      'certificate_number': certificateNumber,
      'issue_date': issueDate.toIso8601String(),
      if (expiryDate != null) 'expiry_date': expiryDate!.toIso8601String(),
      'template_design': templateDesign,
      'certificate_url': certificateUrl,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'provider_logo_url': providerLogoUrl,
      'provider_signature_url': providerSignatureUrl,
      'custom_color': customColor,
      'auto_issue': autoIssue,
      'grade': grade,
      if (completionDate != null)
        'completion_date': completionDate!.toIso8601String(),
    };
  }

  CertificateModel copyWith({
    String? id,
    String? courseId,
    String? studentId,
    String? providerId,
    String? certificateNumber,
    DateTime? issueDate,
    DateTime? expiryDate,
    Map<String, dynamic>? templateDesign,
    String? certificateUrl,
    String? status,
    DateTime? createdAt,
    String? providerLogoUrl,
    String? providerSignatureUrl,
    String? customColor,
    bool? autoIssue,
    String? grade,
    DateTime? completionDate,
    String? courseName,
    String? studentName,
    String? providerName,
  }) {
    return CertificateModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      studentId: studentId ?? this.studentId,
      providerId: providerId ?? this.providerId,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      templateDesign: templateDesign ?? this.templateDesign,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      providerLogoUrl: providerLogoUrl ?? this.providerLogoUrl,
      providerSignatureUrl: providerSignatureUrl ?? this.providerSignatureUrl,
      customColor: customColor ?? this.customColor,
      autoIssue: autoIssue ?? this.autoIssue,
      grade: grade ?? this.grade,
      completionDate: completionDate ?? this.completionDate,
      courseName: courseName ?? this.courseName,
      studentName: studentName ?? this.studentName,
      providerName: providerName ?? this.providerName,
    );
  }
}
