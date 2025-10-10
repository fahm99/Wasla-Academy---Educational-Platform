import 'package:waslaacademy/src/user/models/exam_question.dart';

class ExamQuestionsData {
  static final Map<int, List<ExamQuestion>> examQuestions = {
    1: [
      const ExamQuestion(
        id: 1,
        text: "ما هي لغة بايثون؟",
        options: [
          "لغة برمجة عالية المستوى",
          "لغة ترميز",
          "لغة أسلوب",
          "لغة استعلام"
        ],
        correctAnswer: 0,
      ),
      const ExamQuestion(
        id: 2,
        text: "ما هو استخدام الدالة print() في بايثون؟",
        options: [
          "طباعة النصوص على الشاشة",
          "قراءة المدخلات من المستخدم",
          "حساب القيم الرياضية",
          "إنشاء متغيرات جديدة"
        ],
        correctAnswer: 0,
      ),
      const ExamQuestion(
        id: 3,
        text: "كيف تعلن عن متغير في بايثون؟",
        options: ["var x = 5", "x = 5", "declare x = 5", "variable x = 5"],
        correctAnswer: 1,
      ),
      const ExamQuestion(
        id: 4,
        text: "ما هي أنواع البيانات الأساسية في بايثون؟",
        options: [
          "عدد صحيح، عدد عشري، نص، قيمة منطقية",
          "سلسلة، قائمة، مجموعة",
          "قاموس، مجموعة، tuple",
          "كل ما سبق"
        ],
        correctAnswer: 3,
      ),
      const ExamQuestion(
        id: 5,
        text: "ما هو استخدام العبارة if في بايثون؟",
        options: [
          "لإنشاء حلقات تكرار",
          "للتعامل مع الاستثناءات",
          "لتنفيذ كود بناءً على شرط",
          "لتحديد الدوال"
        ],
        correctAnswer: 2,
      ),
      const ExamQuestion(
        id: 6,
        text: "كيف تنشئ قائمة في بايثون؟",
        options: ["list = []", "list = ()", "list = {}", "list = new List()"],
        correctAnswer: 0,
      ),
      const ExamQuestion(
        id: 7,
        text: "ما هي نتيجة 2 ** 3 في بايثون؟",
        options: ["5", "6", "8", "9"],
        correctAnswer: 2,
      ),
      const ExamQuestion(
        id: 8,
        text: "كيف تصل إلى العنصر الأول في قائمة بايثون؟",
        options: ["list[0]", "list[1]", "list.first", "list.first()"],
        correctAnswer: 0,
      ),
      const ExamQuestion(
        id: 9,
        text: "ما هي وظيفة الدالة len() في بايثون؟",
        options: [
          "حساب الطول",
          "تحويل النص إلى حروف كبيرة",
          "تحويل النص إلى حروف صغيرة",
          "إزالة المسافات البيضاء"
        ],
        correctAnswer: 0,
      ),
      const ExamQuestion(
        id: 10,
        text: "كيف تضيف تعليق في بايثون؟",
        options: [
          "// هذا تعليق",
          "# هذا تعليق",
          "/* هذا تعليق */",
          "<!-- هذا تعليق -->"
        ],
        correctAnswer: 1,
      ),
    ],
  };
}
