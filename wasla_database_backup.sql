-- ============================================================================
-- Wasla Database Complete Backup
-- Generated: 2026-04-14
-- Purpose: Complete database recreation script for disaster recovery
-- ============================================================================

-- ============================================================================
-- SECTION 1: EXTENSIONS
-- ============================================================================

-- Enable required PostgreSQL extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA graphql;
CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA vault;

-- ============================================================================
-- SECTION 2: SCHEMAS
-- ============================================================================

-- Create schemas if they don't exist
CREATE SCHEMA IF NOT EXISTS public;
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS storage;
CREATE SCHEMA IF NOT EXISTS extensions;
CREATE SCHEMA IF NOT EXISTS graphql;
CREATE SCHEMA IF NOT EXISTS vault;

-- ============================================================================
-- SECTION 3: TABLES
-- ============================================================================

-- Table: users
-- Description: جدول المستخدمين (الطلاب ومقدمي الخدمات والمسؤولين)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    phone VARCHAR,
    avatar_url TEXT,
    profile_image_url TEXT,
    user_type VARCHAR NOT NULL CHECK (user_type IN ('student', 'provider', 'admin')),
    bio TEXT,
    rating NUMERIC DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    courses_enrolled INTEGER DEFAULT 0,
    certificates_count INTEGER DEFAULT 0,
    total_spent NUMERIC DEFAULT 0,
    courses_count INTEGER DEFAULT 0,
    students_count INTEGER DEFAULT 0,
    total_earnings NUMERIC DEFAULT 0,
    bank_account JSONB,
    permissions JSONB,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Table: courses
-- Description: جدول الكورسات
CREATE TABLE IF NOT EXISTS public.courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_id UUID NOT NULL REFERENCES public.users(id),
    title VARCHAR NOT NULL,
    description TEXT,
    category VARCHAR,
    level VARCHAR CHECK (level IN ('beginner', 'intermediate', 'advanced')),
    price NUMERIC DEFAULT 0 CHECK (price >= 0),
    currency VARCHAR DEFAULT 'SAR',
    duration_hours INTEGER,
    thumbnail_url TEXT,
    cover_image_url TEXT,
    status VARCHAR DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived', 'pending_review')),
    students_count INTEGER DEFAULT 0,
    rating NUMERIC DEFAULT 0,
    reviews_count INTEGER DEFAULT 0,
    is_featured BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    certificate_template JSONB,
    certificate_auto_issue BOOLEAN DEFAULT false,
    certificate_logo_url TEXT,
    certificate_signature_url TEXT,
    certificate_custom_color VARCHAR DEFAULT '#1E3A8A'
);

COMMENT ON COLUMN public.courses.cover_image_url IS 'رابط الصورة التعريفية (الغلاف) للكورس';
COMMENT ON COLUMN public.courses.certificate_template IS 'تصميم قالب الشهادة بصيغة JSON';

-- Table: modules
-- Description: جدول الوحدات التعليمية
CREATE TABLE IF NOT EXISTS public.modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES public.courses(id),
    title VARCHAR NOT NULL,
    description TEXT,
    order_number INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Table: lessons
-- Description: جدول الدروس
CREATE TABLE IF NOT EXISTS public.lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL REFERENCES public.modules(id),
    course_id UUID NOT NULL REFERENCES public.courses(id),
    title VARCHAR NOT NULL,
    description TEXT,
    order_number INTEGER NOT NULL,
    lesson_type VARCHAR CHECK (lesson_type IN ('video', 'text', 'file', 'quiz')),
    video_url TEXT,
    video_duration INTEGER,
    content TEXT,
    is_free BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Table: lesson_resources
-- Description: جدول موارد الدروس (ملفات مرفقة)
CREATE TABLE IF NOT EXISTS public.lesson_resources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lesson_id UUID NOT NULL REFERENCES public.lessons(id),
    file_name VARCHAR NOT NULL,
    file_url TEXT NOT NULL,
    file_type VARCHAR CHECK (file_type IN ('pdf', 'doc', 'image', 'zip', 'other')),
    file_size INTEGER,
    created_at TIMESTAMP DEFAULT now()
);

-- Table: enrollments
-- Description: جدول تسجيلات الطلاب في الكورسات
CREATE TABLE IF NOT EXISTS public.enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES public.users(id),
    course_id UUID NOT NULL REFERENCES public.courses(id),
    enrollment_date TIMESTAMP DEFAULT now(),
    completion_percentage INTEGER DEFAULT 0 CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
    status VARCHAR DEFAULT 'active' CHECK (status IN ('active', 'completed', 'dropped')),
    last_accessed TIMESTAMP,
    certificate_id UUID,
    completed_at TIMESTAMP,
    UNIQUE(student_id, course_id)
);

-- Table: lesson_progress
-- Description: جدول تقدم الطلاب في الدروس
CREATE TABLE IF NOT EXISTS public.lesson_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES public.users(id),
    lesson_id UUID NOT NULL REFERENCES public.lessons(id),
    is_completed BOOLEAN DEFAULT false,
    watched_duration INTEGER DEFAULT 0,
    completed_at TIMESTAMP,
    UNIQUE(student_id, lesson_id)
);

-- Table: exams
-- Description: جدول الامتحانات
CREATE TABLE IF NOT EXISTS public.exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES public.courses(id),
    module_id UUID REFERENCES public.modules(id),
    title VARCHAR NOT NULL,
    description TEXT,
    total_questions INTEGER,
    passing_score INTEGER,
    duration_minutes INTEGER,
    status VARCHAR DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
    allow_retake BOOLEAN DEFAULT true,
    max_attempts INTEGER DEFAULT 3,
    order_number INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

COMMENT ON COLUMN public.exams.module_id IS 'معرف الوحدة - NULL يعني امتحان للكورس بالكامل';
COMMENT ON COLUMN public.exams.order_number IS 'ترتيب الامتحان ضمن الوحدة أو الكورس';

-- Table: exam_questions
-- Description: جدول أسئلة الامتحانات
CREATE TABLE IF NOT EXISTS public.exam_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id UUID NOT NULL REFERENCES public.exams(id),
    question_text TEXT NOT NULL,
    question_type VARCHAR CHECK (question_type IN ('multiple_choice', 'true_false', 'essay', 'short_answer')),
    options JSONB,
    correct_answer TEXT,
    points INTEGER DEFAULT 1,
    order_number INTEGER,
    created_at TIMESTAMP DEFAULT now()
);

