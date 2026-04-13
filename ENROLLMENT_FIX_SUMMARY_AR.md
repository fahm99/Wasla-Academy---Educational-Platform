# 🚀 ملخص سريع: إصلاح خطأ التسجيل في الكورسات

## المشكلة
```
"new row violates row-level security policy for table `enrollments`"
```

## الحل السريع (5 دقائق)

### 1. افتح Supabase SQL Editor
- اذهب إلى: https://supabase.com/dashboard
- اختر مشروعك
- اضغط على "SQL Editor"

### 2. نفذ هذا الكود:

```sql
-- حذف السياسات القديمة
DROP POLICY IF EXISTS "Users can view their own enrollments" ON enrollments;
DROP POLICY IF EXISTS "Users can insert their own enrollments" ON enrollments;
DROP POLICY IF EXISTS "Users can update their own enrollments" ON enrollments;
DROP POLICY IF EXISTS "Providers can view enrollments for their courses" ON enrollments;

-- تفعيل RLS
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;

-- سياسة القراءة
CREATE POLICY "Users can view their own enrollments"
ON enrollments FOR SELECT TO authenticated
USING (student_id = auth.uid());

-- سياسة الإدراج (هذه المهمة!)
CREATE POLICY "Users can insert their own enrollments"
ON enrollments FOR INSERT TO authenticated
WITH CHECK (
  student_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM courses 
    WHERE id = course_id 
    AND status = 'published'
  )
);

-- سياسة التحديث
CREATE POLICY "Users can update their own enrollments"
ON enrollments FOR UPDATE TO authenticated
USING (student_id = auth.uid())
WITH CHECK (student_id = auth.uid());

-- سياسة للمدرسين
CREATE POLICY "Providers can view enrollments for their courses"
ON enrollments FOR SELECT TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM courses 
    WHERE courses.id = enrollments.course_id 
    AND courses.provider_id = auth.uid()
  )
);
```

### 3. اختبر التطبيق
- أعد تشغيل التطبيق
- جرب التسجيل في كورس مجاني
- يجب أن يعمل الآن! ✅

---

## ماذا فعلنا؟

السياسة الجديدة تسمح للمستخدمين بـ:
- ✅ التسجيل في الكورسات المنشورة
- ✅ رؤية تسجيلاتهم الخاصة فقط
- ✅ تحديث تسجيلاتهم

وتمنع:
- ❌ التسجيل باسم مستخدم آخر
- ❌ التسجيل في كورسات غير منشورة
- ❌ رؤية تسجيلات الآخرين

---

## التحقق من النجاح

بعد تطبيق الكود، شغّل هذا للتحقق:

```sql
SELECT policyname, cmd 
FROM pg_policies 
WHERE tablename = 'enrollments';
```

يجب أن ترى 4 سياسات:
1. Users can view their own enrollments (SELECT)
2. Users can insert their own enrollments (INSERT)
3. Users can update their own enrollments (UPDATE)
4. Providers can view enrollments for their courses (SELECT)

---

**الحالة:** ✅ جاهز للتطبيق  
**الوقت:** 5 دقائق  
**الصعوبة:** سهل

للمزيد من التفاصيل، راجع: `FIX_ENROLLMENT_ERROR_AR.md`
