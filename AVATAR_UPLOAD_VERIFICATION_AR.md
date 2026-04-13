# التحقق من رفع الصورة الشخصية

## الكود الحالي ✅

الكود موجود وصحيح في:
- `lib/features/profile/data/datasources/profile_remote_datasource.dart`
- `lib/features/profile/presentation/pages/profile_page.dart`

## المتطلبات في Supabase

### 1. Bucket موجود ✅

الـ bucket باسم `avatars` موجود بالفعل.

### 2. إعداد الصلاحيات (Policies)

تأكد من وجود هذه الـ policies للـ bucket:

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

## كيفية الاختبار

### 1. من التطبيق
1. افتح صفحة البروفايل
2. اضغط على أيقونة الكاميرا على الصورة الشخصية
3. اختر صورة من المعرض
4. انتظر رسالة "تم تحديث الصورة الشخصية"
5. يجب أن تظهر الصورة الجديدة

### 2. من Supabase Dashboard
1. اذهب إلى Storage → avatars
2. يجب أن ترى ملفات بأسماء مثل: `user-id-timestamp.jpg`

## استكشاف الأخطاء

### خطأ: "Bucket not found"
**الحل**: تأكد من وجود bucket باسم `avatars` في Supabase Storage

### خطأ: "Permission denied"
**الحل**: أضف الـ policies المذكورة أعلاه

### خطأ: "File too large"
**الحل**: الكود يضغط الصورة إلى 1024x1024 بجودة 85%، يجب أن يكون كافياً

### الصورة لا تظهر
**الحل**: 
1. تأكد أن الـ bucket public
2. تأكد من تحديث avatar_url في جدول users
3. تحقق من الـ URL في قاعدة البيانات

## الكود المستخدم

### في profile_page.dart
```dart
Future<void> _pickAndUploadImage(String userId) async {
  try {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      final File imageFile = File(image.path);
      context.read<ProfileBloc>().add(
        UploadAvatarEvent(
          userId: userId,
          imageFile: imageFile,
        ),
      );
    }
  } catch (e) {
    Helpers.showErrorSnackbar(context, 'فشل اختيار الصورة');
  }
}
```

### في profile_remote_datasource.dart
```dart
Future<String> uploadAvatar(String userId, File imageFile) async {
  try {
    final fileExt = imageFile.path.split('.').last;
    final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = fileName;

    // رفع الصورة
    await supabaseClient.storage.from('avatars').upload(
      filePath,
      imageFile,
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: false,
      ),
    );

    // الحصول على الرابط
    final imageUrl = supabaseClient.storage
        .from('avatars')
        .getPublicUrl(filePath);

    // تحديث قاعدة البيانات
    await supabaseClient.from('users').update({
      'avatar_url': imageUrl,
      'profile_image_url': imageUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    return imageUrl;
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}
```

## الخلاصة

✅ الكود تم تحديثه ليستخدم bucket `avatars`
✅ الـ bucket موجود في Supabase
⚠️ تحقق من وجود policies للصلاحيات

بعد إضافة الـ policies، يجب أن تعمل وظيفة رفع الصورة بنجاح!