-- Table: exam_results
-- Description: جدول نتائج الامتحانات
CREATE TABLE IF NOT EXISTS public.exam_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id UUID NOT NULL REFERENCES public.exams(id),
    student_id UUID NOT NULL REFERENCES public.users(id),
    score INTEGER,
    total_score INTEGER,
    percentage NUMERIC,
    passed BOOLEAN,
    attempt_number INTEGER DEFAULT 1,
    completed_at TIMESTAMP,
    answers JSONB,
    created_at TIMESTAMP DEFAULT now()
);

-- Table: certificates
-- Description: جدول الشهادات مع دعم الإصدار التلقائي والتخصيص
CREATE TABLE IF NOT EXISTS public.certificates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES public.courses(id),
    student_id UUID NOT NULL REFERENCES public.users(id),
    provider_id UUID NOT NULL REFERENCES public.users(id),
    certificate_number VARCHAR NOT NULL UNIQUE,
    issue_date TIMESTAMP DEFAULT now(),
    expiry_date TIMESTAMP,
    template_design JSONB,
    certificate_url TEXT,
    status VARCHAR DEFAULT 'issued' CHECK (status IN ('issued', 'revoked')),
    created_at TIMESTAMP DEFAULT now(),
    provider_logo_url TEXT,
    provider_signature_url TEXT,
    custom_color VARCHAR DEFAULT '#1E3A8A',
    auto_issue BOOLEAN DEFAULT false,
    grade VARCHAR,
    completion_date TIMESTAMP,
    template_data JSONB,
    verification_code TEXT UNIQUE,
    is_auto_issued BOOLEAN DEFAULT false,
    student_name TEXT,
    student_email TEXT,
    course_name TEXT,
    provider_name TEXT
);

COMMENT ON TABLE public.certificates IS 'جدول الشهادات مع دعم الإصدار التلقائي والتخصيص';
COMMENT ON COLUMN public.certificates.provider_logo_url IS 'رابط شعار مقدم الخدمة';
COMMENT ON COLUMN public.certificates.provider_signature_url IS 'رابط توقيع مقدم الخدمة';
COMMENT ON COLUMN public.certificates.custom_color IS 'اللون المخصص للشهادة';
COMMENT ON COLUMN public.certificates.auto_issue IS 'هل تم إصدار الشهادة تلقائياً';
COMMENT ON COLUMN public.certificates.grade IS 'التقدير (A+, A, B+, إلخ)';
COMMENT ON COLUMN public.certificates.completion_date IS 'تاريخ إكمال الكورس';

-- Table: certificate_templates
-- Description: جدول قوالب الشهادات
CREATE TABLE IF NOT EXISTS public.certificate_templates (
    id UUID PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES public.users(id),
    course_id UUID REFERENCES public.courses(id),
    name TEXT NOT NULL,
    is_default BOOLEAN DEFAULT false,
    template_data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Table: payments
-- Description: جدول المدفوعات
CREATE TABLE IF NOT EXISTS public.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES public.users(id),
    course_id UUID NOT NULL REFERENCES public.courses(id),
    provider_id UUID NOT NULL REFERENCES public.users(id),
    amount NUMERIC NOT NULL CHECK (amount >= 0),
    currency VARCHAR DEFAULT 'SAR',
    payment_method VARCHAR CHECK (payment_method IN ('credit_card', 'apple_pay', 'google_pay', 'bank_transfer')),
    transaction_id VARCHAR UNIQUE,
    status VARCHAR DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    payment_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT now(),
    receipt_image_url TEXT,
    transaction_reference TEXT,
    student_name TEXT,
    course_name TEXT,
    verified_by UUID REFERENCES public.users(id),
    verified_at TIMESTAMPTZ,
    rejection_reason TEXT,
    updated_at TIMESTAMP DEFAULT now()
);

-- Table: provider_payment_settings
-- Description: إعدادات الدفع لمقدمي الخدمات
CREATE TABLE IF NOT EXISTS public.provider_payment_settings (
    id UUID PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
    provider_id UUID NOT NULL UNIQUE REFERENCES public.users(id),
    wallet_number TEXT,
    wallet_owner_name TEXT,
    bank_name TEXT,
    bank_account_number TEXT,
    bank_account_owner_name TEXT,
    iban TEXT,
    additional_info TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

COMMENT ON TABLE public.provider_payment_settings IS 'إعدادات الدفع لمقدمي الخدمات';

-- Table: notifications
-- Description: جدول الإشعارات
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id),
    title VARCHAR NOT NULL,
    message TEXT,
    type VARCHAR CHECK (type IN ('course', 'exam', 'certificate', 'payment', 'system')),
    related_id UUID,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now()
);

-- Table: reviews
-- Description: جدول التقييمات
CREATE TABLE IF NOT EXISTS public.reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES public.courses(id),
    student_id UUID NOT NULL REFERENCES public.users(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Table: app_settings
-- Description: جدول إعدادات التطبيق للمستخدمين
CREATE TABLE IF NOT EXISTS public.app_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id),
    theme VARCHAR DEFAULT 'light' CHECK (theme IN ('light', 'dark')),
    language VARCHAR DEFAULT 'ar' CHECK (language IN ('ar', 'en')),
    notifications_enabled BOOLEAN DEFAULT true,
    email_notifications BOOLEAN DEFAULT true,
    settings_data JSONB,
    updated_at TIMESTAMP DEFAULT now(),
    push_notifications BOOLEAN DEFAULT true,
    notify_new_students BOOLEAN DEFAULT true,
    notify_new_reviews BOOLEAN DEFAULT true,
    notify_new_payments BOOLEAN DEFAULT true,
    auto_save BOOLEAN DEFAULT true
);

COMMENT ON COLUMN public.app_settings.push_notifications IS 'تفعيل الإشعارات الفورية';
COMMENT ON COLUMN public.app_settings.notify_new_students IS 'إشعار عند انضمام طالب جديد';
COMMENT ON COLUMN public.app_settings.notify_new_reviews IS 'إشعار عند تلقي تقييم جديد';
COMMENT ON COLUMN public.app_settings.notify_new_payments IS 'إشعار عند تلقي دفعة جديدة';
COMMENT ON COLUMN public.app_settings.auto_save IS 'الحفظ التلقائي للتغييرات';

