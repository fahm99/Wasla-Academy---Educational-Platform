# 🔧 إصلاح خطأ التسجيل في الكورسات
## Fix Enrollment RLS Error

**التاريخ:** 2026-04-13  
**المشكلة:** خطأ عند التسجيل في الكورسات المجانية  
**الخطأ:** `new row violates row-level security policy for table 'enrollments'`

---

## 📋 وصف المشكلة

عند محاولة التسجيل في كورس مجاني، يظهر الخطأ التالي:

```
"new row violates row-level security policy for table `enrollments`"
```

### السبب:
سياسات RLS (Row Level Security) على جدول `enrollments` لا تسمح للمستخدمين بإدخال صفوف جديدة.

---

## ✅ الحل

### الخطوة 1: تطبيق ملف SQL

قم بتشغيل الملف `fix_enrollments_rls.sql` في Supabase SQL Editor:

1. افتح Supabase Dashboard
2. اذهب إلى SQL Editor
3. انسخ محتوى الملف `fix_enrollments_rls.sql`
4. الصق المحتوى وشغّل الاستعلام
5. تأكد من ظهور رسالة نجاح

### الخطوة 2: التحقق من السياسات

بعد تطبيق الملف، تحقق من السياسات الجديدة:

```sql
SELECT 
  policyname,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'enrollments';
```

يجب أن ترى 4 سياسات:
1. ✅ `Users can view their own enrollments` (SELECT)
2. ✅ `Users can insert their own enrollments` (INSERT)
3. ✅ `Users can update their own enrollments` (UPDATE)
4. ✅ `Providers can view enrollments for their courses` (SELECT)

---

## 🔍 تفاصيل السياسات الجديدة

### 1. سياسة القراءة للمستخدمين
```sql
CREATE POLICY "Users can view their own enrollments"
ON enrollments
FOR SELECT
TO authenticated
USING (student_id = auth.uid());
```

**الوظيفة:** يسمح للمستخدمين برؤية تسجيلاتهم الخاصة فقط.

---

### 2. سياسة الإدراج للمستخدمين
```sql
CREATE POLICY "Users can insert their own enrollments"
ON enrollments
FOR INSERT
TO authenticated
WITH CHECK (
  student_id = auth.uid()
  AND
  EXISTS (
    SELECT 1 FROM courses 
    WHERE id = course_id 
    AND status = 'published'
  )
);
```

**الوظيفة:** 
- يسمح للمستخدمين بالتسجيل في الكورسات
- يتحقق من أن `student_id` يطابق المستخدم الحالي
- يتحقق من أن الكورس موجود ومنشور (`status = 'published'`)

---

### 3. سياسة التحديث للمستخدمين
```sql
CREATE POLICY "Users can update their own enrollments"
ON enrollments
FOR UPDATE
TO authenticated
USING (student_id = auth.uid())
WITH CHECK (student_id = auth.uid());
```

**الوظيفة:** يسمح للمستخدمين بتحديث تسجيلاتهم الخاصة فقط.

---

### 4. سياسة القراءة لمقدمي الكورسات
```sql
CREATE POLICY "Providers can view enrollments for their courses"
ON enrollments
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM courses 
    WHERE courses.id = enrollments.course_id 
    AND courses.provider_id = auth.uid()
  )
);
```

**الوظيفة:** يسمح لمقدمي الكورسات برؤية جميع التسجيلات في كورساتهم.

---

## 🧪 اختبار الحل

### 1. اختبار التسجيل في كورس مجاني

```dart
// في التطبيق
1. سجل الدخول كطالب
2. اذهب إلى صفحة الكورسات
3. اختر كورس مجاني
4. اضغط "اشترك الآن"
5. يجب أن يتم التسجيل بنجاح
```

### 2. اختبار من SQL Editor

```sql
-- تسجيل الدخول كمستخدم
SET LOCAL role authenticated;
SET LOCAL request.jwt.claim.sub = 'user_id_here';

-- محاولة التسجيل
INSERT INTO enrollments (student_id, course_id, enrollment_date, status)
VALUES (
  'user_id_here',
  'course_id_here',
  NOW(),
  'active'
);

-- يجب أن ينجح إذا كان الكورس منشوراً
```

---

## 🔒 الأمان

