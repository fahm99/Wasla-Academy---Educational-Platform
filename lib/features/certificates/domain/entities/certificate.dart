import 'package:equatable/equatable.dart';

/// كيان الشهادة
class Certificate extends Equatable {
  final String id;
  final String courseId;
  final String studentId;
  final String providerId;
  final String certificateNumber;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final Map<String, dynamic>? templateDesign;
  final String? certificateUrl;
  final String status;
  final DateTime createdAt;

  // حقول التخصيص الجديدة
  final String? providerLogoUrl;
  final String? providerSignatureUrl;
  final String? customColor;
  final bool autoIssue;
  final String? grade;
  final DateTime? completionDate;

  // معلومات إضافية من Join
  final String? courseName;
  final String? studentName;
  final String? providerName;

  const Certificate({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.providerId,
    required this.certificateNumber,
    required this.issueDate,
    this.expiryDate,
    this.templateDesign,
    this.certificateUrl,
    required this.status,
    required this.createdAt,
    this.providerLogoUrl,
    this.providerSignatureUrl,
    this.customColor,
    this.autoIssue = false,
    this.grade,
    this.completionDate,
    this.courseName,
    this.studentName,
    this.providerName,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        studentId,
        providerId,
        certificateNumber,
        issueDate,
        expiryDate,
        templateDesign,
        certificateUrl,
        status,
        createdAt,
        providerLogoUrl,
        providerSignatureUrl,
        customColor,
        autoIssue,
        grade,
        completionDate,
        courseName,
        studentName,
        providerName,
      ];
}
