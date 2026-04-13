-- ============================================
-- إصلاح سياسات RLS لجدول enrollments
-- Fix RLS Policies for enrollments table
-- ============================================

-- 1. حذف السياسات القديمة إن وجدت
DROP POLICY IF EXISTS "Users can view their own enrollments" ON enrollments;
DROP POLICY IF EXISTS "Users can insert their own enrollments" ON enrollments;
DROP POLICY IF EXISTS "Users can update their own enrollments" ON enrollments;
DROP POLICY IF EXISTS "Providers can view enrollments for their courses" ON enrollments;

-- 2. التأكد من تفعيل RLS
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;

-- 3. سياسة القراءة: المستخدمون يمكنهم قراءة تسجيلاتهم الخاصة
CREATE POLICY "Users can view their own enrollments"
ON enrollments
FOR SELECT
TO authenticated
USING (
  student_id = auth.uid()
);

-- 4. سياسة الإدراج: المستخدمون يمكنهم التسجيل في الكورسات
CREATE POLICY "Users can insert their own enrollments"
ON enrollments
FOR INSERT
TO authenticated
WITH CHECK (
  student_id = auth.uid()
  AND
  -- التأكد من أن الكورس موجود ومنشور
  EXISTS (
    SELECT 1 FROM courses 
    WHERE id = course_id 
    AND status = 'published'
  )
);

-- 5. سياسة التحديث: المستخدمون يمكنهم تحديث تسجيلاتهم الخاصة
CREATE POLICY "Users can update their own enrollments"
ON enrollments
FOR UPDATE
TO authenticated
USING (student_id = auth.uid())
WITH CHECK (student_id = auth.uid());

-- 6. سياسة إضافية: مقدمو الكورسات يمكنهم رؤية التسجيلات في كورساتهم
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

-- 7. التحقق من السياسات
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'enrollments'
ORDER BY policyname;

-- ============================================
-- ملاحظات مهمة:
-- ============================================
-- 1. هذه السياسات تسمح للمستخدمين بالتسجيل في الكورسات المنشورة فقط
-- 2. كل مستخدم يمكنه رؤية وتحديث تسجيلاته الخاصة فقط
-- 3. مقدمو الكورسات يمكنهم رؤية جميع التسجيلات في كورساتهم
-- 4. لا يمكن للمستخدمين حذف التسجيلات (يجب أن يتم ذلك من خلال تحديث الحالة)

-- ============================================
-- اختبار السياسات:
-- ============================================
-- يمكنك اختبار السياسات بتشغيل:
-- 
-- 1. تسجيل الدخول كمستخدم عادي
-- 2. محاولة التسجيل في كورس:
--    INSERT INTO enrollments (student_id, course_id, enrollment_date, status)
--    VALUES (auth.uid(), 'course_id_here', NOW(), 'active');
-- 
-- 3. يجب أن ينجح إذا كان الكورس منشوراً
