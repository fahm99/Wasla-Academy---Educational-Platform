import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/certificate_model.dart';

/// مصدر البيانات البعيد للشهادات
abstract class CertificatesRemoteDataSource {
  /// الحصول على شهادات الطالب
  Future<List<CertificateModel>> getMyCertificates(String studentId);

  /// الحصول على شهادة معينة
  Future<CertificateModel> getCertificate(String certificateId);

  /// التحقق من شهادة برقمها
  Future<CertificateModel?> verifyCertificate(String certificateNumber);

  /// إنشاء شهادة جديدة
  Future<CertificateModel> generateCertificate({
    required String courseId,
    required String studentId,
    required String providerId,
  });
}

class CertificatesRemoteDataSourceImpl implements CertificatesRemoteDataSource {
  final SupabaseClient supabaseClient;

  CertificatesRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<CertificateModel>> getMyCertificates(String studentId) async {
    try {
      final response = await supabaseClient
          .from('certificates')
          .select('''
            *,
            courses!inner(title),
            providers:provider_id(name)
          ''')
          .eq('student_id', studentId)
          .eq('status', 'issued')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => CertificateModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CertificateModel> getCertificate(String certificateId) async {
    try {
      final response = await supabaseClient.from('certificates').select('''
            *,
            courses!inner(title),
            students:student_id(name),
            providers:provider_id(name)
          ''').eq('id', certificateId).single();

      return CertificateModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CertificateModel?> verifyCertificate(String certificateNumber) async {
    try {
      final response = await supabaseClient.from('certificates').select('''
            *,
            courses!inner(title),
            students:student_id(name),
            providers:provider_id(name)
          ''').eq('certificate_number', certificateNumber).maybeSingle();

      if (response == null) return null;

      return CertificateModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CertificateModel> generateCertificate({
    required String courseId,
    required String studentId,
    required String providerId,
  }) async {
    try {
      // التحقق من عدم وجود شهادة سابقة
      final existing = await supabaseClient
          .from('certificates')
          .select()
          .eq('course_id', courseId)
          .eq('student_id', studentId)
          .maybeSingle();

      if (existing != null) {
        return CertificateModel.fromJson(existing);
      }

      // توليد رقم الشهادة
      final certificateNumber = _generateCertificateNumber();

      // إنشاء الشهادة
      final certificateData = {
        'course_id': courseId,
        'student_id': studentId,
        'provider_id': providerId,
        'certificate_number': certificateNumber,
        'issue_date': DateTime.now().toIso8601String(),
        'status': 'issued',
      };

      final response = await supabaseClient
          .from('certificates')
          .insert(certificateData)
          .select('''
            *,
            courses!inner(title),
            students:student_id(name),
            providers:provider_id(name)
          ''').single();

      return CertificateModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// توليد رقم شهادة فريد
  String _generateCertificateNumber() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final random = now.millisecondsSinceEpoch % 10000;

    return 'CERT-$year$month$day-${random.toString().padLeft(4, '0')}';
  }
}
