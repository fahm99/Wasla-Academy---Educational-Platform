# دليل الربط مع Supabase

## 📋 نظرة عامة
هذا الدليل يشرح كيفية ربط تطبيق وصلة أكاديمي مع قاعدة بيانات Supabase.

---

## 🚀 الخطوات الأولية

### 1. إنشاء مشروع Supabase

1. اذهب إلى [Supabase Dashboard](https://app.supabase.com)
2. قم بإنشاء حساب جديد أو تسجيل الدخول
3. انقر على "New Project"
4. أدخل معلومات المشروع:
   - اسم المشروع: `wasla-academy`
   - كلمة مرور قاعدة البيانات (احفظها بأمان)
   - المنطقة: اختر الأقرب لك

### 2. تنفيذ SQL Schema

1. في Supabase Dashboard، اذهب إلى "SQL Editor"
2. افتح ملف `supabasedatabase.sql` من المشروع
3. انسخ المحتوى بالكامل
4. الصقه في SQL Editor
5. انقر على "Run" لتنفيذ الأوامر

### 3. الحصول على مفاتيح API

1. اذهب إلى "Settings" > "API"
2. انسخ:
   - `Project URL`
   - `anon public` key

---

## 📦 إضافة المكتبات المطلوبة

### 1. تحديث pubspec.yaml

```yaml
dependencies:
  # المكتبات الموجودة...
  
  # إضافة Supabase
  supabase_flutter: ^2.0.0
  
  # مكتبات مساعدة
  shared_preferences: ^2.2.2
  connectivity_plus: ^5.0.2
  dio: ^5.4.0
  get_it: ^7.6.4
  logger: ^2.0.2
```

### 2. تثبيت المكتبات

```bash
flutter pub get
```

---

## ⚙️ التكوين

### 1. تحديث ملف التكوين

افتح `lib/src/config/supabase_config.dart` وحدث القيم:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_PROJECT_URL'; // من Supabase Dashboard
  static const String supabaseAnonKey = 'YOUR_ANON_KEY'; // من Supabase Dashboard
}
```

### 2. تهيئة Supabase في التطبيق

في `lib/main.dart`، أضف:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waslaacademy/src/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const MyApp());
}
```

---

## 🔐 Authentication (المصادقة)

### تسجيل الدخول

```dart
final response = await Supabase.instance.client.auth.signInWithPassword(
  email: email,
  password: password,
);

if (response.user != null) {
  // تسجيل دخول ناجح
  print('User ID: ${response.user!.id}');
}
```

### التسجيل

```dart
final response = await Supabase.instance.client.auth.signUp(
  email: email,
  password: password,
  data: {
    'full_name': name,
    'phone': phone,
  },
);
```

### تسجيل الخروج

```dart
await Supabase.instance.client.auth.signOut();
```

---

## 📊 قراءة البيانات

### جلب جميع الكورسات

```dart
final response = await Supabase.instance.client
    .from('courses')
    .select('*, provider_profiles(*)')
    .eq('status', 'published')
    .order('created_at', ascending: false);

List<Course> courses = (response as List)
    .map((json) => Course.fromJson(json))
    .toList();
```

### جلب كورس محدد

```dart
final response = await Supabase.instance.client
    .from('courses')
    .select('*, lessons(*), exams(*)')
    .eq('id', courseId)
    .single();

Course course = Course.fromJson(response);
```

### جلب كورسات المستخدم

```dart
final response = await Supabase.instance.client
    .from('enrollments')
    .select('*, courses(*)')
    .eq('user_id', userId)
    .eq('status', 'active');
```

---

## ✍️ كتابة البيانات

### التسجيل في كورس

```dart
await Supabase.instance.client.from('enrollments').insert({
  'user_id': userId,
  'course_id': courseId,
  'status': 'active',
});
```

### تحديث تقدم الدرس

```dart
await Supabase.instance.client.from('lesson_progress').upsert({
  'user_id': userId,
  'lesson_id': lessonId,
  'enrollment_id': enrollmentId,
  'is_completed': true,
  'completion_date': DateTime.now().toIso8601String(),
});
```