-- Table: waitlist
-- Description: جدول قائمة الانتظار
CREATE TABLE IF NOT EXISTS public.waitlist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL UNIQUE,
    user_type TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc', now()),
    email_sent BOOLEAN DEFAULT false,
    email_sent_at TIMESTAMPTZ
);

-- Table: audit_log
-- Description: جدول سجل التدقيق
CREATE TABLE IF NOT EXISTS public.audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name TEXT NOT NULL,
    record_id UUID NOT NULL,
    action TEXT NOT NULL,
    old_data JSONB,
    new_data JSONB,
    user_id UUID REFERENCES public.users(id),
    created_at TIMESTAMP DEFAULT now()
);


-- ============================================================================
-- SECTION 4: INDEXES
-- ============================================================================

-- Indexes for users table
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users USING btree (email);
CREATE INDEX IF NOT EXISTS idx_users_user_type ON public.users USING btree (user_type);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON public.users USING btree (is_active);

-- Indexes for courses table
CREATE INDEX IF NOT EXISTS idx_courses_provider_id ON public.courses USING btree (provider_id);
CREATE INDEX IF NOT EXISTS idx_courses_status ON public.courses USING btree (status);
CREATE INDEX IF NOT EXISTS idx_courses_category ON public.courses USING btree (category);
CREATE INDEX IF NOT EXISTS idx_courses_level ON public.courses USING btree (level);
CREATE INDEX IF NOT EXISTS idx_courses_provider_status ON public.courses USING btree (provider_id, status);
CREATE INDEX IF NOT EXISTS idx_courses_cover_image_url ON public.courses USING btree (cover_image_url) WHERE (cover_image_url IS NOT NULL);

