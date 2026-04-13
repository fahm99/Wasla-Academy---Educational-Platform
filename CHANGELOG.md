# 📝 سجل التغييرات - Wasla Academy

جميع التغييرات المهمة في هذا المشروع سيتم توثيقها في هذا الملف.

التنسيق مبني على [Keep a Changelog](https://keepachangelog.com/ar/1.0.0/)،
وهذا المشروع يتبع [Semantic Versioning](https://semver.org/lang/ar/).

---

## [غير منشور] - 2026-04-11

### ✨ مضاف (Added)

#### البنية الأساسية (Core)
- إضافة `lib/core/config/supabase_config.dart` - تكوين Supabase
- إضافة `lib/core/config/app_config.dart` - تكوين التطبيق العام
- إضافة `lib/core/constants/api_constants.dart` - ثوابت API
- إضافة `lib/core/constants/storage_constants.dart` - ثوابت التخزين المحلي
- إضافة `lib/core/errors/exceptions.dart` - 8 أنواع من الاستثناءات المخصصة
- إضافة `lib/core/errors/failures.dart` - 8 أنواع من Failures
- إضافة `lib/core/network/network_info.dart` - التحقق من الاتصال بالإنترنت
- إضافة `lib/core/network/api_client.dart` - عميل API موحد لـ Supabase
- إضافة `lib/core/utils/validators.dart` - 12 دالة للتحقق من الصحة
- إضافة `lib/core/utils/helpers.dart` - 20+ دالة مساعدة

#### نظام المصادقة (Authentication)
- إضافة `lib/features/auth/data/models/user_model.dart` - نموذج المستخدم الكامل
- إضافة `lib/features/auth/data/datasources/auth_remote_datasource.dart` - مصدر البيانات البعيد
- إضافة `lib/features/auth/data/repositories/auth_repository_impl.dart` - تنفيذ المستودع
- إضافة `lib/features/auth/domain/repositories/auth_repository.dart` - واجهة المستودع

#### الوثائق
- إضافة `INTEGRATION_PLAN.md` - خطة التكامل الشاملة (15 مرحلة)
- إضافة `SETUP_INSTRUCTIONS.md` - تعليمات الإعداد خطوة بخطوة
- إضافة `README_INTEGRATION.md` - دليل المشروع الكامل
- إضافة `SUMMARY.md` - ملخص العمل المنجز
- إضافة `TODO.md` - قائمة المهام المفصلة
- إضافة `CHANGELOG.md` - سجل التغييرات (هذا الملف)
- إضافة `.env.example` - مثال لملف البيئة

#### المكتبات
- إضافة `supabase_flutter: ^2.5.0` - Supabase SDK
- إضافة `http: ^1.2.0` - HTTP Client
- إضافة `dio: ^5.4.0` - Advanced HTTP Client
- إضافة `dartz: ^0.10.1` - Functional Programming
- إضافة `image_picker: ^1.0.7` - اختيار الصور
- إضافة `path: ^1.9.0` - معالجة المسارات
- إضافة `uuid: ^4.3.3` - توليد UUID

### 🔄 تغيير (Changed)
- تحديث `pubspec.yaml` - إعادة تنظيم وإضافة المكتبات الجديدة
- تحسين بنية المشروع - اتباع Clean Architecture

### 📚 موثق (Documented)
- توثيق كامل لجميع الملفات المنشأة
- إنشاء خطة تكامل شاملة من 15 مرحلة
- إنشاء تعليمات إعداد مفصلة
- إنشاء دليل مشروع كامل
- إنشاء ملخص العمل المنجز
- إنشاء قائمة مهام مفصلة

---

## [1.0.0] - قادم

### المخطط له (Planned)

#### نظام الكورسات
- [ ] إضافة Models للكورسات والوحدات والدروس
- [ ] إضافة Data Sources للكورسات
- [ ] إضافة Repositories للكورسات
- [ ] إضافة Blocs للكورسات
- [ ] تحديث شاشات الكورسات

#### نظام الدفع
- [ ] إضافة Models للمدفوعات
- [ ] إضافة Data Sources للمدفوعات
- [ ] إضافة Repositories للمدفوعات
- [ ] إضافة Blocs للمدفوعات
- [ ] إنشاء شاشات الدفع الجديدة

#### نظام التعلم
- [ ] إضافة Models لتتبع التقدم
- [ ] إضافة Data Sources للتعلم
- [ ] إضافة Repositories للتعلم
- [ ] إضافة Blocs للتعلم
- [ ] تحديث شاشات التعلم

#### نظام الامتحانات
- [ ] إضافة Models للامتحانات
- [ ] إضافة Data Sources للامتحانات
- [ ] إضافة Repositories للامتحانات
- [ ] إضافة Blocs للامتحانات
- [ ] تحديث شاشات الامتحانات

#### نظام الشهادات
- [ ] إضافة Data Sources للشهادات
- [ ] إضافة Repositories للشهادات
- [ ] إضافة Blocs للشهادات
- [ ] تحديث شاشات الشهادات
- [ ] إضافة خدمة توليد PDF

#### نظام الإشعارات
- [ ] إضافة Data Sources للإشعارات
- [ ] إضافة Repositories للإشعارات
- [ ] إضافة Blocs للإشعارات
- [ ] إضافة Realtime Subscriptions
- [ ] تحديث شاشات الإشعارات

#### نظام الملف الشخصي
- [ ] إضافة Data Sources للملف الشخصي
- [ ] إضافة Repositories للملف الشخصي
- [ ] إضافة Blocs للملف الشخصي
- [ ] تحديث شاشات الملف الشخصي

#### التحسينات
- [ ] إضافة التخزين المؤقت
- [ ] إضافة وضع Offline
- [ ] تحسين الأداء
- [ ] إضافة الاختبارات
- [ ] تحسين UI/UX

---

## أنواع التغييرات

- `✨ مضاف (Added)` - للميزات الجديدة
- `🔄 تغيير (Changed)` - للتغييرات في الميزات الموجودة
- `🗑️ محذوف (Deprecated)` - للميزات التي ستُحذف قريباً
- `❌ مُزال (Removed)` - للميزات المحذوفة
- `🐛 إصلاح (Fixed)` - لإصلاح الأخطاء
- `🔒 أمان (Security)` - لإصلاحات الأمان
- `📚 موثق (Documented)` - للتوثيق

---

## الإصدارات

### [غير منشور]
التغييرات الحالية التي لم تُنشر بعد

### [1.0.0] - قادم
الإصدار الأول الكامل للتطبيق

---

**ملاحظة:** هذا المشروع في مرحلة التطوير النشط. سيتم تحديث هذا الملف مع كل تغيير مهم.

---

**آخر تحديث:** 2026-04-11  
**الحالة:** قيد التطوير 🚀