### إضافة تقييم

```dart
await Supabase.instance.client.from('course_reviews').insert({
  'user_id': userId,
  'course_id': courseId,
  'enrollment_id': enrollmentId,
  'rating': rating,
  'review_comment': comment,
});
```

---

## 📁 Storage (التخزين)

### رفع صورة الملف الشخصي

```dart
final file = File(imagePath);
final bytes = await file.readAsBytes();

await Supabase.instance.client.storage
    .from('avatars')
    .uploadBinary(
      '$userId/avatar.jpg',
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

// الحصول على رابط الصورة
final imageUrl = Supabase.instance.client.storage
    .from('avatars')
    .getPublicUrl('$userId/avatar.jpg');
```

### رفع ملف كورس

```dart
await Supabase.instance.client.storage
    .from('resources')
    .uploadBinary(
      'courses/$courseId/$fileName',
      fileBytes,
    );
```

---

## 🔔 Real-time Subscriptions

### الاستماع للإشعارات الجديدة

```dart
final subscription = Supabase.instance.client
    .from('notifications')
    .stream(primaryKey: ['id'])
    .eq('recipient_id', userId)
    .listen((data) {
      // تحديث UI بالإشعارات الجديدة
      print('New notifications: ${data.length}');
    });

// إلغاء الاشتراك عند الخروج
subscription.cancel();
```

### الاستماع للرسائل الجديدة

```dart
Supabase.instance.client
    .from('messages')
    .stream(primaryKey: ['id'])
    .eq('conversation_id', conversationId)
    .listen((messages) {
      // تحديث قائمة الرسائل
    });
```

---

## 🔒 Row Level Security (RLS)

### تفعيل RLS للجداول

في SQL Editor، نفذ:

```sql
-- تفعيل RLS لجدول المستخدمين
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- السماح للمستخدمين بقراءة بياناتهم فقط
CREATE POLICY "Users can view own data"
ON users FOR SELECT
USING (auth.uid() = id);

-- السماح للمستخدمين بتحديث بياناتهم
CREATE POLICY "Users can update own data"
ON users FOR UPDATE
USING (auth.uid() = id);
```

---

## 🧪 الاختبار

### 1. اختبار الاتصال

```dart
try {
  final response = await Supabase.instance.client
      .from('courses')
      .select('count')
      .limit(1);
  print('Connection successful!');
} catch (e) {
  print('Connection failed: $e');
}
```

### 2. إضافة بيانات تجريبية

استخدم SQL Editor لإضافة بيانات تجريبية:

```sql
-- إضافة مستخدم تجريبي
INSERT INTO users (email, role) VALUES ('test@example.com', 'student');

-- إضافة كورس تجريبي
INSERT INTO courses (title, description, category_id, provider_id, status)
VALUES ('كورس تجريبي', 'وصف الكورس', 'uuid-here', 'uuid-here', 'published');
```

---

## 🐛 حل المشاكل الشائعة

### مشكلة: "Invalid API key"
- تأكد من نسخ المفاتيح بشكل صحيح
- تأكد من عدم وجود مسافات إضافية

### مشكلة: "Row Level Security"
- تأكد من تفعيل RLS policies المناسبة
- تحقق من صلاحيات المستخدم

### مشكلة: "CORS Error"
- في Supabase Dashboard > Authentication > URL Configuration
- أضف URL التطبيق إلى Allowed URLs

---

## 📚 موارد إضافية

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Supabase Storage Guide](https://supabase.com/docs/guides/storage)

---

## ✅ Checklist

- [ ] إنشاء مشروع Supabase
- [ ] تنفيذ SQL Schema
- [ ] نسخ مفاتيح API
- [ ] تحديث ملف التكوين
- [ ] إضافة مكتبة supabase_flutter
- [ ] تهيئة Supabase في main.dart
- [ ] اختبار الاتصال
- [ ] تفعيل RLS
- [ ] إضافة بيانات تجريبية
- [ ] اختبار Authentication
- [ ] اختبار قراءة/كتابة البيانات

---

تم إعداد هذا الدليل بتاريخ: 2 أكتوبر 2025
