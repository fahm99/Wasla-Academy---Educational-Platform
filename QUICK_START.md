# 🚀 دليل البدء السريع

## خطوات تشغيل التطبيق

### 1. التأكد من المتطلبات ✅

```bash
# التحقق من Flutter
flutter --version

# يجب أن يكون الإصدار 3.4.3 أو أحدث
```

### 2. تثبيت المكتبات 📦

```bash
# في مجلد المشروع
flutter pub get
```

### 3. تشغيل التطبيق 🎯

```bash
# للأندرويد
flutter run

# أو لجهاز محدد
flutter run -d <device-id>

# لعرض الأجهزة المتاحة
flutter devices
```

---

## 🎨 اختبار الميزات

### تسجيل الدخول التجريبي:
- **البريد**: test@example.com
- **كلمة المرور**: أي شيء (للتجربة)

### الميزات المتاحة:
- ✅ تصفح الكورسات (6 كورسات)
- ✅ عرض تفاصيل الكورس
- ✅ المحاضرات المباشرة
- ✅ الإشعارات
- ✅ المناقشات
- ✅ الملف الشخصي
- ✅ الإنجازات
- ✅ البحث والتصفية

---

## 📁 البيانات التجريبية

جميع البيانات موجودة في `assets/data/`:
- `courses.json` - 6 كورسات
- `categories.json` - 6 تصنيفات
- `providers.json` - 6 مقدمين
- `live_lectures.json` - 3 محاضرات
- `notifications.json` - 5 إشعارات
- `discussions.json` - 2 مناقشة
- `achievements.json` - 5 إنجازات

---

## 🔧 التخصيص

### تغيير الألوان:
```dart
// في lib/src/constants/app_colors.dart
static const Color primary = Color(0xFF6366F1);
```

### إضافة كورس جديد:
```json
// في assets/data/courses.json
{
  "id": 7,
  "title": "كورس جديد",
  "description": "وصف الكورس",
  // ... باقي الحقول
}
```

---

## 🐛 حل المشاكل

### مشكلة: "No devices found"
```bash
# تأكد من تشغيل المحاكي أو توصيل الجهاز
flutter devices
```

### مشكلة: "Packages not found"
```bash
flutter clean
flutter pub get
```

### مشكلة: "Build failed"
```bash
# تحديث Flutter
flutter upgrade

# إعادة البناء
flutter clean
flutter pub get
flutter run
```

---

## 📱 البناء للإنتاج

### Android APK:
```bash
flutter build apk --release
# الملف في: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle:
```bash
flutter build appbundle --release
# الملف في: build/app/outputs/bundle/release/app-release.aab
```

---

## 📚 الوثائق الكاملة

- [خطة التطوير](DEVELOPMENT_PLAN.md)
- [دليل Supabase](SUPABASE_INTEGRATION_GUIDE.md)
- [ملخص التغييرات](CHANGES_SUMMARY.md)
- [الإكمال النهائي](IMPLEMENTATION_COMPLETE.md)

---

## 💡 نصائح

1. استخدم Hot Reload (r) أثناء التطوير
2. استخدم Hot Restart (R) عند تغيير البيانات
3. راجع الوثائق للميزات المتقدمة
4. اختبر على أجهزة مختلفة

---

**استمتع بالتطوير! 🎉**