-- Indexes for modules table
CREATE INDEX IF NOT EXISTS idx_modules_course_id ON public.modules USING btree (course_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_modules_course_order ON public.modules USING btree (course_id, order_number);

-- Indexes for lessons table
CREATE INDEX IF NOT EXISTS idx_lessons_module_id ON public.lessons USING btree (module_id);
CREATE INDEX IF NOT EXISTS idx_lessons_course_id ON public.lessons USING btree (course_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_lessons_module_order ON public.lessons USING btree (module_id, order_number);

-- Indexes for lesson_resources table
CREATE INDEX IF NOT EXISTS idx_lesson_resources_lesson_id ON public.lesson_resources USING btree (lesson_id);

-- Indexes for enrollments table
CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON public.enrollments USING btree (student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON public.enrollments USING btree (course_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_status ON public.enrollments USING btree (status);
CREATE INDEX IF NOT EXISTS idx_enrollments_student_course ON public.enrollments USING btree (student_id, course_id);

-- Indexes for lesson_progress table
CREATE INDEX IF NOT EXISTS idx_lesson_progress_student_id ON public.lesson_progress USING btree (student_id);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_lesson_id ON public.lesson_progress USING btree (lesson_id);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_student_lesson ON public.lesson_progress USING btree (student_id, lesson_id);

-- Indexes for exams table
CREATE INDEX IF NOT EXISTS idx_exams_course_id ON public.exams USING btree (course_id);
CREATE INDEX IF NOT EXISTS idx_exams_module_id ON public.exams USING btree (module_id);
CREATE INDEX IF NOT EXISTS idx_exams_status ON public.exams USING btree (status);
CREATE UNIQUE INDEX IF NOT EXISTS idx_exams_course_module_order ON public.exams USING btree (course_id, COALESCE(module_id, '00000000-0000-0000-0000-000000000000'::uuid), order_number);

-- Indexes for exam_questions table
CREATE INDEX IF NOT EXISTS idx_exam_questions_exam_id ON public.exam_questions USING btree (exam_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_exam_questions_order ON public.exam_questions USING btree (exam_id, order_number);

-- Indexes for exam_results table
CREATE INDEX IF NOT EXISTS idx_exam_results_exam_id ON public.exam_results USING btree (exam_id);
CREATE INDEX IF NOT EXISTS idx_exam_results_student_id ON public.exam_results USING btree (student_id);
CREATE INDEX IF NOT EXISTS idx_exam_results_passed ON public.exam_results USING btree (passed);

-- Indexes for certificates table
CREATE INDEX IF NOT EXISTS idx_certificates_student_id ON public.certificates USING btree (student_id);
CREATE INDEX IF NOT EXISTS idx_certificates_course_id ON public.certificates USING btree (course_id);
CREATE INDEX IF NOT EXISTS idx_certificates_provider_id ON public.certificates USING btree (provider_id);
CREATE INDEX IF NOT EXISTS idx_certificates_status ON public.certificates USING btree (status);
CREATE INDEX IF NOT EXISTS idx_certificates_verification ON public.certificates USING btree (verification_code);
CREATE INDEX IF NOT EXISTS idx_certificates_certificate_number ON public.certificates USING btree (certificate_number);
CREATE INDEX IF NOT EXISTS idx_certificates_auto_issue ON public.certificates USING btree (auto_issue);
CREATE INDEX IF NOT EXISTS idx_certificates_student ON public.certificates USING btree (student_id);

-- Indexes for certificate_templates table
CREATE INDEX IF NOT EXISTS idx_certificate_templates_provider ON public.certificate_templates USING btree (provider_id);
CREATE INDEX IF NOT EXISTS idx_certificate_templates_course ON public.certificate_templates USING btree (course_id);

-- Indexes for payments table
CREATE INDEX IF NOT EXISTS idx_payments_student_id ON public.payments USING btree (student_id);
CREATE INDEX IF NOT EXISTS idx_payments_course_id ON public.payments USING btree (course_id);
CREATE INDEX IF NOT EXISTS idx_payments_provider_id ON public.payments USING btree (provider_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON public.payments USING btree (status);
CREATE INDEX IF NOT EXISTS idx_payments_student_status ON public.payments USING btree (student_id, status);
CREATE INDEX IF NOT EXISTS idx_payments_provider_status ON public.payments USING btree (provider_id, status);

-- Indexes for provider_payment_settings table
CREATE INDEX IF NOT EXISTS idx_provider_payment_settings_provider ON public.provider_payment_settings USING btree (provider_id);

-- Indexes for notifications table
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications USING btree (user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications USING btree (is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications USING btree (created_at);
CREATE INDEX IF NOT EXISTS idx_notifications_user_read ON public.notifications USING btree (user_id, is_read);

-- Indexes for reviews table
CREATE INDEX IF NOT EXISTS idx_reviews_course_id ON public.reviews USING btree (course_id);
CREATE INDEX IF NOT EXISTS idx_reviews_student_id ON public.reviews USING btree (student_id);
CREATE INDEX IF NOT EXISTS idx_reviews_course ON public.reviews USING btree (course_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_reviews_unique ON public.reviews USING btree (course_id, student_id);

-- Indexes for app_settings table
CREATE INDEX IF NOT EXISTS idx_app_settings_user_id ON public.app_settings USING btree (user_id);

-- Indexes for waitlist table
CREATE INDEX IF NOT EXISTS idx_waitlist_email ON public.waitlist USING btree (email);
CREATE INDEX IF NOT EXISTS idx_waitlist_created_at ON public.waitlist USING btree (created_at DESC);

-- ============================================================================
-- SECTION 5: FUNCTIONS
-- ============================================================================

-- Function: generate_verification_code
-- Description: توليد رمز تحقق فريد للشهادات
CREATE OR REPLACE FUNCTION public.generate_verification_code()
RETURNS text
LANGUAGE plpgsql
AS $function$
DECLARE
  code TEXT;
  exists BOOLEAN;
BEGIN
  LOOP
    code := 'WAS-' || LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
    SELECT EXISTS(SELECT 1 FROM certificates WHERE verification_code = code) INTO exists;
    EXIT WHEN NOT exists;
  END LOOP;
  RETURN code;
END;
$function$;

-- Function: set_verification_code
-- Description: تعيين رمز التحقق تلقائياً عند إنشاء شهادة
CREATE OR REPLACE FUNCTION public.set_verification_code()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.verification_code IS NULL THEN
    NEW.verification_code := generate_verification_code();
  END IF;
  RETURN NEW;
END;
$function$;

-- Function: update_enrollment_completed_at
-- Description: تحديث تاريخ إكمال التسجيل عند الوصول إلى 100%
CREATE OR REPLACE FUNCTION public.update_enrollment_completed_at()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.completion_percentage = 100 AND (OLD.completion_percentage < 100 OR OLD.completed_at IS NULL) THEN
    NEW.completed_at := NOW();
  END IF;
  RETURN NEW;
END;
$function$;

-- Function: update_course_students_count
-- Description: تحديث عدد الطلاب في الكورس
CREATE OR REPLACE FUNCTION public.update_course_students_count()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE courses SET students_count = students_count + 1 WHERE id = NEW.course_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE courses SET students_count = students_count - 1 WHERE id = OLD.course_id;
  END IF;
  RETURN NULL;
END;
$function$;

-- Function: update_provider_courses_count
-- Description: تحديث عدد الكورسات لمقدم الخدمة
CREATE OR REPLACE FUNCTION public.update_provider_courses_count()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE users SET courses_count = courses_count + 1 WHERE id = NEW.provider_id AND user_type = 'provider';
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE users SET courses_count = courses_count - 1 WHERE id = OLD.provider_id AND user_type = 'provider';
  END IF;
  RETURN NULL;
END;
$function$;

-- Function: update_provider_payment_settings_updated_at
-- Description: تحديث تاريخ آخر تعديل لإعدادات الدفع
CREATE OR REPLACE FUNCTION public.update_provider_payment_settings_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$function$;

-- Function: check_user_permission
-- Description: التحقق من صلاحيات المستخدم
CREATE OR REPLACE FUNCTION public.check_user_permission(required_permission text)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $function$
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
$function$;

-- Function: check_student_eligibility
-- Description: التحقق من أهلية الطالب للحصول على شهادة
CREATE OR REPLACE FUNCTION public.check_student_eligibility(p_student_id uuid, p_course_id uuid)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
DECLARE
  v_enrollment_exists BOOLEAN;
  v_progress INTEGER;
  v_exam_passed BOOLEAN;
BEGIN
  -- التحقق من التسجيل
  SELECT EXISTS(
    SELECT 1 FROM enrollments 
    WHERE student_id = p_student_id 
    AND course_id = p_course_id
    AND status = 'active'
  ) INTO v_enrollment_exists;
  
  IF NOT v_enrollment_exists THEN
    RETURN FALSE;
  END IF;
  
  -- التحقق من إكمال الكورس (100%)
  SELECT completion_percentage INTO v_progress
  FROM enrollments
  WHERE student_id = p_student_id 
  AND course_id = p_course_id;
  
  IF v_progress < 100 THEN
    RETURN FALSE;
  END IF;
  
  -- التحقق من النجاح في الامتحان (إذا وجد)
  SELECT EXISTS(
    SELECT 1 FROM exam_results er
    JOIN exams e ON er.exam_id = e.id
    WHERE e.course_id = p_course_id
    AND er.student_id = p_student_id
    AND er.passed = TRUE
  ) INTO v_exam_passed;
  
  -- إذا كان هناك امتحان، يجب النجاح فيه
  IF EXISTS(SELECT 1 FROM exams WHERE course_id = p_course_id) THEN
    RETURN v_exam_passed;
  END IF;
  
  -- إذا لم يكن هناك امتحان، الطالب مؤهل
  RETURN TRUE;
END;
$function$;

-- Function: get_eligible_students
-- Description: الحصول على قائمة الطلاب المؤهلين للحصول على شهادة
CREATE OR REPLACE FUNCTION public.get_eligible_students(p_course_id uuid)
RETURNS TABLE(student_id uuid, student_name text, student_email text, progress integer, exam_score integer, completion_date timestamp without time zone)
LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT 
    e.student_id,
    u.name,
    u.email,
    e.completion_percentage as progress,
    COALESCE(er.score, 0) as exam_score,
    e.completed_at as completion_date
  FROM enrollments e
  JOIN users u ON e.student_id = u.id
  LEFT JOIN (
    SELECT DISTINCT ON (er.student_id) 
      er.student_id,
      er.score,
      er.passed
    FROM exam_results er
    JOIN exams ex ON er.exam_id = ex.id
    WHERE ex.course_id = p_course_id
    ORDER BY er.student_id, er.created_at DESC
  ) er ON e.student_id = er.student_id
  WHERE e.course_id = p_course_id
  AND e.completion_percentage = 100
  AND e.status = 'active'
  AND (
    NOT EXISTS(SELECT 1 FROM exams WHERE course_id = p_course_id)
    OR er.passed = TRUE
  )
  AND NOT EXISTS(
    SELECT 1 FROM certificates 
    WHERE course_id = p_course_id 
    AND student_id = e.student_id
    AND status = 'issued'
  )
  ORDER BY e.completed_at DESC;
END;
$function$;


-- Function: auto_issue_certificate
-- Description: إصدار الشهادة تلقائياً عند استيفاء الشروط
CREATE OR REPLACE FUNCTION public.auto_issue_certificate()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
DECLARE
  course_record RECORD;
  student_record RECORD;
  provider_record RECORD;
  template_record RECORD;
  total_lessons INT;
  completed_lessons INT;
  exam_passed BOOLEAN;
  cert_exists BOOLEAN;
BEGIN
  -- التحقق من أن الطالب أكمل الكورس
  SELECT c.* INTO course_record FROM courses c WHERE c.id = NEW.course_id;
  SELECT u.* INTO student_record FROM users u WHERE u.id = NEW.student_id;
  SELECT u.* INTO provider_record FROM users u WHERE u.id = course_record.provider_id;
  
  -- حساب عدد الدروس المكتملة
  SELECT COUNT(*) INTO total_lessons 
  FROM lessons l 
  JOIN modules m ON l.module_id = m.id 
  WHERE m.course_id = NEW.course_id;
  
  SELECT COUNT(*) INTO completed_lessons
  FROM lesson_progress lp
  JOIN lessons l ON lp.lesson_id = l.id
  JOIN modules m ON l.module_id = m.id
  WHERE m.course_id = NEW.course_id 
    AND lp.student_id = NEW.student_id 
    AND lp.is_completed = true;
  
  -- التحقق من اجتياز الامتحان
  SELECT EXISTS(
    SELECT 1 FROM exam_results er
    JOIN exams e ON er.exam_id = e.id
    WHERE e.course_id = NEW.course_id
      AND er.student_id = NEW.student_id
      AND er.passed = true
  ) INTO exam_passed;
  
  -- التحقق من عدم وجود شهادة سابقة
  SELECT EXISTS(
    SELECT 1 FROM certificates
    WHERE course_id = NEW.course_id
      AND student_id = NEW.student_id
  ) INTO cert_exists;
  
  -- إصدار الشهادة إذا تحققت الشروط
  IF total_lessons > 0 AND completed_lessons = total_lessons AND exam_passed AND NOT cert_exists THEN
    -- جلب القالب الافتراضي
    SELECT * INTO template_record 
    FROM certificate_templates 
    WHERE provider_id = course_record.provider_id 
      AND (course_id = NEW.course_id OR course_id IS NULL)
      AND is_default = true
    LIMIT 1;
    
    INSERT INTO certificates (
      course_id,
      student_id,
      student_name,
      student_email,
      course_name,
      provider_id,
      provider_name,
      certificate_number,
      issue_date,
      completion_date,
      status,
      is_auto_issued,
      template_data
    ) VALUES (
      NEW.course_id,
      NEW.student_id,
      student_record.name,
      student_record.email,
      course_record.title,
      course_record.provider_id,
      provider_record.name,
      'CERT-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 10)),
      NOW(),
      NOW(),
      'issued',
      true,
      COALESCE(template_record.template_data, '{}'::jsonb)
    );
  END IF;
  
  RETURN NEW;
END;
$function$;

-- Function: update_payment_status
-- Description: تحديث حالة الدفع وتفعيل وصول الطالب
CREATE OR REPLACE FUNCTION public.update_payment_status(p_payment_id uuid, p_new_status text, p_verified_by uuid, p_rejection_reason text DEFAULT NULL::text)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
DECLARE
  v_student_id UUID;
  v_course_id UUID;
  v_provider_id UUID;
  v_course_name TEXT;
  v_old_status TEXT;
BEGIN
  -- جلب معلومات الدفع
  SELECT student_id, course_id, provider_id, status
  INTO v_student_id, v_course_id, v_provider_id, v_old_status
  FROM payments
  WHERE id = p_payment_id;
  
  -- التحقق من وجود الدفع
  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;
  
  -- تحديث حالة الدفع
  UPDATE payments
  SET 
    status = p_new_status,
    verified_by = p_verified_by,
    verified_at = NOW(),
    rejection_reason = p_rejection_reason,
    updated_at = NOW()
  WHERE id = p_payment_id;
  
  -- إذا تم تأكيد الدفع، تفعيل وصول الطالب للكورس
  IF p_new_status = 'completed' THEN
    -- التحقق من وجود تسجيل
    IF EXISTS (SELECT 1 FROM enrollments WHERE student_id = v_student_id AND course_id = v_course_id) THEN
      -- تحديث التسجيل الموجود
      UPDATE enrollments
      SET 
        status = 'active',
        payment_status = 'paid',
        updated_at = NOW()
      WHERE student_id = v_student_id AND course_id = v_course_id;
    ELSE
      -- إنشاء تسجيل جديد
      INSERT INTO enrollments (
        student_id,
        course_id,
        enrollment_date,
        status,
        payment_status,
        completion_percentage
      ) VALUES (
        v_student_id,
        v_course_id,
        NOW(),
        'active',
        'paid',
        0
      );
    END IF;
    
    -- جلب اسم الكورس
    SELECT title INTO v_course_name FROM courses WHERE id = v_course_id;
    
    -- إرسال إشعار للطالب بالموافقة
    INSERT INTO notifications (
      user_id,
      title,
      message,
      type,
      related_id,
      is_read,
      created_at
    ) VALUES (
      v_student_id,
      'تم تأكيد الدفع',
      'تم تأكيد دفعتك للكورس "' || v_course_name || '". يمكنك الآن الوصول إلى محتوى الكورس.',
      'payment',
      v_course_id,
      FALSE,
      NOW()
    );
    
  ELSIF p_new_status = 'failed' THEN
    -- إرسال إشعار للطالب بالرفض
    SELECT title INTO v_course_name FROM courses WHERE id = v_course_id;
    
    INSERT INTO notifications (
      user_id,
      title,
      message,
      type,
      related_id,
      is_read,
      created_at
    ) VALUES (
      v_student_id,
      'تم رفض الدفع',
      'تم رفض دفعتك للكورس "' || v_course_name || '". ' || COALESCE('السبب: ' || p_rejection_reason, 'يرجى التواصل مع مقدم الخدمة.'),
      'payment',
      v_course_id,
      FALSE,
      NOW()
    );
  END IF;
  
  RETURN TRUE;
END;
$function$;

-- Function: handle_new_user
-- Description: إنشاء سجل مستخدم في جدول users عند التسجيل في auth
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  v_user_type TEXT;
  v_name      TEXT;
  v_phone     TEXT;
BEGIN
  v_user_type := COALESCE(NEW.raw_user_meta_data->>'user_type', 'provider');
  v_name      := COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1));
  v_phone     := NEW.raw_user_meta_data->>'phone';

  IF v_user_type NOT IN ('student', 'provider', 'admin') THEN
    v_user_type := 'provider';
  END IF;

  INSERT INTO public.users (
    id, email, name, phone, user_type,
    is_verified, is_active,
    courses_enrolled, certificates_count, total_spent,
    courses_count, students_count, total_earnings,
    created_at, updated_at
  )
  VALUES (
    NEW.id, NEW.email, v_name, v_phone, v_user_type,
    FALSE, TRUE,
    0, 0, 0,
    0, 0, 0,
    NOW(), NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$function$;

-- Function: rls_auto_enable
-- Description: تفعيل RLS تلقائياً على الجداول الجديدة
CREATE OR REPLACE FUNCTION public.rls_auto_enable()
RETURNS event_trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'pg_catalog'
AS $function$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$function$;

-- ============================================================================
-- SECTION 6: TRIGGERS
-- ============================================================================

-- Trigger: trigger_set_verification_code
-- Description: تعيين رمز التحقق تلقائياً للشهادات
CREATE TRIGGER trigger_set_verification_code
  BEFORE INSERT ON public.certificates
  FOR EACH ROW
  EXECUTE FUNCTION set_verification_code();

-- Trigger: trigger_update_completed_at
-- Description: تحديث تاريخ الإكمال عند الوصول إلى 100%
CREATE TRIGGER trigger_update_completed_at
  BEFORE UPDATE OF completion_percentage ON public.enrollments
  FOR EACH ROW
  EXECUTE FUNCTION update_enrollment_completed_at();

-- Trigger: trigger_update_course_students_count
-- Description: تحديث عدد الطلاب في الكورس
CREATE TRIGGER trigger_update_course_students_count
  AFTER INSERT OR DELETE ON public.enrollments
  FOR EACH ROW
  EXECUTE FUNCTION update_course_students_count();

-- Trigger: trigger_update_provider_courses_count
-- Description: تحديث عدد الكورسات لمقدم الخدمة
CREATE TRIGGER trigger_update_provider_courses_count
  AFTER INSERT OR DELETE ON public.courses
  FOR EACH ROW
  EXECUTE FUNCTION update_provider_courses_count();

-- Trigger: trigger_update_provider_payment_settings_updated_at
-- Description: تحديث تاريخ آخر تعديل لإعدادات الدفع
CREATE TRIGGER trigger_update_provider_payment_settings_updated_at
  BEFORE UPDATE ON public.provider_payment_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_provider_payment_settings_updated_at();

-- Trigger: trigger_auto_issue_certificate (enrollments)
-- Description: إصدار الشهادة تلقائياً عند إكمال الكورس
CREATE TRIGGER trigger_auto_issue_certificate
  AFTER UPDATE OF completion_percentage ON public.enrollments
  FOR EACH ROW
  WHEN ((new.completion_percentage = 100) AND (old.completion_percentage < 100))
  EXECUTE FUNCTION auto_issue_certificate();

-- Trigger: trigger_auto_issue_certificate (lesson_progress)
-- Description: إصدار الشهادة تلقائياً عند إكمال درس
CREATE TRIGGER trigger_auto_issue_certificate
  AFTER INSERT OR UPDATE ON public.lesson_progress
  FOR EACH ROW
  WHEN ((new.is_completed = true))
  EXECUTE FUNCTION auto_issue_certificate();

-- ============================================================================
-- SECTION 7: ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exam_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exam_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.certificates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.certificate_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.provider_payment_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.waitlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users table
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Everyone can view providers" ON public.users
  FOR SELECT USING (user_type = 'provider' OR auth.uid() = id);

-- RLS Policies for courses table
CREATE POLICY "Providers can view their courses" ON public.courses
  FOR SELECT USING (provider_id = auth.uid());

CREATE POLICY "Providers can insert their courses" ON public.courses
  FOR INSERT WITH CHECK (provider_id = auth.uid());

CREATE POLICY "Providers can update their courses" ON public.courses
  FOR UPDATE USING (provider_id = auth.uid());

CREATE POLICY "Providers can delete their courses" ON public.courses
  FOR DELETE USING (provider_id = auth.uid());

CREATE POLICY "Students can view published courses" ON public.courses
  FOR SELECT USING (status = 'published' OR provider_id = auth.uid());

-- RLS Policies for modules table
CREATE POLICY "Providers can view modules" ON public.modules
  FOR SELECT USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can insert modules" ON public.modules
  FOR INSERT WITH CHECK (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can update modules" ON public.modules
  FOR UPDATE USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can delete modules" ON public.modules
  FOR DELETE USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Students can view modules" ON public.modules
  FOR SELECT USING (
    course_id IN (SELECT id FROM courses WHERE status = 'published') 
    OR course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid())
  );

-- RLS Policies for lessons table
CREATE POLICY "Providers can view lessons" ON public.lessons
  FOR SELECT USING (module_id IN (SELECT m.id FROM modules m JOIN courses c ON m.course_id = c.id WHERE c.provider_id = auth.uid()));

CREATE POLICY "Providers can insert lessons" ON public.lessons
  FOR INSERT WITH CHECK (module_id IN (SELECT m.id FROM modules m JOIN courses c ON m.course_id = c.id WHERE c.provider_id = auth.uid()));

CREATE POLICY "Providers can update lessons" ON public.lessons
  FOR UPDATE USING (module_id IN (SELECT m.id FROM modules m JOIN courses c ON m.course_id = c.id WHERE c.provider_id = auth.uid()));

CREATE POLICY "Providers can delete lessons" ON public.lessons
  FOR DELETE USING (module_id IN (SELECT m.id FROM modules m JOIN courses c ON m.course_id = c.id WHERE c.provider_id = auth.uid()));

CREATE POLICY "Students can view lessons" ON public.lessons
  FOR SELECT USING (
    course_id IN (SELECT id FROM courses WHERE status = 'published')
    OR course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid())
  );

-- RLS Policies for lesson_resources table
CREATE POLICY "Providers can add lesson resources" ON public.lesson_resources
  FOR INSERT WITH CHECK (EXISTS (
    SELECT 1 FROM lessons l JOIN courses c ON c.id = l.course_id 
    WHERE l.id = lesson_resources.lesson_id AND c.provider_id = auth.uid()
  ));

CREATE POLICY "Providers can update lesson resources" ON public.lesson_resources
  FOR UPDATE USING (EXISTS (
    SELECT 1 FROM lessons l JOIN courses c ON c.id = l.course_id 
    WHERE l.id = lesson_resources.lesson_id AND c.provider_id = auth.uid()
  ));

CREATE POLICY "Providers can delete lesson resources" ON public.lesson_resources
  FOR DELETE USING (EXISTS (
    SELECT 1 FROM lessons l JOIN courses c ON c.id = l.course_id 
    WHERE l.id = lesson_resources.lesson_id AND c.provider_id = auth.uid()
  ));

CREATE POLICY "Students can view lesson resources" ON public.lesson_resources
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM enrollments e JOIN lessons l ON l.course_id = e.course_id 
      WHERE l.id = lesson_resources.lesson_id AND e.student_id = auth.uid() AND e.status = 'active'
    )
    OR EXISTS (
      SELECT 1 FROM lessons l JOIN courses c ON c.id = l.course_id 
      WHERE l.id = lesson_resources.lesson_id AND c.provider_id = auth.uid()
    )
  );


-- RLS Policies for enrollments table
CREATE POLICY "Users can view their own enrollments" ON public.enrollments
  FOR SELECT TO authenticated USING (student_id = auth.uid());

CREATE POLICY "Users can insert their own enrollments" ON public.enrollments
  FOR INSERT TO authenticated WITH CHECK (
    student_id = auth.uid() 
    AND EXISTS (SELECT 1 FROM courses WHERE id = enrollments.course_id AND status = 'published')
  );

CREATE POLICY "Users can update their own enrollments" ON public.enrollments
  FOR UPDATE TO authenticated USING (student_id = auth.uid()) WITH CHECK (student_id = auth.uid());

CREATE POLICY "Students can view their enrollments" ON public.enrollments
  FOR SELECT USING (student_id = auth.uid());

CREATE POLICY "Providers can view enrollments for their courses" ON public.enrollments
  FOR SELECT TO authenticated USING (EXISTS (
    SELECT 1 FROM courses WHERE courses.id = enrollments.course_id AND courses.provider_id = auth.uid()
  ));

CREATE POLICY "Providers can view their students" ON public.enrollments
  FOR SELECT USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can update enrollments" ON public.enrollments
  FOR UPDATE USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

-- RLS Policies for lesson_progress table
CREATE POLICY "Students can view their progress" ON public.lesson_progress
  FOR SELECT USING (student_id = auth.uid());

-- RLS Policies for exams table
CREATE POLICY "Providers can view exams" ON public.exams
  FOR SELECT USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can insert exams" ON public.exams
  FOR INSERT WITH CHECK (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can update exams" ON public.exams
  FOR UPDATE USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can delete exams" ON public.exams
  FOR DELETE USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

-- RLS Policies for exam_questions table
CREATE POLICY "Providers can view exam questions" ON public.exam_questions
  FOR SELECT USING (exam_id IN (
    SELECT e.id FROM exams e JOIN courses c ON e.course_id = c.id WHERE c.provider_id = auth.uid()
  ));

CREATE POLICY "Providers can insert exam questions" ON public.exam_questions
  FOR INSERT WITH CHECK (exam_id IN (
    SELECT e.id FROM exams e JOIN courses c ON e.course_id = c.id WHERE c.provider_id = auth.uid()
  ));

CREATE POLICY "Providers can update exam questions" ON public.exam_questions
  FOR UPDATE USING (exam_id IN (
    SELECT e.id FROM exams e JOIN courses c ON e.course_id = c.id WHERE c.provider_id = auth.uid()
  ));

CREATE POLICY "Providers can delete exam questions" ON public.exam_questions
  FOR DELETE USING (exam_id IN (
    SELECT e.id FROM exams e JOIN courses c ON e.course_id = c.id WHERE c.provider_id = auth.uid()
  ));

-- RLS Policies for exam_results table
CREATE POLICY "Students can view their exam results" ON public.exam_results
  FOR SELECT USING (student_id = auth.uid());

CREATE POLICY "Providers can view exam results for their courses" ON public.exam_results
  FOR SELECT USING (exam_id IN (
    SELECT exams.id FROM exams WHERE exams.course_id IN (
      SELECT courses.id FROM courses WHERE courses.provider_id = auth.uid()
    )
  ));

-- RLS Policies for certificates table
CREATE POLICY "Students can view their certificates" ON public.certificates
  FOR SELECT USING (student_id = auth.uid());

CREATE POLICY "Students can view own certificates" ON public.certificates
  FOR SELECT USING (
    student_id = auth.uid() 
    OR provider_id = auth.uid() 
    OR EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND user_type = 'admin')
  );

CREATE POLICY "Providers can view certificates" ON public.certificates
  FOR SELECT USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can insert certificates" ON public.certificates
  FOR INSERT WITH CHECK (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can update certificates" ON public.certificates
  FOR UPDATE USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

-- RLS Policies for certificate_templates table
CREATE POLICY "Providers can view their templates" ON public.certificate_templates
  FOR SELECT USING (provider_id = auth.uid());

CREATE POLICY "Providers can insert their templates" ON public.certificate_templates
  FOR INSERT WITH CHECK (provider_id = auth.uid());

CREATE POLICY "Providers can update their templates" ON public.certificate_templates
  FOR UPDATE USING (provider_id = auth.uid());

CREATE POLICY "Providers can delete their templates" ON public.certificate_templates
  FOR DELETE USING (provider_id = auth.uid());

-- RLS Policies for payments table
CREATE POLICY "Students can view own payments" ON public.payments
  FOR SELECT USING (
    student_id = auth.uid() 
    OR provider_id = auth.uid() 
    OR EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND user_type = 'admin')
  );

CREATE POLICY "Providers can view payments" ON public.payments
  FOR SELECT USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

CREATE POLICY "Providers can update payments" ON public.payments
  FOR UPDATE USING (course_id IN (SELECT id FROM courses WHERE provider_id = auth.uid()));

-- RLS Policies for provider_payment_settings table
CREATE POLICY "Providers can view their payment settings" ON public.provider_payment_settings
  FOR SELECT USING (provider_id = auth.uid());

CREATE POLICY "Providers can insert their payment settings" ON public.provider_payment_settings
  FOR INSERT WITH CHECK (provider_id = auth.uid());

CREATE POLICY "Providers can update their payment settings" ON public.provider_payment_settings
  FOR UPDATE USING (provider_id = auth.uid());

CREATE POLICY "provider_payment_settings_select_policy" ON public.provider_payment_settings
  FOR SELECT USING (provider_id = auth.uid());

CREATE POLICY "provider_payment_settings_insert_policy" ON public.provider_payment_settings
  FOR INSERT WITH CHECK (provider_id = auth.uid());

CREATE POLICY "provider_payment_settings_update_policy" ON public.provider_payment_settings
  FOR UPDATE USING (provider_id = auth.uid());

-- RLS Policies for notifications table
CREATE POLICY "Students can view their notifications" ON public.notifications
  FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert notifications" ON public.notifications
  FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their notifications" ON public.notifications
  FOR UPDATE USING (user_id = auth.uid());

-- RLS Policies for reviews table
CREATE POLICY "Students can view all reviews" ON public.reviews
  FOR SELECT USING (true);

CREATE POLICY "Students can add reviews" ON public.reviews
  FOR INSERT WITH CHECK (
    auth.uid() = student_id 
    AND EXISTS (
      SELECT 1 FROM enrollments 
      WHERE enrollments.student_id = auth.uid() 
      AND enrollments.course_id = reviews.course_id 
      AND enrollments.status IN ('active', 'completed')
    )
  );

CREATE POLICY "Students can update own reviews" ON public.reviews
  FOR UPDATE USING (auth.uid() = student_id);

CREATE POLICY "Students can delete own reviews" ON public.reviews
  FOR DELETE USING (
    auth.uid() = student_id 
    OR EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND user_type = 'admin')
  );

-- RLS Policies for app_settings table
CREATE POLICY "Users can view their settings" ON public.app_settings
  FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert their settings" ON public.app_settings
  FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their settings" ON public.app_settings
  FOR UPDATE USING (user_id = auth.uid());

-- RLS Policies for waitlist table
CREATE POLICY "Enable read access for all users" ON public.waitlist
  FOR SELECT USING (true);

CREATE POLICY "Anyone can join waitlist" ON public.waitlist
  FOR INSERT WITH CHECK (
    email IS NOT NULL 
    AND email <> '' 
    AND email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
  );

CREATE POLICY "Allow select for authenticated users" ON public.waitlist
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow update for authenticated users" ON public.waitlist
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Only admins can view waitlist" ON public.waitlist
  FOR SELECT USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND user_type = 'admin'));

CREATE POLICY "Only admins can update waitlist" ON public.waitlist
  FOR UPDATE USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND user_type = 'admin'));

