# 🎓 دمج الامتحانات مع الوحدات - دليل شامل

## ✅ تم دمج الامتحانات مع الوحدات والدروس

تم تطوير نظام متكامل يعرض الامتحانات والدروس معاً في واجهة واحدة منظمة.

---

## 📊 التعديلات على قاعدة البيانات

### إضافة module_id إلى جدول exams

```sql
-- إضافة عمود module_id (اختياري)
ALTER TABLE exams 
ADD COLUMN IF NOT EXISTS module_id UUID REFERENCES modules(id) ON DELETE CASCADE;

-- إضافة order_number لترتيب الامتحانات
ALTER TABLE exams 
ADD COLUMN IF NOT EXISTS order_number INT DEFAULT 0;
```

**القواعد:**
- إذا كان `module_id = NULL` → الامتحان للكورس بالكامل
- إذا كان `module_id` موجود → الامتحان لوحدة معينة

---

## 🏗️ التعديلات على الكود

### 1. تحديث Exam Entity

**الملف:** `lib/features/exams/domain/entities/exam.dart`

**التعديلات:**
```dart
class Exam extends Equatable {
  final String? moduleId; // null = امتحان للكورس بالكامل
  final int orderNumber;
  
  // Helper methods
  bool get isCourseExam => moduleId == null;
  bool get isModuleExam => moduleId != null;
}
```

### 2. تحديث ExamModel

**الملف:** `lib/features/exams/data/models/exam_model.dart`

**التعديلات:**
- إضافة `moduleId` و `orderNumber` في constructor
- تحديث `fromJson()` لقراءة الحقول الجديدة
- تحديث `toJson()` لحفظ الحقول الجديدة

### 3. إعادة كتابة CourseContentPage

**الملف:** `lib/features/learning/presentation/pages/course_content_page.dart`

**الميزات الجديدة:**
- ✅ تحميل الدروس والامتحانات معاً
- ✅ تجميع الامتحانات حسب الوحدة
- ✅ عرض امتحانات الكورس بالكامل في قسم منفصل
- ✅ عرض امتحانات كل وحدة مع دروسها
- ✅ تصميم موحد ومنظم

---

## 🎨 الواجهة الجديدة

### البنية الهرمية للعرض:

```
📚 محتوى الكورس
│
├── 📝 امتحانات الكورس (إن وجدت)
│   ├── امتحان نهائي
│   └── امتحان شامل
│
├── 📁 الوحدة الأولى
│   ├── 📖 الدرس الأول
│   ├── 📖 الدرس الثاني
│   ├── 📖 الدرس الثالث
│   └── 📝 امتحان الوحدة الأولى
│
├── 📁 الوحدة الثانية
│   ├── 📖 الدرس الأول
│   ├── 📖 الدرس الثاني
│   └── 📝 امتحان الوحدة الثانية
│
└── 📁 الوحدة الثالثة
    ├── 📖 الدرس الأول
    └── 📖 الدرس الثاني
```

### التصميم البصري:

#### 1. قسم امتحانات الكورس
- **لون الخلفية:** أصفر فاتح (warning color)
- **أيقونة:** quiz
- **العنوان:** "امتحانات الكورس"
- **يظهر فقط:** إذا كان هناك امتحانات بـ `module_id = NULL`

#### 2. قسم الوحدة
- **لون الخلفية:** أزرق فاتح (primary color)
- **أيقونة:** folder_outlined
- **العنوان:** اسم الوحدة
- **المحتوى:**
  - قائمة الدروس
  - فاصل (divider)
  - عنوان "امتحانات الوحدة"
  - قائمة الامتحانات

#### 3. عنصر الدرس
- **أيقونة:** حسب نوع الدرس (video, text, file, quiz)
- **حالة الإكمال:** علامة صح خضراء
- **معلومات:** المدة، حالة مجاني

#### 4. عنصر الامتحان
- **أيقونة:** 
  - quiz (أصفر) - لم يُحل
  - check_circle (أخضر) - ناجح
  - cancel (أحمر) - راسب
- **معلومات:** المدة، حالة النجاح/الرسوب

---

## 🔄 سير العمل

### 1. تحميل البيانات
```dart
void _loadData() {
  // تحميل الدروس
  context.read<LearningBloc>().add(LoadCourseLessonsEvent(...));
  
  // تحميل الامتحانات
  context.read<ExamsBloc>().add(LoadCourseExamsEvent(...));
}
```

### 2. تجميع البيانات
```dart
// تجميع الدروس حسب الوحدة
final moduleMap = _groupLessonsByModule(lessons);

// تجميع الامتحانات حسب الوحدة
final examsByModule = <String?, List<Exam>>{};
for (var exam in exams) {
  examsByModule[exam.moduleId] = [...];
}
```

