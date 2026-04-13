# إصلاحات Context المطلوبة

## المشكلة
استخدام `context.read()` في `initState()` يسبب خطأ "Unsupported operation: _Namespace" في بعض الحالات.

## الحل
استخدام `didChangeDependencies()` بدلاً من `initState()` أو `WidgetsBinding.instance.addPostFrameCallback()`.

---

## الملفات التي تحتاج إصلاح

### ✅ تم إصلاحه
- `lib/features/profile/presentation/pages/profile_page.dart`

### ⚠️ يحتاج إصلاح

#### 1. lib/features/payments/presentation/pages/my_payments_page.dart
```dart
// قبل
@override
void initState() {
  super.initState();
  context.read<PaymentsBloc>().add(const LoadMyPaymentsEvent());
}

// بعد
bool _isInitialized = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_isInitialized) {
    _isInitialized = true;
    context.read<PaymentsBloc>().add(const LoadMyPaymentsEvent());
  }
}
```

#### 2. lib/features/payments/presentation/pages/payment_info_page.dart
```dart
// قبل
@override
void initState() {
  super.initState();
  context.read<PaymentsBloc>()
      .add(LoadProviderPaymentSettingsEvent(widget.providerId));
}

// بعد
bool _isInitialized = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_isInitialized) {
    _isInitialized = true;
    context.read<PaymentsBloc>()
        .add(LoadProviderPaymentSettingsEvent(widget.providerId));
  }
}
```

#### 3. lib/features/payments/presentation/pages/payment_status_page.dart
```dart
// قبل
@override
void initState() {
  super.initState();
  context.read<PaymentsBloc>().add(LoadPaymentByIdEvent(widget.paymentId));
}

// بعد
bool _isInitialized = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_isInitialized) {
    _isInitialized = true;
    context.read<PaymentsBloc>().add(LoadPaymentByIdEvent(widget.paymentId));
  }
}
```

#### 4. lib/features/courses/presentation/pages/courses_page.dart
```dart
// قبل
@override
void initState() {
  super.initState();
  context.read<CoursesBloc>().add(LoadAllCoursesEvent());
}

// بعد
bool _isInitialized = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_isInitialized) {
    _isInitialized = true;
    context.read<CoursesBloc>().add(LoadAllCoursesEvent());
  }
}
```

---

## ملفات أخرى للمراجعة

هذه الملفات تستخدم `initState` لكن قد لا تحتاج إصلاح (لأنها لا تستخدم context.read):

- ✅ `lib/features/home/presentation/pages/home_page.dart` - يستخدم context.read لكن قد يحتاج مراجعة
- ✅ `lib/features/home/presentation/widgets/home_banner.dart` - يستدعي دالة خاصة
- ✅ `lib/features/courses/presentation/pages/my_courses_page.dart` - يهيئ TabController فقط
- ✅ `lib/features/courses/presentation/pages/course_detail_page.dart` - يهيئ TabController فقط

---

## الخطوات التنفيذية

1. ✅ إصلاح profile_page.dart
2. ⚠️ إصلاح my_payments_page.dart
3. ⚠️ إصلاح payment_info_page.dart
4. ⚠️ إصلاح payment_status_page.dart
5. ⚠️ مراجعة courses_page.dart (قد يكون محمي بـ AutomaticKeepAliveClientMixin)
6. ⚠️ مراجعة home_page.dart

---

## ملاحظات مهمة

### متى تستخدم didChangeDependencies
- عند الحاجة لاستخدام `context.read()` أو `context.watch()`
- عند الحاجة للوصول إلى InheritedWidget
- عند الحاجة لـ Theme أو MediaQuery

### متى يمكن استخدام initState
- عند تهيئة controllers (TextEditingController, AnimationController)
- عند تهيئة متغيرات محلية
- عند بدء timers أو streams لا تعتمد على context

### استخدام _isInitialized flag
ضروري لمنع تنفيذ الكود أكثر من مرة لأن `didChangeDependencies` يُستدعى عدة مرات.

---

## الأولوية

1. **عالية جداً**: ملفات الدفع (payments) - تسبب أخطاء مباشرة
2. **عالية**: صفحة الكورسات - قد تسبب مشاكل
3. **متوسطة**: الصفحة الرئيسية - للمراجعة

---

## بعد الإصلاح

تأكد من:
- ✅ لا توجد أخطاء "Unsupported operation"
- ✅ البيانات تُحمل بشكل صحيح
- ✅ لا يوجد تحميل مكرر للبيانات
- ✅ الأداء جيد