CREATE POLICY "Only admins can delete waitlist" ON public.waitlist
  FOR DELETE USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND user_type = 'admin'));

-- RLS Policies for audit_log table
CREATE POLICY "Only admins can view audit log" ON public.audit_log
  FOR SELECT USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND user_type = 'admin'));

-- ============================================================================
-- SECTION 8: STORAGE BUCKETS
-- ============================================================================

-- Note: Storage buckets are managed through Supabase Storage API
-- The following are the bucket configurations that should be created:

-- Bucket: avatars
-- Description: صور المستخدمين الشخصية
-- Public: true
-- File size limit: null (unlimited)
-- Allowed MIME types: null (all types)

-- Bucket: certificates
-- Description: ملفات الشهادات
-- Public: true
-- File size limit: null (unlimited)
-- Allowed MIME types: null (all types)

-- Bucket: course-files
-- Description: ملفات الكورسات (مستندات، ملفات مرفقة)
-- Public: true
-- File size limit: null (unlimited)
-- Allowed MIME types: null (all types)

-- Bucket: course-images
-- Description: صور الكورسات (أغلفة، صور توضيحية)
-- Public: true
-- File size limit: null (unlimited)
-- Allowed MIME types: null (all types)

-- Bucket: course-videos
-- Description: فيديوهات الكورسات
-- Public: true
-- File size limit: null (unlimited)
-- Allowed MIME types: null (all types)

