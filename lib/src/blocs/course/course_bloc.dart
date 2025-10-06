import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/models/user.dart';
import 'package:waslaacademy/src/data/course_data.dart';
import 'package:waslaacademy/src/blocs/auth/auth_bloc.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final AuthBloc authBloc;

  CourseBloc({required this.authBloc}) : super(CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<EnrollCourse>(_onEnrollCourse);
    on<CompleteCourse>(_onCompleteCourse);
    on<LoadUserCourses>(_onLoadUserCourses);
  }

  void _onLoadCourses(LoadCourses event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Initialize and load courses from CourseData (which loads from JSON)
      await CourseData.initialize();
      List<Course> courses = CourseData.courses;

      // If no courses loaded from JSON, use fallback hardcoded data
      if (courses.isEmpty) {
        // Mock courses data with Yemeni universities and institutes
        courses = [
          const Course(
              id: 1,
              title: "مقدمة في برمجة بايثون",
              description:
                  "هذا الكورس يقدم لك مقدمة شاملة في برمجة بايثون، واحدة من أشهر لغات البرمجة في العالم. سنتعلم أساسيات البرمجة باستخدام بايثون وبناء مشاريع عملية تطبيق هذه المفاهيم.",
              category: "tech",
              level: "beginner",
              price: 0,
              image:
                  "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
              instructor: "سارة أحمد",
              instructorImage:
                  "https://randomuser.me/api/portraits/women/1.jpg",
              rating: 4.5,
              students: 1245,
              duration: "3 ساعات",
              free: true,
              lessons: [
                Lesson(
                    id: 1,
                    title: "مقدمة في بايثون",
                    duration: "15 دقيقة",
                    type: "video",
                    completed: true,
                    description: "مقدمة شاملة عن لغة بايثون وتاريخها وأهميتها"),
                Lesson(
                    id: 2,
                    title: "تثبيت بايثون وإعداد البيئة",
                    duration: "20 دقيقة",
                    type: "video",
                    completed: true,
                    description: "كيفية تثبيت بايثون وإعداد بيئة العمل"),
                Lesson(
                    id: 3,
                    title: "المتغيرات وأنواع البيانات",
                    duration: "30 دقيقة",
                    type: "video",
                    completed: false,
                    description:
                        "شرح المتغيرات وأنواع البيانات المختلفة في بايثون"),
                Lesson(
                    id: 4,
                    title: "المتغيرات وأنواع البيانات - تمرين",
                    duration: "15 دقيقة",
                    type: "assignment",
                    completed: false,
                    description: "تمرين عملي على المتغيرات وأنواع البيانات")
              ],
              exams: [
                Exam(
                    id: 1,
                    title: "امتحان الفصل الأول",
                    duration: "30 دقيقة",
                    questions: 10,
                    type: "mcq")
              ],
              resources: [
                Resource(
                    id: 1,
                    name: "مقدمة في بايثون.pdf",
                    type: "pdf",
                    size: "2.4 ميجابايت",
                    date: "01/01/2023",
                    courseId: 1),
                Resource(
                    id: 2,
                    name: "الكود المصدري.zip",
                    type: "zip",
                    size: "1.2 ميجابايت",
                    date: "01/01/2023",
                    courseId: 1),
                Resource(
                    id: 3,
                    name: "تمرين المتغيرات.docx",
                    type: "document",
                    size: "0.8 ميجابايت",
                    date: "05/01/2023",
                    courseId: 1)
              ],
              type: "university",
              provider: "جامعة تعز",
              providerImage: "https://randomuser.me/api/portraits/men/5.jpg",
              providerRating: 4.7,
              providerCourses: 25),
          const Course(
              id: 2,
              title: "تطوير تطبيقات الويب باستخدام React",
              description:
                  "تعلم كيفية بناء تطبيقات الويب الحديثة باستخدام React، إحدى أشهر مكتبات JavaScript. سنتعلم المكونات، الحالة، Props، والتعامل مع الـ API.",
              category: "tech",
              level: "intermediate",
              price: 299,
              image:
                  "https://images.unsplash.com/photo-1555066931-4365d14bab8c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
              instructor: "أحمد محمد",
              instructorImage: "https://randomuser.me/api/portraits/men/1.jpg",
              rating: 4.7,
              students: 856,
              duration: "8 ساعات",
              free: false,
              lessons: [
                Lesson(
                    id: 1,
                    title: "مقدمة في React",
                    duration: "20 دقيقة",
                    type: "video",
                    completed: true,
                    description: "مقدمة عن React ومفاهيمها الأساسية"),
                Lesson(
                    id: 2,
                    title: "المكونات (Components)",
                    duration: "30 دقيقة",
                    type: "video",
                    completed: true,
                    description: "شرح مفصل عن المكونات في React"),
                Lesson(
                    id: 3,
                    title: "الحالة (State) والخصائص (Props)",
                    duration: "40 دقيقة",
                    type: "video",
                    completed: false,
                    description: "كيفية إدارة الحالة والخصائص في React"),
                Lesson(
                    id: 4,
                    title: "التعامل مع الـ API",
                    duration: "45 دقيقة",
                    type: "video",
                    completed: false,
                    description: "كيفية التعامل مع واجهات برمجة التطبيقات")
              ],
              exams: [
                Exam(
                    id: 1,
                    title: "امتحان أساسيات React",
                    duration: "45 دقيقة",
                    questions: 15,
                    type: "mcq"),
                Exam(
                    id: 2,
                    title: "مشروع تطبيقي",
                    duration: "60 دقيقة",
                    questions: 1,
                    type: "project")
              ],
              resources: [
                Resource(
                    id: 1,
                    name: "React Components Guide.pdf",
                    type: "pdf",
                    size: "3.1 ميجابايت",
                    date: "10/01/2023",
                    courseId: 2),
                Resource(
                    id: 2,
                    name: "React Project Files.zip",
                    type: "zip",
                    size: "2.5 ميجابايت",
                    date: "10/01/2023",
                    courseId: 2),
                Resource(
                    id: 3,
                    name: "State Management Examples.docx",
                    type: "document",
                    size: "1.2 ميجابايت",
                    date: "15/01/2023",
                    courseId: 2)
              ],
              type: "institute",
              provider: "معهد ITC",
              providerImage: "https://randomuser.me/api/portraits/men/6.jpg",
              providerRating: 4.5,
              providerCourses: 18),
          const Course(
              id: 3,
              title: "اللغة الإنجليزية للمبتدئين",
              description:
                  "كورس شامل لتعلم اللغة الإنجليزية من الصفر، يغطي الأساسيات مثل الحروف، الأرقام، الكلمات الشائعة، والجمل البسيطة.",
              category: "language",
              level: "beginner",
              price: 0,
              image:
                  "https://images.unsplash.com/photo-1521791136064-7986c2920216?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
              instructor: "مريم عبدالله",
              instructorImage:
                  "https://randomuser.me/api/portraits/women/2.jpg",
              rating: 4.3,
              students: 2156,
              duration: "10 ساعات",
              free: true,
              lessons: [
                Lesson(
                    id: 1,
                    title: "الحروف الإنجليزية",
                    duration: "30 دقيقة",
                    type: "video",
                    completed: true,
                    description: "تعلم الحروف الإنجليزية ونطقها الصحيح"),
                Lesson(
                    id: 2,
                    title: "الأرقام والألوان",
                    duration: "25 دقيقة",
                    type: "video",
                    completed: true,
                    description: "تعلم الأرقام والألوان باللغة الإنجليزية"),
                Lesson(
                    id: 3,
                    title: "الكلمات الشائعة",
                    duration: "40 دقيقة",
                    type: "video",
                    completed: true,
                    description: "أشهر الكلمات الإنجليزية واستخداماتها"),
                Lesson(
                    id: 4,
                    title: "تكوين الجمل البسيطة",
                    duration: "35 دقيقة",
                    type: "video",
                    completed: false,
                    description: "كيفية تكوين جمل بسيطة باللغة الإنجليزية")
              ],
              exams: [
                Exam(
                    id: 1,
                    title: "امتحان الحروف والكلمات",
                    duration: "20 دقيقة",
                    questions: 20,
                    type: "mcq")
              ],
              resources: [
                Resource(
                    id: 1,
                    name: "الحروف الإنجليزية.mp4",
                    type: "video",
                    size: "45.2 ميجابايت",
                    date: "10/01/2023",
                    courseId: 3),
                Resource(
                    id: 2,
                    name: "قائمة الكلمات.xlsx",
                    type: "spreadsheet",
                    size: "0.5 ميجابايت",
                    date: "10/01/2023",
                    courseId: 3),
                Resource(
                    id: 3,
                    name: "تمارين المفردات.docx",
                    type: "document",
                    size: "1.1 ميجابايت",
                    date: "12/01/2023",
                    courseId: 3)
              ],
              type: "university",
              provider: "جامعة الوطنية",
              providerImage: "https://randomuser.me/api/portraits/women/7.jpg",
              providerRating: 4.6,
              providerCourses: 32),
          const Course(
              id: 4,
              title: "مهارات القيادة والتأثير",
              description:
                  "تعلم كيفية تطوير مهارات القيادة الفعالة والتأثير على الآخرين في بيئة العمل. سنتناول مفاهيم القيادة، التواصل الفعال، وإدارة الفرق.",
              category: "development",
              level: "intermediate",
              price: 199,
              image:
                  "https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
              instructor: "خالد السعيد",
              instructorImage: "https://randomuser.me/api/portraits/men/3.jpg",
              rating: 4.6,
              students: 642,
              duration: "5 ساعات",
              free: false,
              lessons: [
                Lesson(
                    id: 1,
                    title: "مفاهيم القيادة الأساسية",
                    duration: "30 دقيقة",
                    type: "video",
                    completed: true,
                    description: "مفاهيم أساسية في القيادة والإدارة"),
                Lesson(
                    id: 2,
                    title: "التواصل الفعال",
                    duration: "45 دقيقة",
                    type: "video",
                    completed: true,
                    description: "أساسيات التواصل الفعال مع الفريق"),
                Lesson(
                    id: 3,
                    title: "إدارة الفرق",
                    duration: "40 دقيقة",
                    type: "video",
                    completed: false,
                    description: "كيفية إدارة الفرق بفعالية"),
                Lesson(
                    id: 4,
                    title: "حل المشكلات واتخاذ القرارات",
                    duration: "35 دقيقة",
                    type: "video",
                    completed: false,
                    description: "استراتيجيات حل المشكلات واتخاذ القرارات")
              ],
              exams: [
                Exam(
                    id: 1,
                    title: "امتحان مهارات القيادة",
                    duration: "40 دقيقة",
                    questions: 12,
                    type: "mcq"),
                Exam(
                    id: 2,
                    title: "مقال تحليلي",
                    duration: "60 دقيقة",
                    questions: 1,
                    type: "essay")
              ],
              resources: [
                Resource(
                    id: 1,
                    name: "كتاب القيادة.pdf",
                    type: "pdf",
                    size: "4.2 ميجابايت",
                    date: "15/01/2023",
                    courseId: 4),
                Resource(
                    id: 2,
                    name: "نماذج تقييم الفريق.xlsx",
                    type: "spreadsheet",
                    size: "0.8 ميجابايت",
                    date: "15/01/2023",
                    courseId: 4)
              ],
              type: "personal",
              provider: "د. خالد السعيد",
              providerImage: "https://randomuser.me/api/portraits/men/8.jpg",
              providerRating: 4.8,
              providerCourses: 12),
          const Course(
              id: 5,
              title: "التسويق الرقمي الشامل",
              description:
                  "كورس شامل في التسويق الرقمي يغطي SEO، التسويق عبر محركات البحث، التسويق عبر وسائل التواصل الاجتماعي، والتسويق عبر البريد الإلكتروني.",
              category: "business",
              level: "intermediate",
              price: 399,
              image:
                  "https://images.unsplash.com/photo-1557862921-37829c790f19?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
              instructor: "نورة السالم",
              instructorImage:
                  "https://randomuser.me/api/portraits/women/3.jpg",
              rating: 4.8,
              students: 934,
              duration: "12 ساعات",
              free: false,
              lessons: [
                Lesson(
                    id: 1,
                    title: "مقدمة في التسويق الرقمي",
                    duration: "25 دقيقة",
                    type: "video",
                    completed: true,
                    description: "مقدمة شاملة عن التسويق الرقمي"),
                Lesson(
                    id: 2,
                    title: "تحسين محركات البحث (SEO)",
                    duration: "50 دقيقة",
                    type: "video",
                    completed: false,
                    description: "أساسيات تحسين محركات البحث"),
                Lesson(
                    id: 3,
                    title: "التسويق عبر محركات البحث (SEM)",
                    duration: "45 دقيقة",
                    type: "video",
                    completed: false,
                    description: "كيفية استخدام SEM في التسويق"),
                Lesson(
                    id: 4,
                    title: "التسويق عبر وسائل التواصل الاجتماعي",
                    duration: "60 دقيقة",
                    type: "video",
                    completed: false,
                    description: "استراتيجيات التسويق عبر وسائل التواصل")
              ],
              exams: [
                Exam(
                    id: 1,
                    title: "امتحان التسويق الرقمي",
                    duration: "60 دقيقة",
                    questions: 20,
                    type: "mcq"),
                Exam(
                    id: 2,
                    title: "خطة تسويق متكاملة",
                    duration: "90 دقيقة",
                    questions: 1,
                    type: "project")
              ],
              resources: [
                Resource(
                    id: 1,
                    name: "دليل التسويق الرقمي.pdf",
                    type: "pdf",
                    size: "5.3 ميجابايت",
                    date: "20/01/2023",
                    courseId: 5),
                Resource(
                    id: 2,
                    name: "نماذج الحملات التسويقية.xlsx",
                    type: "spreadsheet",
                    size: "1.5 ميجابايت",
                    date: "20/01/2023",
                    courseId: 5),
                Resource(
                    id: 3,
                    name: "أدوات التسويق الرقمي.docx",
                    type: "document",
                    size: "2.1 ميجابايت",
                    date: "22/01/2023",
                    courseId: 5)
              ],
              type: "institute",
              provider: "المعهد التقني",
              providerImage: "https://randomuser.me/api/portraits/men/9.jpg",
              providerRating: 4.4,
              providerCourses: 15),
          const Course(
              id: 6,
              title: "تصميم واجهات المستخدم باستخدام Figma",
              description:
                  "تعلم كيفية تصميم واجهات المستخدم والتجربة الرقمية باستخدام Figma، أداة التصميم الأحدث والأكثر شهرة في عالم التصميم.",
              category: "tech",
              level: "beginner",
              price: 0,
              image: "https://picsum.photos/seed/6/1350/80",
              instructor: "فهد العتيبي",
              instructorImage: "https://randomuser.me/api/portraits/men/4.jpg",
              rating: 4.4,
              students: 1532,
              duration: "6 ساعات",
              free: true,
              lessons: [
                Lesson(
                    id: 1,
                    title: "مقدمة في Figma",
                    duration: "20 دقيقة",
                    type: "video",
                    completed: true,
                    description: "مقدمة عن أداة Figma وواجهتها"),
                Lesson(
                    id: 2,
                    title: "أساسيات التصميم",
                    duration: "30 دقيقة",
                    type: "video",
                    completed: true,
                    description: "أساسيات تصميم واجهات المستخدم"),
                Lesson(
                    id: 3,
                    title: "إنشاء التصاميم الأولى",
                    duration: "45 دقيقة",
                    type: "video",
                    completed: false,
                    description: "كيفية إنشاء أول تصميم لك"),
                Lesson(
                    id: 4,
                    title: "البروتوتايب والتفاعل",
                    duration: "40 دقيقة",
                    type: "video",
                    completed: false,
                    description: "إنشاء نماذج تفاعلية لتصاميمك")
              ],
              exams: [
                Exam(
                    id: 1,
                    title: "امتحان تصميم الواجهات",
                    duration: "45 دقيقة",
                    questions: 15,
                    type: "mcq")
              ],
              resources: [
                Resource(
                    id: 1,
                    name: "Figma Basics Guide.pdf",
                    type: "pdf",
                    size: "3.7 ميجابايت",
                    date: "25/01/2023",
                    courseId: 6),
                Resource(
                    id: 2,
                    name: "Design Templates.zip",
                    type: "zip",
                    size: "8.2 ميجابايت",
                    date: "25/01/2023",
                    courseId: 6),
                Resource(
                    id: 3,
                    name: "UI Design Principles.docx",
                    type: "document",
                    size: "1.8 ميجابايت",
                    date: "27/01/2023",
                    courseId: 6)
              ],
              type: "university",
              provider: "جامعة العلوم والتكنولوجيا",
              providerImage: "https://randomuser.me/api/portraits/women/4.jpg",
              providerRating: 4.5,
              providerCourses: 28),
        ];
      }

      emit(CourseLoaded(courses: courses));
    } catch (e) {
      emit(const CourseError(message: "فشل في تحميل الكورسات"));
    }
  }

  void _onEnrollCourse(EnrollCourse event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update user's enrolled courses in auth bloc
      final authState = authBloc.state;
      if (authState is AuthSuccess) {
        final updatedEnrolledCourses =
            List<int>.from(authState.user.enrolledCourses)..add(event.courseId);

        final updatedUser = authState.user.copyWith(
          enrolledCourses: updatedEnrolledCourses,
        );

        // Update auth bloc with new user data
        authBloc.add(UpdateUserProgress(
          enrolledCourses: updatedEnrolledCourses,
        ));
      }

      // Emit success state
      emit(CourseEnrolled(courseId: event.courseId));
    } catch (e) {
      emit(const CourseError(message: "فشل في التسجيل في الكورس"));
    }
  }

  void _onCompleteCourse(
      CompleteCourse event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Emit success state
      emit(CourseCompleted(courseId: event.courseId));
    } catch (e) {
      emit(const CourseError(message: "فشل في إكمال الكورس"));
    }
  }

  void _onLoadUserCourses(
      LoadUserCourses event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Get all courses first
      final allCoursesState = state;
      List<Course> userCourses = [];

      if (allCoursesState is CourseLoaded) {
        userCourses = allCoursesState.courses
            .where((course) => event.user.enrolledCourses.contains(course.id))
            .toList();
      }

      emit(UserCoursesLoaded(courses: userCourses));
    } catch (e) {
      emit(const CourseError(message: "فشل في تحميل كورسات المستخدم"));
    }
  }
}
