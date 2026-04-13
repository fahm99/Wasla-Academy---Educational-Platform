# تعليمات بناء تطبيق وصلة أكاديمي

## المتطلبات الأساسية
- Flutter SDK (الإصدار 3.0 أو أحدث)
- Android Studio أو VS Code
- Java JDK 11 أو أحدث

## خطوات بناء APK

### الطريقة الأولى: استخدام ملف Batch (الأسهل)
1. افتح Command Prompt في مجلد المشروع
2. قم بتشغيل الأمر:
```bash
build_apk.bat
```
3. انتظر حتى يكتمل البناء
4. ستجد ملفات APK في المجلد: `build/app/outputs/flutter-apk/`

### الطريقة الثانية: الأوامر اليدوية

#### 1. تنظيف المشروع
```bash
flutter clean
```

#### 2. جلب المكتبات
```bash
flutter pub get
```

#### 3. توليد مفتاح التوقيع (مرة واحدة فقط)
```bash
keytool -genkey -v -keystore android/app/wasla-key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias wasla
```
معلومات المفتاح:
- Store Password: wasla123
- Key Password: wasla123
- Key Alias: wasla

#### 4. بناء APK
```bash
# بناء APK واحد لجميع المعماريات
flutter build apk --release

# أو بناء APK منفصل لكل معمارية (حجم أصغر)
flutter build apk --release --split-per-abi
```

## ملفات APK الناتجة

عند استخدام `--split-per-abi`، ستحصل على:
- `app-armeabi-v7a-release.apk` - للأجهزة القديمة (32-bit ARM)
- `app-arm64-v8a-release.apk` - للأجهزة الحديثة (64-bit ARM) - الأكثر شيوعاً
- `app-x86_64-release.apk` - للمحاكيات والأجهزة x86

## الأذونات المضافة

تم إضافة الأذونات التالية في AndroidManifest.xml:
- ✅ INTERNET - للاتصال بالإنترنت
- ✅ ACCESS_NETWORK_STATE - للتحقق من حالة الشبكة
- ✅ READ_EXTERNAL_STORAGE - لقراءة الملفات
- ✅ WRITE_EXTERNAL_STORAGE - لكتابة الملفات (Android 12 وأقل)
- ✅ CAMERA - لالتقاط الصور
- ✅ READ_MEDIA_IMAGES - لقراءة الصور (Android 13+)
- ✅ READ_MEDIA_VIDEO - لقراءة الفيديوهات (Android 13+)

## الإصلاحات المطبقة

### 1. إصلاح مشكلة Gradle
- ✅ إزالة `android.enableBuildCache=true` من gradle.properties
- ✅ تحديث إعدادات Gradle

### 2. معالجة الأخطاء
- ✅ إضافة معالج أخطاء عام في main.dart
- ✅ معالجة أخطاء تهيئة Supabase
- ✅ معالجة أخطاء Dependency Injection

### 3. تحسينات الأداء
- ✅ تفعيل R8 optimization
- ✅ تفعيل ProGuard للإصدار النهائي
- ✅ تقليل حجم APK بفصل المعماريات

## استكشاف الأخطاء

### مشكلة: "android.enableBuildCache is deprecated"
✅ تم الحل: تمت إزالة الخيار من gradle.properties

### مشكلة: التطبيق يغلق فور فتحه
✅ تم الحل: إضافة معالجة شاملة للأخطاء في main.dart

### مشكلة: خطأ في الاتصال بالإنترنت
✅ تم الحل: إضافة جميع أذونات الإنترنت المطلوبة

## ملاحظات مهمة

1. **ملف .env**: تأكد من وجود ملف `.env` يحتوي على:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

2. **مفتاح التوقيع**: احتفظ بملف `wasla-key.jks` في مكان آمن - ستحتاجه لتحديثات التطبيق المستقبلية

3. **حجم APK**: استخدم `--split-per-abi` لتقليل حجم APK من ~50MB إلى ~20MB لكل معمارية

4. **الاختبار**: اختبر التطبيق على أجهزة حقيقية قبل النشر

## التوزيع

بعد بناء APK بنجاح:
1. اختبر التطبيق على أجهزة مختلفة
2. يمكنك رفع `app-arm64-v8a-release.apk` للأجهزة الحديثة
3. للنشر على Google Play Store، استخدم:
```bash
flutter build appbundle --release
```

## الدعم

في حالة وجود مشاكل:
1. تحقق من سجلات الأخطاء: `flutter logs`
2. نظف المشروع: `flutter clean && flutter pub get`
3. تحقق من إصدار Flutter: `flutter doctor -v`
