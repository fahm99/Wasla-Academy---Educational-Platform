# إصلاح رفع الصورة الشخصية

## ✅ التحديثات المطبقة

تم تحديث الكود ليستخدم bucket `avatars` بدلاً من `profiles`:

### 1. تحديث uploadAvatar()
```dart
// قبل
await supabaseClient.storage.from('profiles').upload('avatars/$fileName', ...)

// بعد
await supabaseClient.storage.from('avatars').upload(fileName, ...)
```

### 2. تحديث deleteAvatar()
```dart
// قبل
await supabaseClient.storage.from('profiles').remove(['avatars/$filePath'])

// بعد
await supabaseClient.storage.from('avatars').remove([filePath])
```

### 3. تبسيط مسار الملف
```dart
// قبل
final filePath = 'avatars/$fileName';

// بعد
final filePath = fileName;
```

## 📋 الـ Policies المطلوبة

نفذ هذه الـ SQL في Supabase Dashboard:

```sql
-- السماح للمستخدمين برفع صورهم
CREATE POLICY "Users can upload their own avatar"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'avatars' 
  AND auth.uid()::text = (regexp_split_to_array(name, '-'))[1]
);

-- السماح للجميع بقراءة الصور
CREATE POLICY "Anyone can view avatars"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'avatars');

-- السماح للمستخدمين بحذف صورهم
CREATE POLICY "Users can delete their own avatar"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'avatars'
  AND auth.uid()::text = (regexp_split_to_array(name, '-'))[1]
);

-- السماح للمستخدمين بتحديث صورهم
CREATE POLICY "Users can update their own avatar"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'avatars'
  AND auth.uid()::text = (regexp_split_to_array(name, '-'))[1]
);
```

## 🧪 كيفية الاختبار

1. افتح التطبيق وسجل الدخول
2. اذهب إلى صفحة البروفايل
3. اضغط على أيقونة الكاميرا على الصورة الشخصية
4. اختر صورة من المعرض
5. انتظر رسالة "تم تحديث الصورة الشخصية"
6. يجب أن تظهر الصورة الجديدة فوراً

## 📁 بنية الملفات في Storage

```
avatars/
├── user-id-1234567890.jpg
├── user-id-1234567891.png
└── user-id-1234567892.jpg
```

كل ملف يبدأ بـ user ID متبوعاً بـ timestamp.

## ✅ الملفات المعدلة

- `lib/features/profile/data/datasources/profile_remote_datasource.dart`
- `AVATAR_UPLOAD_VERIFICATION_AR.md`

## 🎯 النتيجة

✅ الكود يستخدم bucket `avatars` الصحيح
✅ مسار الملفات مبسط
✅ جاهز للاختبار بعد إضافة الـ policies

فقط أضف الـ policies وجرب رفع الصورة!