### 3. بناء الواجهة
```dart
ListView(
  children: [
    // امتحانات الكورس
    if (examsByModule[null] != null)
      _buildCourseExamsSection(...),
    
    // الوحدات
    ...moduleMap.entries.map((entry) {
      return _buildModuleSection(
        lessons: entry.value,
        exams: examsByModule[moduleId],
      );
    }),
  ],
)
```

---

## 💡 الميزات الرئيسية

### 1. مرونة في التنظيم
- امتحان للكورس بالكامل (نهائي/شامل)
- امتحان لكل وحدة
- إمكانية وجود عدة امتحانات لنفس الوحدة

### 2. عرض موحد
- نفس التصميم للدروس والامتحانات
- تمييز بصري واضح بين الأنواع
- معلومات شاملة لكل عنصر

### 3. تفاعل سلس
- الضغط على الدرس → فتح صفحة المشاهدة
- الضغط على الامتحان → فتح صفحة الامتحان
- تحديث تلقائي بعد العودة

### 4. حالات الإكمال
- عرض حالة إكمال الدروس
- عرض نتائج الامتحانات السابقة
- تمييز بصري للحالات المختلفة

---

## 📝 ملاحظات مهمة

### 1. ترتيب العرض
- الامتحانات تُعرض حسب `order_number`
- الدروس تُعرض حسب `order_number` الخاص بها
- امتحانات الكورس تظهر في الأعلى

### 2. الأداء
- تحميل البيانات مرة واحدة
- استخدام BlocBuilder لكل Bloc منفصل
- تجميع البيانات في الذاكرة

### 3. التوافق
- يعمل مع البنية الحالية للدروس
- لا يؤثر على الامتحانات الموجودة
- يدعم الإضافة التدريجية للامتحانات

---

## 🧪 الاختبار المطلوب

### سيناريوهات الاختبار:

1. **عرض امتحانات الكورس:**
   - [ ] عرض امتحانات الكورس في الأعلى
   - [ ] عدم ظهور القسم إذا لم توجد امتحانات

2. **عرض امتحانات الوحدة:**
   - [ ] عرض امتحانات كل وحدة مع دروسها
   - [ ] عدم ظهور قسم الامتحانات إذا لم توجد

3. **التنقل:**
   - [ ] فتح الدرس بشكل صحيح
   - [ ] فتح الامتحان بشكل صحيح
   - [ ] تحديث البيانات بعد العودة

4. **الحالات:**
   - [ ] عرض حالة الدروس المكتملة
   - [ ] عرض نتائج الامتحانات
   - [ ] تمييز الامتحانات الناجحة/الراسبة

---

## 📁 الملفات المعدلة

### ملفات جديدة:
1. ✅ `add_module_id_to_exams.sql` - Migration SQL

### ملفات معدلة:
1. ✅ `lib/features/exams/domain/entities/exam.dart`
   - إضافة moduleId و orderNumber
   - إضافة helper methods

2. ✅ `lib/features/exams/data/models/exam_model.dart`
   - تحديث constructor
   - تحديث fromJson/toJson

3. ✅ `lib/features/learning/presentation/pages/course_content_page.dart`
   - إعادة كتابة كاملة
   - دمج الامتحانات مع الدروس
   - تصميم جديد منظم

---

## 🚀 الخطوات التالية

### 1. تطبيق Migration على قاعدة البيانات
```bash
# تشغيل الـ SQL migration
psql -d your_database -f add_module_id_to_exams.sql
```

### 2. إضافة RLS Policies
```sql
-- السماح للطلاب بقراءة الامتحانات المنشورة
CREATE POLICY "Students can view published exams"
ON exams FOR SELECT
TO authenticated
USING (status = 'published');
```

### 3. إضافة بيانات تجريبية
- إضافة امتحان للكورس بالكامل (module_id = NULL)
- إضافة امتحان لكل وحدة (module_id = <uuid>)

---

## ✨ الخلاصة

تم دمج الامتحانات مع الوحدات والدروس في واجهة واحدة منظمة:
- ✅ دعم امتحانات الكورس بالكامل
- ✅ دعم امتحانات الوحدات
- ✅ عرض موحد ومنظم
- ✅ تصميم بصري واضح
- ✅ تفاعل سلس
- ✅ تحديث تلقائي

**الخطوة التالية:** تطبيق migration على قاعدة البيانات وإضافة RLS policies.

---

**تاريخ الإنشاء:** 2026-04-13  
**الحالة:** ✅ مكتمل - يحتاج تطبيق migration
