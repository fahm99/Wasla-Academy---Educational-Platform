-- قاعدة بيانات منصة واصلة التعليمية - مطبقة لـ 3NF
-- إنشاء extension لـ UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- إنشاء الأنواع المخصصة (Custom Types)
CREATE TYPE user_role AS ENUM ('student', 'admin');
CREATE TYPE provider_type AS ENUM ('university', 'institute', 'trainer');
CREATE TYPE provider_status AS ENUM ('pending', 'active', 'suspended', 'rejected');
CREATE TYPE subscription_status AS ENUM ('pending', 'paid', 'overdue', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed', 'refunded');
CREATE TYPE document_status AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE course_status AS ENUM ('draft', 'published', 'archived');
CREATE TYPE course_level AS ENUM ('beginner', 'intermediate', 'advanced');
CREATE TYPE lesson_type AS ENUM ('video', 'text', 'quiz', 'assignment');
CREATE TYPE enrollment_status AS ENUM ('active', 'completed', 'cancelled');
CREATE TYPE exam_type AS ENUM ('quiz', 'midterm', 'final');
CREATE TYPE question_type AS ENUM ('multiple_choice', 'true_false', 'essay', 'fill_blank');
CREATE TYPE certificate_status AS ENUM ('pending', 'issued', 'revoked');
CREATE TYPE notification_type AS ENUM ('system', 'course', 'payment', 'certificate');
CREATE TYPE message_type AS ENUM ('text', 'file', 'system');
CREATE TYPE gender_type AS ENUM ('male', 'female');

-- جدول الدول
CREATE TABLE countries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_ar TEXT NOT NULL,
    name_en TEXT NOT NULL,
    code VARCHAR(3) UNIQUE NOT NULL,
    phone_code VARCHAR(5),
    currency_code VARCHAR(3),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول المحافظات/الولايات
CREATE TABLE states (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    country_id UUID NOT NULL REFERENCES countries(id) ON DELETE CASCADE,
    name_ar TEXT NOT NULL,
    name_en TEXT,
    code VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول المدن
CREATE TABLE cities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    state_id UUID NOT NULL REFERENCES states(id) ON DELETE CASCADE,
    name_ar TEXT NOT NULL,
    name_en TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول العناوين
CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    city_id UUID NOT NULL REFERENCES cities(id) ON DELETE CASCADE,
    street_address TEXT,
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول فئات الكورسات
CREATE TABLE course_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_ar TEXT NOT NULL,
    name_en TEXT NOT NULL,
    description_ar TEXT,
    description_en TEXT,
    icon_url TEXT,
    parent_id UUID REFERENCES course_categories(id),
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول التخصصات
CREATE TABLE specializations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_ar TEXT NOT NULL,
    name_en TEXT NOT NULL,
    description_ar TEXT,
    description_en TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول المستخدمين (الطلاب والمشرفين)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT,
    phone TEXT,
    role user_role NOT NULL DEFAULT 'student',
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول الملفات الشخصية للمستخدمين
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    full_name TEXT GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
    date_of_birth DATE,
    gender gender_type,
    avatar_url TEXT,
    bio TEXT,
    address_id UUID REFERENCES addresses(id),
    national_id VARCHAR(20),
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT,
    preferred_language VARCHAR(2) DEFAULT 'ar',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    UNIQUE(user_id)
);

-- جدول مقدمي الخدمات
CREATE TABLE providers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT,
    phone TEXT,
    type provider_type NOT NULL,
    status provider_status DEFAULT 'pending',
    subscription_fee DECIMAL(10,2) DEFAULT 0,
    subscription_status subscription_status DEFAULT 'pending',
    subscription_expires_at TIMESTAMP WITH TIME ZONE,
    documents_status document_status DEFAULT 'pending',
    rejection_reason TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول الملفات الشخصية لمقدمي الخدمات
CREATE TABLE provider_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES providers(id) ON DELETE CASCADE,
    organization_name TEXT NOT NULL,
    display_name TEXT,
    description_ar TEXT,
    description_en TEXT,
    logo_url TEXT,
    website_url TEXT,
    establishment_year INTEGER,
    license_number TEXT,
    address_id UUID REFERENCES addresses(id),
    contact_person_name TEXT,
    contact_person_title TEXT,
    bank_account_name TEXT,
    bank_account_number TEXT,
    bank_name TEXT,
    iban TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    UNIQUE(provider_id)
);