### ما تم تأمينه:
✅ المستخدمون يمكنهم فقط:
- رؤية تسجيلاتهم الخاصة
- التسجيل في الكورسات المنشورة فقط
- تحديث تسجيلاتهم الخاصة

✅ مقدمو الكورسات يمكنهم:
- رؤية جميع التسجيلات في كورساتهم

❌ لا يمكن للمستخدمين:
- رؤية تسجيلات المستخدمين الآخرين
- التسجيل في كورسات غير منشورة
- حذف التسجيلات (يجب تحديث الحالة بدلاً من ذلك)

---

## 🐛 مشاكل محتملة وحلولها

### المشكلة 1: لا يزال الخطأ موجوداً
**الحل:**
1. تأكد من تطبيق ملف SQL بنجاح
2. تحقق من أن RLS مفعّل: `ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;`
3. أعد تشغيل التطبيق

### المشكلة 2: "Already enrolled in this course"
**السبب:** المستخدم مسجل بالفعل في الكورس  
**الحل:** هذا سلوك طبيعي، الكود يتعامل معه بشكل صحيح

### المشكلة 3: "User not authenticated"
**السبب:** المستخدم غير مسجل دخول  
**الحل:** تأكد من تسجيل الدخول أولاً

---

## 📝 ملاحظات مهمة

### 1. الكورسات المنشورة فقط
السياسة الجديدة تسمح بالتسجيل في الكورسات المنشورة فقط (`status = 'published'`).

إذا كنت تريد السماح بالتسجيل في كورسات بحالات أخرى، عدّل السياسة:

```sql
-- للسماح بالتسجيل في كورسات draft أيضاً
DROP POLICY "Users can insert their own enrollments" ON enrollments;

CREATE POLICY "Users can insert their own enrollments"
ON enrollments
FOR INSERT
TO authenticated
WITH CHECK (
  student_id = auth.uid()
  AND
  EXISTS (
    SELECT 1 FROM courses 
    WHERE id = course_id 
    AND status IN ('published', 'draft')  -- ← تعديل هنا
  )
);
```

### 2. حذف التسجيلات
لا توجد سياسة DELETE لأن التسجيلات يجب أن تُحفظ للسجلات.

بدلاً من الحذف، استخدم تحديث الحالة:

```sql
UPDATE enrollments 
SET status = 'cancelled', 
    updated_at = NOW()
WHERE id = 'enrollment_id';
```

### 3. الأداء
السياسات تستخدم `EXISTS` للتحقق من الكورسات، وهذا فعّال.

لكن إذا كان لديك عدد كبير من التسجيلات، تأكد من وجود indexes:

```sql
-- Index على student_id (موجود بالفعل كـ foreign key)
-- Index على course_id (موجود بالفعل كـ foreign key)
-- Index على status للاستعلامات السريعة
CREATE INDEX IF NOT EXISTS idx_enrollments_status 
ON enrollments(status);
```

---

## ✅ قائمة التحقق

بعد تطبيق الإصلاح:

- [ ] تم تطبيق ملف `fix_enrollments_rls.sql`
- [ ] تم التحقق من وجود 4 سياسات
- [ ] تم اختبار التسجيل في كورس مجاني
- [ ] تم اختبار التسجيل في كورس مدفوع
- [ ] تم التحقق من عدم إمكانية رؤية تسجيلات الآخرين
- [ ] تم التحقق من عمل تحديث التسجيلات

---

## 🎯 النتيجة المتوقعة

بعد تطبيق هذا الإصلاح:

✅ **يعمل:**
- التسجيل في الكورسات المجانية
- التسجيل في الكورسات المدفوعة (بعد الدفع)
- رؤية قائمة "كورساتي"
- تحديث حالة التسجيل

✅ **محمي:**
- لا يمكن رؤية تسجيلات المستخدمين الآخرين
- لا يمكن التسجيل في كورسات غير منشورة
- لا يمكن التسجيل باسم مستخدم آخر

---

## 📞 الدعم

إذا استمرت المشكلة:

1. تحقق من logs في Supabase Dashboard
2. تحقق من أن المستخدم مسجل دخول
3. تحقق من أن الكورس منشور (`status = 'published'`)
4. تحقق من عدم وجود تسجيل سابق

---

**تم الإصلاح بواسطة:** Kiro AI Assistant  
**التاريخ:** 2026-04-13  
**الحالة:** ✅ جاهز للتطبيق

