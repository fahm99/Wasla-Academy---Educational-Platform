-- ============================================
-- إصلاحات الأمان لقاعدة بيانات Wasla Academy
-- التاريخ: 2026-04-12
-- ============================================

-- ============================================
-- 1. إصلاح سياسات RLS لجدول lesson_resources
-- ============================================

-- حذف السياسات القديمة إن وجدت
DROP POLICY IF EXISTS "Students can view lesson resources" ON lesson_resources;
DROP POLICY IF EXISTS "Providers can add lesson resources" ON lesson_resources;
DROP POLICY IF EXISTS "Providers can update lesson resources" ON lesson_resources;
DROP POLICY IF EXISTS "Providers can delete lesson resources" ON lesson_resources;

-- سياسة القراءة: السماح للطلاب المسجلين في الكورس فقط
CREATE POLICY "Students can view lesson resources"
ON lesson_resources FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM enrollments e
    JOIN lessons l ON l.course_id = e.course_id
    WHERE l.id = lesson_resources.lesson_id
    AND e.student_id = auth.uid()
    AND e.status = 'active'
  )
  OR
  -- أو مقدم الخدمة صاحب الكورس
  EXISTS (
    SELECT 1 FROM lessons l
    JOIN courses c ON c.id = l.course_id
    WHERE l.id = lesson_resources.lesson_id
    AND c.provider_id = auth.uid()
  )
);

-- سياسة الإضافة: السماح لمقدمي الخدمات فقط
CREATE POLICY "Providers can add lesson resources"
ON lesson_resources FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM lessons l
    JOIN courses c ON c.id = l.course_id
    WHERE l.id = lesson_resources.lesson_id
    AND c.provider_id = auth.uid()
  )
);

-- سياسة التحديث: السماح لمقدمي الخدمات فقط
CREATE POLICY "Providers can update lesson resources"
ON lesson_resources FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM lessons l
    JOIN courses c ON c.id = l.course_id
    WHERE l.id = lesson_resources.lesson_id
    AND c.provider_id = auth.uid()
  )
);

-- سياسة الحذف: السماح لمقدمي الخدمات فقط
CREATE POLICY "Providers can delete lesson resources"
ON lesson_resources FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM lessons l
    JOIN courses c ON c.id = l.course_id
    WHERE l.id = lesson_resources.lesson_id
    AND c.provider_id = auth.uid()
  )
);

-- ============================================
-- 2. إصلاح سياسات RLS لجدول waitlist
-- ============================================

-- حذف السياسات القديمة المفتوحة
DROP POLICY IF EXISTS "Allow insert for everyone" ON waitlist;
DROP POLICY IF EXISTS "Enable insert access for all users" ON waitlist;
DROP POLICY IF EXISTS "Enable update access for all users" ON waitlist;

-- سياسة الإضافة: السماح لأي شخص بالانضمام للقائمة (مع التحقق من البريد)
CREATE POLICY "Anyone can join waitlist"
ON waitlist FOR INSERT
WITH CHECK (
  email IS NOT NULL 
  AND email != '' 
  AND email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
);

-- سياسة القراءة: الأدمن فقط يمكنه رؤية القائمة
CREATE POLICY "Only admins can view waitlist"
ON waitlist FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.user_type = 'admin'
  )
);

-- سياسة التحديث: الأدمن فقط
CREATE POLICY "Only admins can update waitlist"
ON waitlist FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.user_type = 'admin'
  )
);

-- سياسة الحذف: الأدمن فقط
CREATE POLICY "Only admins can delete waitlist"
ON waitlist FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.user_type = 'admin'
  )
);

-- ============================================
-- 3. إصلاح سياسات RLS لجدول reviews
-- ============================================

-- التأكد من وجود سياسات آمنة للتقييمات
DROP POLICY IF EXISTS "Students can view all reviews" ON reviews;
DROP POLICY IF EXISTS "Students can add reviews" ON reviews;
DROP POLICY IF EXISTS "Students can update own reviews" ON reviews;
DROP POLICY IF EXISTS "Students can delete own reviews" ON reviews;