-- جدول تخصصات مقدمي الخدمات
CREATE TABLE provider_specializations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES providers(id) ON DELETE CASCADE,
    specialization_id UUID NOT NULL REFERENCES specializations(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    UNIQUE(provider_id, specialization_id)
);

-- جدول الكورسات
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES providers(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES course_categories(id),
    title TEXT NOT NULL,
    description TEXT,
    thumbnail_url TEXT,
    level course_level NOT NULL,
    price DECIMAL(10,2) DEFAULT 0,
    duration_hours INTEGER DEFAULT 0,
    language VARCHAR(2) DEFAULT 'ar',
    status course_status DEFAULT 'draft',
    is_featured BOOLEAN DEFAULT FALSE,
    enrollment_count INTEGER DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0,
    reviews_count INTEGER DEFAULT 0,
    max_students INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول متطلبات الكورس
CREATE TABLE course_requirements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    requirement_text TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول مخرجات التعلم
CREATE TABLE learning_outcomes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    outcome_text TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول أقسام الكورس
CREATE TABLE course_sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    section_order INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول الدروس
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    section_id UUID REFERENCES course_sections(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,
    content TEXT,
    video_url TEXT,
    video_duration_seconds INTEGER DEFAULT 0,
    lesson_order INTEGER NOT NULL,
    type lesson_type DEFAULT 'video',
    is_preview BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول موارد الدروس
CREATE TABLE lesson_resources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    file_url TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size INTEGER,
    mime_type TEXT,
    download_count INTEGER DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول التسجيلات
CREATE TABLE enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    status enrollment_status DEFAULT 'active',
    progress_percentage INTEGER DEFAULT 0,
    completed_lessons INTEGER DEFAULT 0,
    total_lessons INTEGER DEFAULT 0,
    enrollment_date TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    completion_date TIMESTAMP WITH TIME ZONE,
    certificate_eligible BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    UNIQUE(user_id, course_id)
);

-- جدول تقدم الطلاب
CREATE TABLE lesson_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    enrollment_id UUID NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    is_completed BOOLEAN DEFAULT FALSE,
    watch_time_seconds INTEGER DEFAULT 0,
    last_position_seconds INTEGER DEFAULT 0,
    completion_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    UNIQUE(user_id, lesson_id)
);

