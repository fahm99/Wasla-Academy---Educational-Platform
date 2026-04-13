import 'dart:convert';

/// أداة للتحقق من صحة مفتاح Supabase JWT
void main() {
  const testKey = 'ضع_المفتاح_هنا_للاختبار';

  print('🔍 فحص مفتاح Supabase...\n');

  if (testKey == 'ضع_المفتاح_هنا_للاختبار') {
    print('❌ يرجى وضع المفتاح الفعلي في المتغير testKey');
    return;
  }

  // التحقق من البنية الأساسية
  final parts = testKey.split('.');

  if (parts.length != 3) {
    print('❌ المفتاح غير صحيح: يجب أن يحتوي على 3 أجزاء مفصولة بنقطة');
    print('   عدد الأجزاء الحالي: ${parts.length}');
    return;
  }

  print('✅ البنية الأساسية صحيحة (3 أجزاء)\n');

  // فك تشفير Header
  try {
    final headerDecoded =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[0])));
    print('📋 Header:');
    print('   $headerDecoded\n');

    final header = json.decode(headerDecoded);
    if (header['alg'] == 'HS256' && header['typ'] == 'JWT') {
      print('✅ Header صحيح\n');
    } else {
      print('⚠️  Header غير متوقع\n');
    }
  } catch (e) {
    print('❌ خطأ في فك تشفير Header: $e\n');
  }

  // فك تشفير Payload
  try {
    final payloadDecoded =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    print('📋 Payload:');
    print('   $payloadDecoded\n');

    final payload = json.decode(payloadDecoded);

    // التحقق من الحقول المطلوبة
    final requiredFields = ['iss', 'ref', 'role', 'iat', 'exp'];
    var allFieldsPresent = true;

    for (final field in requiredFields) {
      if (payload.containsKey(field)) {
        print('   ✅ $field: ${payload[field]}');
      } else {
        print('   ❌ $field: مفقود');
        allFieldsPresent = false;
      }
    }

    if (allFieldsPresent) {
      print('\n✅ جميع الحقول المطلوبة موجودة');

      // التحقق من القيم
      if (payload['iss'] == 'supabase') {
        print('✅ Issuer صحيح (supabase)');
      }

      if (payload['ref'] == 'hmgisljihrsztskvmbfd') {
        print('✅ Project Reference صحيح');
      } else {
        print(
            '⚠️  Project Reference: ${payload['ref']} (متوقع: hmgisljihrsztskvmbfd)');
      }

      if (payload['role'] == 'anon') {
        print('✅ Role صحيح (anon)');
      } else {
        print('⚠️  Role: ${payload['role']} (متوقع: anon)');
      }

      // التحقق من تاريخ الانتهاء
      final exp = payload['exp'] as int;
      final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      if (expDate.isAfter(now)) {
        print('✅ المفتاح صالح حتى: $expDate');
      } else {
        print('❌ المفتاح منتهي الصلاحية منذ: $expDate');
      }
    }
  } catch (e) {
    print('❌ خطأ في فك تشفير Payload: $e\n');
  }

  // التحقق من Signature
  print('\n📋 Signature:');
  print('   الطول: ${parts[2].length} حرف');

  if (parts[2].length > 20) {
    print('✅ Signature يبدو صحيحاً\n');
  } else {
    print('⚠️  Signature قصير جداً\n');
  }

  print('=' * 50);
  print('📝 الخلاصة:');
  print('   طول المفتاح الكامل: ${testKey.length} حرف');

  if (testKey.length > 200 && parts.length == 3) {
    print('   ✅ المفتاح يبدو صحيحاً!');
    print('\n💡 يمكنك الآن نسخه إلى lib/core/config/supabase_config.dart');
  } else {
    print('   ⚠️  المفتاح قد يكون غير صحيح');
    print('   يجب أن يكون طول المفتاح أكثر من 200 حرف');
  }
}