-- سياسة القراءة: الجميع يمكنهم رؤية التقييمات
CREATE POLICY "Students can view all reviews"
ON reviews FOR SELECT
USING (true);

-- سياسة الإضافة: الطلاب المسجلين فقط
CREATE POLICY "Students can add reviews"
ON reviews FOR INSERT
WITH CHECK (
  auth.uid() = student_id
  AND EXISTS (
    SELECT 1 FROM enrollments
    WHERE enrollments.student_id = auth.uid()
    AND enrollments.course_id = reviews.course_id
    AND enrollments.status IN ('active', 'completed')
  )
);

-- سياسة التحديث: الطالب صاحب التقييم فقط
CREATE POLICY "Students can update own reviews"
ON reviews FOR UPDATE
USING (auth.uid() = student_id);

-- سياسة الحذف: الطالب صاحب التقييم أو الأدمن
CREATE POLICY "Students can delete own reviews"
ON reviews FOR DELETE
USING (
  auth.uid() = student_id
  OR EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.user_type = 'admin'
  )
);

-- ============================================
-- 4. إصلاح search_path للدوال
-- ============================================

-- إصلاح دالة update_course_students_count
ALTER FUNCTION update_course_students_count()
SET search_path = public, pg_temp;

-- إصلاح دالة update_provider_courses_count
ALTER FUNCTION update_provider_courses_count()
SET search_path = public, pg_temp;

-- إصلاح دالة update_payment_status
ALTER FUNCTION update_payment_status()
SET search_path = public, pg_temp;

-- إصلاح دالة update_provider_payment_settings_updated_at
ALTER FUNCTION update_provider_payment_settings_updated_at()
SET search_path = public, pg_temp;

-- إصلاح دالة check_student_eligibility
ALTER FUNCTION check_student_eligibility(uuid, uuid)
SET search_path = public, pg_temp;

-- إصلاح دالة get_eligible_students
ALTER FUNCTION get_eligible_students(uuid)
SET search_path = public, pg_temp;

-- إصلاح دالة auto_issue_certificate
ALTER FUNCTION auto_issue_certificate()
SET search_path = public, pg_temp;

-- إصلاح دالة update_enrollment_completed_at
ALTER FUNCTION update_enrollment_completed_at()
SET search_path = public, pg_temp;

-- ============================================
-- 5. تفعيل حماية كلمات المرور المسربة
-- ============================================

-- ملاحظة: هذا يتم من خلال Supabase Dashboard
-- Authentication > Policies > Password Strength
-- تفعيل: "Check against leaked passwords database"

-- ============================================
-- 6. إضافة indexes للأداء والأمان
-- ============================================

-- Index لتسريع البحث في enrollments
CREATE INDEX IF NOT EXISTS idx_enrollments_student_course 
ON enrollments(student_id, course_id);

-- Index لتسريع البحث في lesson_progress
CREATE INDEX IF NOT EXISTS idx_lesson_progress_student_lesson 
ON lesson_progress(student_id, lesson_id);

-- Index لتسريع البحث في payments
CREATE INDEX IF NOT EXISTS idx_payments_student_status 
ON payments(student_id, status);

-- Index لتسريع البحث في notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user_read 
ON notifications(user_id, is_read);

-- Index لتسريع البحث في reviews
CREATE INDEX IF NOT EXISTS idx_reviews_course 
ON reviews(course_id);

-- ============================================
-- 7. إضافة constraints إضافية للأمان
-- ============================================

-- التأكد من أن التقييم بين 1 و 5
ALTER TABLE reviews 
DROP CONSTRAINT IF EXISTS reviews_rating_check;

ALTER TABLE reviews 
ADD CONSTRAINT reviews_rating_check 
CHECK (rating >= 1 AND rating <= 5);

-- التأكد من أن نسبة الإكمال بين 0 و 100
ALTER TABLE enrollments 
DROP CONSTRAINT IF EXISTS enrollments_completion_percentage_check;