-- جدول الامتحانات
CREATE TABLE exams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    section_id UUID REFERENCES course_sections(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,
    instructions TEXT,
    type exam_type DEFAULT 'quiz',
    duration_minutes INTEGER DEFAULT 60,
    total_questions INTEGER DEFAULT 0,
    total_points INTEGER DEFAULT 0,
    passing_score INTEGER DEFAULT 70,
    max_attempts INTEGER DEFAULT 3,
    is_active BOOLEAN DEFAULT TRUE,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول الأسئلة
CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    exam_id UUID NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    type question_type NOT NULL,
    points INTEGER DEFAULT 1,
    explanation TEXT,
    question_order INTEGER NOT NULL,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول خيارات الأسئلة
CREATE TABLE question_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    option_order INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول محاولات الامتحانات
CREATE TABLE exam_attempts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    exam_id UUID NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    enrollment_id UUID NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    attempt_number INTEGER DEFAULT 1,
    score INTEGER DEFAULT 0,
    total_score INTEGER DEFAULT 0,
    percentage DECIMAL(5,2) DEFAULT 0,
    is_passed BOOLEAN DEFAULT FALSE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    submitted_at TIMESTAMP WITH TIME ZONE,
    time_taken_minutes INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول إجابات الطلاب
CREATE TABLE student_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    attempt_id UUID NOT NULL REFERENCES exam_attempts(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    selected_option_id UUID REFERENCES question_options(id),
    answer_text TEXT,
    is_correct BOOLEAN DEFAULT FALSE,
    points_earned INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول قوالب الشهادات
CREATE TABLE certificate_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    template_url TEXT NOT NULL,
    background_image_url TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول الشهادات
CREATE TABLE certificates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    enrollment_id UUID NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    template_id UUID REFERENCES certificate_templates(id),
    certificate_number TEXT UNIQUE NOT NULL,
    status certificate_status DEFAULT 'pending',
    issue_date TIMESTAMP WITH TIME ZONE,
    expiry_date TIMESTAMP WITH TIME ZONE,
    certificate_data JSONB DEFAULT '{}',
    download_count INTEGER DEFAULT 0,
    verification_code TEXT UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول المدفوعات
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    provider_id UUID REFERENCES providers(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'YER',
    payment_method TEXT,
    transaction_id TEXT UNIQUE,
    status payment_status DEFAULT 'pending',
    payment_gateway TEXT,
    gateway_response JSONB DEFAULT '{}',
    notes TEXT,
    processed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول اشتراكات مقدمي الخدمات
CREATE TABLE provider_subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES providers(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'YER',
    payment_method TEXT,
    bank_reference TEXT,
    payment_date TIMESTAMP WITH TIME ZONE,
    status subscription_status DEFAULT 'pending',
    valid_from TIMESTAMP WITH TIME ZONE,
    valid_until TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    admin_notes TEXT,
    reviewed_by UUID REFERENCES users(id),
    reviewed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول التقييمات
CREATE TABLE course_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    enrollment_id UUID NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_title TEXT,
    review_comment TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    is_flagged BOOLEAN DEFAULT FALSE,
    flag_reason TEXT,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    UNIQUE(user_id, course_id)
);

-- جدول المحادثات
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    provider_id UUID REFERENCES providers(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    subject TEXT,
    last_message_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول الرسائل
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id UUID,
    sender_type TEXT NOT NULL CHECK (sender_type IN ('user', 'provider', 'system')),
    message_text TEXT,
    type message_type DEFAULT 'text',
    attachments JSONB DEFAULT '[]',
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول الإشعارات
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipient_id UUID,
    recipient_type TEXT NOT NULL CHECK (recipient_type IN ('user', 'provider', 'admin')),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type notification_type DEFAULT 'system',
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,
    action_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول أنواع الوثائق
CREATE TABLE document_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_ar TEXT NOT NULL,
    name_en TEXT NOT NULL,
    description_ar TEXT,
    description_en TEXT,
    is_required BOOLEAN DEFAULT TRUE,
    allowed_file_types TEXT[] DEFAULT ARRAY['pdf', 'jpg', 'jpeg', 'png'],
    max_file_size_mb INTEGER DEFAULT 5,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول الوثائق
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES providers(id) ON DELETE CASCADE,
    document_type_id UUID NOT NULL REFERENCES document_types(id),
    file_url TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size INTEGER,
    mime_type TEXT,
    status document_status DEFAULT 'pending',
    notes TEXT,
    rejection_reason TEXT,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    reviewed_at TIMESTAMP WITH TIME ZONE,
    reviewed_by UUID REFERENCES users(id)
);

-- جدول الملفات
CREATE TABLE files (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    uploader_id UUID,
    uploader_type TEXT CHECK (uploader_type IN ('user', 'provider')),
    file_name TEXT NOT NULL,
    original_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_size INTEGER,
    mime_type TEXT,
    category TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    upload_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- جدول سجل الأنشطة
CREATE TABLE activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    actor_id UUID,
    actor_type TEXT CHECK (actor_type IN ('user', 'provider', 'admin')),
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id UUID,
    details JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- إنشاء الفهارس
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_providers_email ON providers(email);
CREATE INDEX idx_providers_status ON providers(status);
CREATE INDEX idx_providers_type ON providers(type);
CREATE INDEX idx_provider_profiles_provider_id ON provider_profiles(provider_id);
CREATE INDEX idx_courses_provider_id ON courses(provider_id);
CREATE INDEX idx_courses_category_id ON courses(category_id);
CREATE INDEX idx_courses_status ON courses(status);
CREATE INDEX idx_courses_featured ON courses(is_featured);
CREATE INDEX idx_lessons_course_id ON lessons(course_id);
CREATE INDEX idx_lessons_section_id ON lessons(section_id);
CREATE INDEX idx_enrollments_user_id ON enrollments(user_id);
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_enrollments_status ON enrollments(status);
CREATE INDEX idx_lesson_progress_user_id ON lesson_progress(user_id);
CREATE INDEX idx_lesson_progress_lesson_id ON lesson_progress(lesson_id);
CREATE INDEX idx_lesson_progress_enrollment_id ON lesson_progress(enrollment_id);
CREATE INDEX idx_notifications_recipient ON notifications(recipient_id, recipient_type);
CREATE INDEX idx_notifications_unread ON notifications(recipient_id, is_read);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_course_reviews_course_id ON course_reviews(course_id);
CREATE INDEX idx_course_reviews_user_id ON course_reviews(user_id);
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_activity_logs_actor ON activity_logs(actor_id, actor_type);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);

-- إنشاء الدوال المساعدة

-- دالة لتحديث timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc', NOW());
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- إنشاء المشاعيل (Triggers) لتحديث updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_providers_updated_at BEFORE UPDATE ON providers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_provider_profiles_updated_at BEFORE UPDATE ON provider_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lessons_updated_at BEFORE UPDATE ON lessons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lesson_progress_updated_at BEFORE UPDATE ON lesson_progress FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_enrollments_updated_at BEFORE UPDATE ON enrollments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_provider_subscriptions_updated_at BEFORE UPDATE ON provider_subscriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_course_reviews_updated_at BEFORE UPDATE ON course_reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- دالة لإنشاء ملف شخصي افتراضي للمستخدم
CREATE OR REPLACE FUNCTION create_default_user_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_profiles (
        user_id,
        first_name,
        last_name,
        preferred_language
    ) VALUES (
        NEW.id,
        'المستخدم',
        'الجديد',
        'ar'
    );
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- دالة لإنشاء ملف شخصي افتراضي لمقدم الخدمة
CREATE OR REPLACE FUNCTION create_default_provider_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO provider_profiles (
        provider_id,
        organization_name,
        display_name
    ) VALUES (
        NEW.id,
        'مؤسسة تعليمية جديدة',
        'مؤسسة تعليمية جديدة'
    );
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- إنشاء triggers للملفات الشخصية الافتراضية
CREATE TRIGGER create_user_profile_trigger
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION create_default_user_profile();

CREATE TRIGGER create_provider_profile_trigger
    AFTER INSERT ON providers
    FOR EACH ROW
    EXECUTE FUNCTION create_default_provider_profile();

-- دالة لتوليد رقم الشهادة
CREATE SEQUENCE certificate_number_seq START 1;

CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.certificate_number = 'WASLA-' || TO_CHAR(NOW(), 'YYYY') || '-' || LPAD(nextval('certificate_number_seq')::TEXT, 6, '0');
    NEW.verification_code = upper(substr(md5(random()::text), 1, 8));
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER generate_certificate_number_trigger
    BEFORE INSERT ON certificates
    FOR EACH ROW
    EXECUTE FUNCTION generate_certificate_number();

-- دالة لتحديث تقدم الطالب
CREATE OR REPLACE FUNCTION update_enrollment_progress()
RETURNS TRIGGER AS $$
DECLARE
    total_lessons_count INTEGER;
    completed_lessons_count INTEGER;
    progress_percent INTEGER;
    enrollment_record RECORD;
BEGIN
    -- الحصول على معلومات التسجيل
    SELECT * INTO enrollment_record 
    FROM enrollments 
    WHERE id = NEW.enrollment_id;
    
    -- حساب إجمالي الدروس في الكورس
    SELECT COUNT(*) INTO total_lessons_count
    FROM lessons
    WHERE course_id = enrollment_record.course_id;
    
    -- حساب الدروس المكتملة
    SELECT COUNT(*) INTO completed_lessons_count
    FROM lesson_progress
    WHERE enrollment_id = NEW.enrollment_id
    AND is_completed = TRUE;
    
    -- حساب النسبة المئوية
    IF total_lessons_count > 0 THEN
        progress_percent = (completed_lessons_count * 100) / total_lessons_count;
    ELSE
        progress_percent = 0;
    END IF;
    
    -- تحديث جدول التسجيلات
    UPDATE enrollments
    SET 
        progress_percentage = progress_percent,
        completed_lessons = completed_lessons_count,
        total_lessons = total_lessons_count,
        completion_date = CASE WHEN progress_percent = 100 THEN NOW() ELSE NULL END,
        certificate_eligible = CASE WHEN progress_percent = 100 THEN TRUE ELSE FALSE END
    WHERE id = NEW.enrollment_id;
    
    -- إنشاء إشعار عند إكمال الكورس
    IF progress_percent = 100 THEN
        INSERT INTO notifications (
            recipient_id,
            recipient_type,
            title,
            message,
            type,
            data
        ) VALUES (
            enrollment_record.user_id,
            'user',
            'تهانينا! تم إكمال الكورس',
            'لقد أكملت الكورس بنجاح ويمكنك الآن الحصول على الشهادة',
            'course',
            json_build_object('course_id', enrollment_record.course_id, 'enrollment_id', enrollment_record.id)
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_enrollment_progress_trigger
    AFTER INSERT OR UPDATE ON lesson_progress
    FOR EACH ROW
    EXECUTE FUNCTION update_enrollment_progress();

-- دالة لتحديث تقييم الكورس
CREATE OR REPLACE FUNCTION update_course_rating()
RETURNS TRIGGER AS $$
DECLARE
    avg_rating DECIMAL(3,2);
    review_count INTEGER;
    course_id_val UUID;
BEGIN
    course_id_val = COALESCE(NEW.course_id, OLD.course_id);
    
    -- حساب متوسط التقييم وعدد المراجعات
    SELECT AVG(rating), COUNT(*)
    INTO avg_rating, review_count
    FROM course_reviews
    WHERE course_id = course_id_val
    AND is_flagged = FALSE;
    
    -- تحديث الكورس
    UPDATE courses
    SET 
        rating = COALESCE(avg_rating, 0),
        reviews_count = review_count
    WHERE id = course_id_val;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_course_rating_trigger
    AFTER INSERT OR UPDATE OR DELETE ON course_reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_course_rating();

-- دالة لتحديث عدد التسجيلات في الكورس
CREATE OR REPLACE FUNCTION update_course_enrollment_count()
RETURNS TRIGGER AS $$
DECLARE
    enrollment_count INTEGER;
    course_id_val UUID;
BEGIN
    course_id_val = COALESCE(NEW.course_id, OLD.course_id);
    
    SELECT COUNT(*)
    INTO enrollment_count
    FROM enrollments
    WHERE course_id = course_id_val
    AND status = 'active';
    
    UPDATE courses
    SET enrollment_count = enrollment_count
    WHERE id = course_id_val;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_course_enrollment_count_trigger
    AFTER INSERT OR UPDATE OR DELETE ON enrollments
    FOR EACH ROW
    EXECUTE FUNCTION update_course_enrollment_count();

-- دالة لتسجيل الأنشطة
CREATE OR REPLACE FUNCTION log_activity(
    p_actor_id UUID,
    p_actor_type TEXT,
    p_action TEXT,
    p_resource_type TEXT DEFAULT NULL,
    p_resource_id UUID DEFAULT NULL,
    p_details JSONB DEFAULT '{}'::jsonb
)
RETURNS UUID AS $$
DECLARE
    activity_id UUID;
BEGIN
    INSERT INTO activity_logs (
        actor_id,
        actor_type,
        action,
        resource_type,
        resource_id,
        details
    ) VALUES (
        p_actor_id,
        p_actor_type,
        p_action,
        p_resource_type,
        p_resource_id,
        p_details
    ) RETURNING id INTO activity_id;
    
    RETURN activity_id;
END;
$$ LANGUAGE 'plpgsql';

-- دوال الإحصائيات
CREATE OR REPLACE FUNCTION get_admin_dashboard_stats()
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total_users', (SELECT COUNT(*) FROM users WHERE role = 'student' AND is_active = TRUE),
        'total_providers', (SELECT COUNT(*) FROM providers WHERE is_active = TRUE),
        'active_providers', (SELECT COUNT(*) FROM providers WHERE status = 'active'),
        'pending_providers', (SELECT COUNT(*) FROM providers WHERE status = 'pending'),
        'total_courses', (SELECT COUNT(*) FROM courses WHERE status = 'published'),
        'total_enrollments', (SELECT COUNT(*) FROM enrollments WHERE status = 'active'),
        'total_revenue', (SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'completed'),
        'pending_documents', (SELECT COUNT(*) FROM documents WHERE status = 'pending'),
        'pending_subscriptions', (SELECT COUNT(*) FROM provider_subscriptions WHERE status = 'pending'),
        'certificates_issued', (SELECT COUNT(*) FROM certificates WHERE status = 'issued')
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

-- دالة إحصائيات مقدم الخدمة
CREATE OR REPLACE FUNCTION get_provider_dashboard_stats(provider_uuid UUID)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total_courses', (SELECT COUNT(*) FROM courses WHERE provider_id = provider_uuid),
        'published_courses', (SELECT COUNT(*) FROM courses WHERE provider_id = provider_uuid AND status = 'published'),
        'draft_courses', (SELECT COUNT(*) FROM courses WHERE provider_id = provider_uuid AND status = 'draft'),
        'total_students', (
            SELECT COUNT(DISTINCT e.user_id) 
            FROM enrollments e 
            JOIN courses c ON e.course_id = c.id 
            WHERE c.provider_id = provider_uuid AND e.status = 'active'
        ),
        'total_enrollments', (
            SELECT COUNT(*) 
            FROM enrollments e 
            JOIN courses c ON e.course_id = c.id 
            WHERE c.provider_id = provider_uuid
        ),
        'completed_enrollments', (
            SELECT COUNT(*) 
            FROM enrollments e 
            JOIN courses c ON e.course_id = c.id 
            WHERE c.provider_id = provider_uuid AND e.status = 'completed'
        ),
        'total_revenue', (
            SELECT COALESCE(SUM(p.amount), 0) 
            FROM payments p 
            JOIN courses c ON p.course_id = c.id 
            WHERE c.provider_id = provider_uuid AND p.status = 'completed'
        ),
        'avg_course_rating', (
            SELECT COALESCE(AVG(rating), 0) 
            FROM courses 
            WHERE provider_id = provider_uuid AND rating > 0
        ),
        'total_reviews', (
            SELECT COUNT(*) 
            FROM course_reviews cr 
            JOIN courses c ON cr.course_id = c.id 
            WHERE c.provider_id = provider_uuid
        ),
        'certificates_issued', (
            SELECT COUNT(*) 
            FROM certificates cert 
            JOIN courses c ON cert.course_id = c.id 
            WHERE c.provider_id = provider_uuid AND cert.status = 'issued'
        )
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

-- دالة إحصائيات الطالب
CREATE OR REPLACE FUNCTION get_student_dashboard_stats(user_uuid UUID)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'enrolled_courses', (SELECT COUNT(*) FROM enrollments WHERE user_id = user_uuid AND status = 'active'),
        'completed_courses', (SELECT COUNT(*) FROM enrollments WHERE user_id = user_uuid AND status = 'completed'),
        'in_progress_courses', (
            SELECT COUNT(*) 
            FROM enrollments 
            WHERE user_id = user_uuid 
            AND status = 'active' 
            AND progress_percentage > 0 
            AND progress_percentage < 100
        ),
        'certificates_earned', (SELECT COUNT(*) FROM certificates WHERE user_id = user_uuid AND status = 'issued'),
        'total_study_time_hours', (
            SELECT COALESCE(SUM(watch_time_seconds), 0) / 3600.0 
            FROM lesson_progress 
            WHERE user_id = user_uuid
        ),
        'total_completed_lessons', (
            SELECT COUNT(*) 
            FROM lesson_progress 
            WHERE user_id = user_uuid AND is_completed = TRUE
        ),
        'avg_exam_score', (
            SELECT COALESCE(AVG(percentage), 0) 
            FROM exam_attempts 
            WHERE user_id = user_uuid AND is_passed = TRUE
        ),
        'total_exams_passed', (
            SELECT COUNT(*) 
            FROM exam_attempts 
            WHERE user_id = user_uuid AND is_passed = TRUE
        )
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

-- إدراج البيانات الأساسية

-- إدراج الدول
INSERT INTO countries (name_ar, name_en, code, phone_code, currency_code) VALUES 
('اليمن', 'Yemen', 'YE', '+967', 'YER'),
('المملكة العربية السعودية', 'Saudi Arabia', 'SA', '+966', 'SAR'),
('الإمارات العربية المتحدة', 'United Arab Emirates', 'AE', '+971', 'AED');

-- إدراج المحافظات اليمنية
INSERT INTO states (country_id, name_ar, name_en, code) 
SELECT id, 'تعز', 'Taiz', 'TA' FROM countries WHERE code = 'YE'
UNION ALL
SELECT id, 'صنعاء', 'Sanaa', 'SA' FROM countries WHERE code = 'YE'
UNION ALL
SELECT id, 'عدن', 'Aden', 'AD' FROM countries WHERE code = 'YE'
UNION ALL
SELECT id, 'الحديدة', 'Hodeidah', 'HO' FROM countries WHERE code = 'YE';

-- إدراج المدن
INSERT INTO cities (state_id, name_ar, name_en)
SELECT s.id, 'تعز', 'Taiz' FROM states s WHERE s.code = 'TA'
UNION ALL
SELECT s.id, 'التربة', 'Turbah' FROM states s WHERE s.code = 'TA'
UNION ALL
SELECT s.id, 'صنعاء', 'Sanaa' FROM states s WHERE s.code = 'SA'
UNION ALL
SELECT s.id, 'عدن', 'Aden' FROM states s WHERE s.code = 'AD';

-- إدراج فئات الكورسات
INSERT INTO course_categories (name_ar, name_en, description_ar, description_en, icon_url) VALUES 
('التكنولوجيا', 'Technology', 'كورسات في مجال التكنولوجيا والبرمجة', 'Technology and programming courses', 'tech_icon.png'),
('اللغات', 'Languages', 'كورسات تعلم اللغات المختلفة', 'Language learning courses', 'language_icon.png'),
('التطوير الشخصي', 'Personal Development', 'كورسات التطوير الذاتي والمهارات الشخصية', 'Personal development and soft skills', 'personal_icon.png'),
('الأعمال', 'Business', 'كورسات في مجال الأعمال والإدارة', 'Business and management courses', 'business_icon.png');

-- إدراج التخصصات
INSERT INTO specializations (name_ar, name_en, description_ar, description_en) VALUES 
('علوم الحاسوب', 'Computer Science', 'تخصص علوم الحاسوب والبرمجة', 'Computer science and programming specialization'),
('الهندسة', 'Engineering', 'التخصصات الهندسية المختلفة', 'Various engineering specializations'),
('إدارة الأعمال', 'Business Administration', 'تخصص إدارة الأعمال', 'Business administration specialization'),
('اللغة الإنجليزية', 'English Language', 'تخصص اللغة الإنجليزية', 'English language specialization');

-- إدراج أنواع الوثائق
INSERT INTO document_types (name_ar, name_en, description_ar, description_en, is_required) VALUES 
('السجل التجاري', 'Commercial Record', 'السجل التجاري للمؤسسة', 'Commercial record of the organization', TRUE),
('الترخيص التعليمي', 'Educational License', 'ترخيص مزاولة النشاط التعليمي', 'Educational activity license', TRUE),
('الهوية الشخصية', 'Personal ID', 'هوية المسؤول عن المؤسسة', 'ID of the organization representative', TRUE),
('شهادة التأسيس', 'Establishment Certificate', 'شهادة تأسيس المؤسسة', 'Organization establishment certificate', FALSE);

-- إدراج قوالب الشهادات
INSERT INTO certificate_templates (name, description, template_url, is_default) VALUES 
('القالب الافتراضي', 'قالب الشهادة الافتراضي لمنصة واصلة', '/templates/default_certificate.html', TRUE),
('قالب الكورسات التقنية', 'قالب خاص بالكورسات التقنية', '/templates/tech_certificate.html', FALSE),
('قالب الكورسات اللغوية', 'قالب خاص بكورسات اللغات', '/templates/language_certificate.html', FALSE);

-- إدراج مشرف افتراضي
INSERT INTO users (email, password_hash, role) VALUES 
('admin@wasla.com', '$2a$10$example_hash', 'admin');

-- إدراج مقدمي خدمات تجريبيين
INSERT INTO providers (email, password_hash, type, status, subscription_fee) VALUES 
('taiz@university.edu.ye', '$2a$10$example_hash', 'university', 'active', 500000),
('itc@institute.edu.ye', '$2a$10$example_hash', 'institute', 'active', 200000),
('trainer@example.com', '$2a$10$example_hash', 'trainer', 'pending', 100000);