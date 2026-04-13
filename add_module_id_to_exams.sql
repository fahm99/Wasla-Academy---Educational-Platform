-- إضافة module_id إلى جدول الامتحانات
-- هذا يسمح بربط الامتحان بوحدة معينة أو بالكورس بالكامل

-- إضافة عمود module_id (اختياري)
ALTER TABLE exams 
ADD COLUMN IF NOT EXISTS module_id UUID REFERENCES modules(id) ON DELETE CASCADE;

-- إضافة index للأداء
CREATE INDEX IF NOT EXISTS idx_exams_module_id ON exams(module_id);

-- ملاحظة: 
-- - إذا كان module_id = NULL، فالامتحان للكورس بالكامل
-- - إذا كان module_id موجود، فالامتحان لوحدة معينة

-- إضافة order_number لترتيب الامتحانات
ALTER TABLE exams 
ADD COLUMN IF NOT EXISTS order_number INT DEFAULT 0;

-- إضافة index فريد للترتيب
CREATE UNIQUE INDEX IF NOT EXISTS idx_exams_course_module_order 
ON exams(course_id, COALESCE(module_id, '00000000-0000-0000-0000-000000000000'::uuid), order_number);

COMMENT ON COLUMN exams.module_id IS 'معرف الوحدة - NULL يعني امتحان للكورس بالكامل';
COMMENT ON COLUMN exams.order_number IS 'ترتيب الامتحان ضمن الوحدة أو الكورس';