ALTER TABLE enrollments 
ADD CONSTRAINT enrollments_completion_percentage_check 
CHECK (completion_percentage >= 0 AND completion_percentage <= 100);

-- التأكد من أن السعر غير سالب
ALTER TABLE courses 
DROP CONSTRAINT IF EXISTS courses_price_check;

ALTER TABLE courses 
ADD CONSTRAINT courses_price_check 
CHECK (price >= 0);

-- التأكد من أن المبلغ المدفوع غير سالب
ALTER TABLE payments 
DROP CONSTRAINT IF EXISTS payments_amount_check;

ALTER TABLE payments 
ADD CONSTRAINT payments_amount_check 
CHECK (amount >= 0);

-- ============================================
-- 8. إضافة triggers للتدقيق (Audit)
-- ============================================

-- إنشاء جدول للتدقيق (اختياري)
CREATE TABLE IF NOT EXISTS audit_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name text NOT NULL,
  record_id uuid NOT NULL,
  action text NOT NULL, -- INSERT, UPDATE, DELETE
  old_data jsonb,
  new_data jsonb,
  user_id uuid REFERENCES users(id),
  created_at timestamp DEFAULT now()
);

-- تفعيل RLS على جدول التدقيق
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- سياسة: الأدمن فقط يمكنه رؤية سجلات التدقيق
CREATE POLICY "Only admins can view audit log"
ON audit_log FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.user_type = 'admin'
  )
);

-- ============================================
-- 9. تحديث سياسات الجداول الحساسة
-- ============================================

-- التأكد من أن الطلاب لا يمكنهم رؤية معلومات الدفع للآخرين
DROP POLICY IF EXISTS "Students can view own payments" ON payments;

CREATE POLICY "Students can view own payments"
ON payments FOR SELECT
USING (
  student_id = auth.uid()
  OR provider_id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.user_type = 'admin'
  )
);

-- التأكد من أن الطلاب لا يمكنهم رؤية شهادات الآخرين
DROP POLICY IF EXISTS "Students can view own certificates" ON certificates;

CREATE POLICY "Students can view own certificates"
ON certificates FOR SELECT
USING (
  student_id = auth.uid()
  OR provider_id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.user_type = 'admin'
  )
);

-- ============================================
-- 10. إضافة دالة للتحقق من صلاحيات المستخدم
-- ============================================

CREATE OR REPLACE FUNCTION check_user_permission(
  required_permission text
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  user_permissions jsonb;
BEGIN
  -- الحصول على صلاحيات المستخدم
  SELECT permissions INTO user_permissions
  FROM users
  WHERE id = auth.uid();
  
  -- التحقق من وجود الصلاحية
  IF user_permissions IS NULL THEN
    RETURN false;
  END IF;
  
  RETURN user_permissions ? required_permission;
END;
$$;

-- ============================================
-- النهاية
-- ============================================

-- عرض ملخص الإصلاحات
DO $$
BEGIN
  RAISE NOTICE '✅ تم تطبيق جميع الإصلاحات الأمنية بنجاح';
  RAISE NOTICE '📊 الإصلاحات المطبقة:';
  RAISE NOTICE '  1. سياسات RLS لجدول lesson_resources';
  RAISE NOTICE '  2. سياسات RLS لجدول waitlist';
  RAISE NOTICE '  3. سياسات RLS لجدول reviews';
  RAISE NOTICE '  4. إصلاح search_path للدوال (8 دوال)';
  RAISE NOTICE '  5. إضافة indexes للأداء';
  RAISE NOTICE '  6. إضافة constraints للأمان';
  RAISE NOTICE '  7. إنشاء جدول التدقيق';
  RAISE NOTICE '  8. تحديث سياسات الجداول الحساسة';
  RAISE NOTICE '  9. إضافة دالة التحقق من الصلاحيات';
  RAISE NOTICE '';
  RAISE NOTICE '⚠️ تذكير: قم بتفعيل حماية كلمات المرور المسربة من Dashboard';
END $$;
