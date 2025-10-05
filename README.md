# منصة وصلة أكاديمي (Wasla Academy)

منصة تعليمية شاملة تربط الطلاب بالجامعات والمعاهد والمدربين في اليمن.

## 📱 عن التطبيق

وصلة أكاديمي هي منصة تعليمية إلكترونية متكاملة تهدف إلى:
- ربط الطلاب بمقدمي الخدمات التعليمية (جامعات، معاهد، مدربون)
- توفير كورسات تعليمية في مختلف المجالات
- إدارة المحاضرات المباشرة والامتحانات
- إصدار الشهادات الإلكترونية
- التواصل بين الطلاب والمدربين

## ✨ المميزات

### للطلاب
- ✅ تصفح الكورسات حسب الفئة والمستوى
- ✅ التسجيل في الكورسات المجانية والمدفوعة
- ✅ متابعة التقدم في الدروس
- ✅ حضور المحاضرات المباشرة
- ✅ إجراء الامتحانات والحصول على الشهادات
- ✅ المشاركة في المناقشات
- ✅ التواصل مع المدربين

### لمقدمي الخدمات
- ✅ إنشاء وإدارة الكورسات
- ✅ إضافة الدروس والموارد التعليمية
- ✅ إنشاء الامتحانات
- ✅ متابعة تقدم الطلاب
- ✅ إصدار الشهادات

## 🛠️ التقنيات المستخدمة

- **Framework**: Flutter 3.4.3+
- **State Management**: BLoC Pattern
- **Database**: Supabase (PostgreSQL)
- **Storage**: Supabase Storage
- **Authentication**: Supabase Auth
- **UI**: Material Design + Custom Components

## 📦 المكتبات الرئيسية

```yaml
dependencies:
  flutter_bloc: ^8.1.5          # إدارة الحالة
  equatable: ^2.0.5             # مقارنة الكائنات
  flutter_screenutil: ^5.9.0    # التصميم المتجاوب
  cached_network_image: ^3.3.1  # تخزين الصور مؤقتاً
  carousel_slider: ^4.2.1       # عرض الشرائح
  video_player: ^2.9.2          # تشغيل الفيديو
  intl: ^0.19.0                 # التنسيق والترجمة
```

## 🚀 البدء

### المتطلبات

- Flutter SDK 3.4.3 أو أحدث
- Dart SDK 3.0.0 أو أحدث
- Android Studio / VS Code
- حساب Supabase (للإنتاج)

### التثبيت

1. استنساخ المشروع:
```bash
git clone https://github.com/yourusername/waslaacademy.git
cd waslaacademy
```

2. تثبيت المكتبات:
```bash
flutter pub get
```

3. تشغيل التطبيق:
```bash
flutter run
```

## 🗂️ هيكل المشروع

```
lib/
├── src/
│   ├── blocs/              # إدارة الحالة (BLoC)
│   ├── config/             # ملفات التكوين
│   ├── constants/          # الثوابت والألوان
│   ├── data/              
│   │   └── repositories/   # طبقة البيانات
│   ├── models/             # نماذج البيانات
│   ├── services/           # الخدمات (API, Storage)
│   ├── utils/              # أدوات مساعدة
│   ├── views/              # الشاشات
│   └── widgets/            # المكونات القابلة لإعادة الاستخدام
└── main.dart

assets/
├── data/                   # ملفات JSON للبيانات
└── images/                 # الصور والأيقونات
```

## 🔧 التكوين

### 1. إعداد Supabase

اتبع الخطوات في [دليل الربط مع Supabase](SUPABASE_INTEGRATION_GUIDE.md)

### 2. تحديث ملف التكوين

في `lib/src/config/supabase_config.dart`:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

## 📱 الشاشات المتوفرة

- ✅ شاشة البداية (Splash)
- ✅ تسجيل الدخول والتسجيل
- ✅ الصفحة الرئيسية
- ✅ قائمة الكورسات
- ✅ تفاصيل الكورس
- ✅ مشغل الكورس
- ✅ الامتحانات
- ✅ الملف الشخصي
- ✅ الإعدادات
- ✅ الإشعارات
- ✅ المحادثات
- ✅ المناقشات
- ✅ الإنجازات والشهادات
- ✅ المحاضرات المباشرة

## 🎨 التصميم

التطبيق يدعم:
- ✅ الوضع الفاتح والداكن
- ✅ اللغة العربية (RTL)
- ✅ التصميم المتجاوب لجميع أحجام الشاشات
- ✅ Material Design 3

## 📄 الوثائق

- [خطة التطوير الشاملة](DEVELOPMENT_PLAN.md)
- [دليل الربط مع Supabase](SUPABASE_INTEGRATION_GUIDE.md)
- [ملخص تكامل HTML](FLUTTER_HTML_INTEGRATION_SUMMARY.md)

## 🧪 الاختبار

```bash
# تشغيل الاختبارات
flutter test

# فحص الكود
flutter analyze

# تنسيق الكود
flutter format .
```

## 📦 البناء للإنتاج

### Android
```bash
flutter build apk --release
# أو
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 المساهمة

نرحب بالمساهمات! يرجى:
1. Fork المشروع
2. إنشاء فرع للميزة الجديدة
3. Commit التغييرات
4. Push إلى الفرع
5. فتح Pull Request

## 📝 الترخيص

هذا المشروع مرخص تحت [MIT License](LICENSE)

## 📞 التواصل

- الموقع: [waslaacademy.com](https://waslaacademy.com)
- البريد: info@waslaacademy.com
- الدعم الفني: support@waslaacademy.com

## 🙏 شكر وتقدير

شكراً لجميع المساهمين في هذا المشروع!

---

تم التطوير بـ ❤️ في اليمن