-- To create these buckets, use the Supabase Dashboard or API:
-- INSERT INTO storage.buckets (id, name, public) VALUES 
--   ('avatars', 'avatars', true),
--   ('certificates', 'certificates', true),
--   ('course-files', 'course-files', true),
--   ('course-images', 'course-images', true),
--   ('course-videos', 'course-videos', true);

-- ============================================================================
-- SECTION 9: AUTH TRIGGERS
-- ============================================================================

-- Note: This trigger should be created on auth.users table
-- It automatically creates a user record in public.users when a new user signs up

-- CREATE TRIGGER on_auth_user_created
--   AFTER INSERT ON auth.users
--   FOR EACH ROW
--   EXECUTE FUNCTION public.handle_new_user();

-- ============================================================================
-- SECTION 10: ADDITIONAL NOTES
-- ============================================================================

-- 1. Extensions:
--    - uuid-ossp: For UUID generation
--    - pgcrypto: For cryptographic functions
--    - pg_stat_statements: For query performance monitoring
--    - pg_graphql: For GraphQL support
--    - supabase_vault: For secure secrets storage

-- 2. Row Level Security (RLS):
--    - All tables have RLS enabled
--    - Policies are configured to ensure data isolation between users
--    - Providers can only access their own courses and related data
--    - Students can only access their own enrollments and progress
--    - Admins have full access to audit logs

-- 3. Triggers:
--    - Auto-generate verification codes for certificates
--    - Auto-update completion dates when progress reaches 100%
--    - Auto-update student/course counts
--    - Auto-issue certificates when conditions are met

-- 4. Functions:
--    - Certificate verification code generation
--    - Student eligibility checking
--    - Payment status updates with notifications
--    - User permission checking

-- 5. Storage Buckets:
--    - avatars: User profile images
--    - certificates: Certificate files
--    - course-files: Course documents and attachments
--    - course-images: Course cover images and thumbnails
--    - course-videos: Course video content

-- 6. Indexes:
--    - Optimized for common query patterns
--    - Composite indexes for frequently joined columns
--    - Unique indexes for business constraints

-- ============================================================================
-- END OF BACKUP FILE
-- ============================================================================

-- To restore this database:
-- 1. Create a new Supabase project
-- 2. Run this SQL file in the SQL Editor
-- 3. Create storage buckets through the Dashboard or API
-- 4. Configure auth triggers if needed
-- 5. Test all functionality

-- For questions or issues, refer to Supabase documentation:
-- https://supabase.com/docs
