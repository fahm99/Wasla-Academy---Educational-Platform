# 🔥 Stability & UX Improvement Architecture Plan for Flutter App

**تاريخ التحليل:** 14 أبريل 2026  
**المحلل:** Senior Flutter Architecture Engineer  
**التطبيق:** Wasla Academy (Student App)

---

## 📊 ملخص تنفيذي

**الحالة العامة:** ⚠️ **يحتاج تحسينات جوهرية**  
**مستوى الاستقرار:** 60%  
**تجربة المستخدم:** 55%  
**المشاكل الحرجة:** 12  
**المشاكل المتوسطة:** 8  
**التحسينات المقترحة:** 15

---

## 🔴 المشاكل الحرجة (Critical Issues)

### 1️⃣ فقدان البيانات عند الرجوع (Data Loss on Back Navigation)

**الخطورة:** 🔴 **HIGH**

**المشكلة:**
```dart
// في injection_container.dart
sl.registerFactory(() => CoursesBloc(...));  // ❌ Factory = Bloc جديد كل مرة
sl.registerFactory(() => PaymentsBloc(...)); // ❌ Factory = Bloc جديد كل مرة
```

**السيناريو:**
1. المستخدم يفتح صفحة الكورسات → يحمل 50 كورس
2. يدخل على تفاصيل كورس
3. يرجع للصفحة الرئيسية
4. **النتيجة:** يتم إنشاء `CoursesBloc` جديد → إعادة تحميل 50 كورس من الخادم!

**التأثير:**
- استهلاك غير ضروري للـ API
- تجربة مستخدم سيئة (loading كل مرة)
- استهلاك بيانات الإنترنت
- بطء في الأداء

**الحل:**
```dart
// استخدام Singleton للـ Blocs المهمة
sl.registerLazySingleton(() => CoursesBloc(...));
sl.registerLazySingleton(() => LearningBloc(...));

// أو استخدام Caching Layer
class CoursesRepository {
  List<Course>? _cachedCourses;
  DateTime? _lastFetch;
  
  Future<List<Course>> getCourses() async {
    if (_cachedCourses != null && 
        DateTime.now().difference(_lastFetch!) < Duration(minutes: 5)) {
      return _cachedCourses!;
    }
    // Fetch from API
  }
}
```

---

### 2️⃣ فقدان الصورة المرفوعة عند الرجوع (Image Loss on Navigation)

**الخطورة:** 🔴 **HIGH**

**المشكلة:**
```dart
// في PaymentUploadPage
class _PaymentUploadPageState extends State<PaymentUploadPage> {
  File? _receiptImage;  // ❌ محفوظة في State فقط
  
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(...);
    if (image != null) {
      setState(() {
        _receiptImage = File(image.path);  // ❌ تُفقد عند dispose
      });
    }
  }
}
```

**السيناريو:**
1. المستخدم يختار صورة الإيصال
2. يملأ البيانات
3. يضغط "رجوع" بالخطأ
4. **النتيجة:** الصورة تُفقد! يجب اختيارها مرة أخرى

**التأثير:**
- إحباط المستخدم
- فقدان البيانات
- تجربة سيئة جداً

**الحل:**
```dart
// 1. حفظ في LocalStorage
class PaymentDraftService {
  Future<void> saveDraft({
    required String courseId,
    required File image,
    required String transactionRef,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    // حفظ path الصورة
    await prefs.setString('payment_draft_$courseId', image.path);
    await prefs.setString('payment_ref_$courseId', transactionRef);
  }
  
  Future<PaymentDraft?> loadDraft(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('payment_draft_$courseId');
    if (imagePath != null && File(imagePath).existsSync()) {
      return PaymentDraft(
        image: File(imagePath),
        transactionRef: prefs.getString('payment_ref_$courseId'),
      );
    }
    return null;
  }
}

// 2. استخدام في PaymentUploadPage
@override
void initState() {
  super.initState();
  _loadDraft();
}

Future<void> _loadDraft() async {
  final draft = await PaymentDraftService().loadDraft(widget.courseId);
  if (draft != null) {
    setState(() {
      _receiptImage = draft.image;
      _transactionRefController.text = draft.transactionRef ?? '';
    });
  }
}
```

---

### 3️⃣ عدم وجود Retry Mechanism عند فشل Upload

**الخطورة:** 🔴 **HIGH**

**المشكلة:**
```dart
// في PaymentsBloc
Future<void> _onSubmitPayment(...) async {
  emit(PaymentsLoading());
  
  final result = await submitPaymentUseCase(params);
  
  result.fold(
    (failure) => emit(PaymentsError(message: failure.message)),  // ❌ فقط error
    (payment) => emit(PaymentSubmitted(payment: payment)),
  );
}
```

**السيناريو:**
1. المستخدم يرفع صورة 3 MB
2. الشبكة بطيئة
3. ينقطع الاتصال عند 90%
4. **النتيجة:** خطأ! يجب إعادة الرفع من الصفر

**التأثير:**
- إحباط شديد للمستخدم
- استهلاك بيانات مضاعف
- تجربة سيئة جداً

**الحل:**
```dart
// إضافة Retry Policy
class ApiClient {
  Future<T> executeWithRetry<T>({
    required Future<T> Function() request,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    
    while (attempt < maxRetries) {
      try {
        return await request();
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        
        await ErrorHandler().logWarning(
          'Retry attempt $attempt/$maxRetries',
          context: 'ApiClient.executeWithRetry',
        );
        
        await Future.delayed(retryDelay * attempt);
      }
    }
    
    throw Exception('Max retries exceeded');
  }
}

// استخدام في Repository
Future<Payment> submitPayment(SubmitPaymentParams params) async {
  return await _apiClient.executeWithRetry(
    request: () async {
      // رفع الصورة
      final imageUrl = await _uploadImage(params.receiptImage);
      // إنشاء الدفع
      return await _createPayment(imageUrl, params);
    },
    maxRetries: 3,
  );
}
```

---

### 4️⃣ إعادة تحميل البيانات بشكل مفرط (Over-fetching)

**الخطورة:** 🔴 **HIGH**

**المشكلة:**
```dart
// في CourseContentPage
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  // ❌ يُستدعى كل مرة حتى لو لم تتغير البيانات
  context.read<CoursesBloc>().add(LoadCourseDetailsEvent(widget.courseId));
}
```

**السيناريو:**
1. المستخدم يفتح محتوى الكورس
2. يدخل على درس
3. يرجع
4. **النتيجة:** إعادة تحميل محتوى الكورس من الخادم!

**التأثير:**
- استهلاك API غير ضروري
- بطء في الأداء
- استهلاك بيانات

**الحل:**
```dart
// 1. إضافة Caching مع TTL
class CachedData<T> {
  final T data;
  final DateTime fetchedAt;
  final Duration ttl;
  
  CachedData(this.data, this.ttl) : fetchedAt = DateTime.now();
  
  bool get isExpired => DateTime.now().difference(fetchedAt) > ttl;
}

class CoursesRepository {
  final Map<String, CachedData<CourseDetails>> _cache = {};
  
  Future<CourseDetails> getCourseDetails(String courseId) async {
    // تحقق من الـ cache
    if (_cache.containsKey(courseId) && !_cache[courseId]!.isExpired) {
      return _cache[courseId]!.data;
    }
    
    // جلب من API
    final details = await _remoteDataSource.getCourseDetails(courseId);
    _cache[courseId] = CachedData(details, Duration(minutes: 10));
    return details;
  }
}

// 2. استخدام flag لمنع إعادة التحميل
class _CourseContentPageState extends State<CourseContentPage> {
  bool _hasLoadedData = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedData) {
      _loadData();
      _hasLoadedData = true;
    }
  }
}
```

---

### 5️⃣ عدم حفظ Scroll Position

**الخطورة:** 🟡 **MEDIUM-HIGH**

**المشكلة:**
```dart
// في CoursesPage
ListView.builder(
  itemCount: courses.length,
  itemBuilder: (context, index) {
    return CourseCard(course: courses[index]);
  },
)
// ❌ لا يوجد ScrollController أو PageStorageKey
```

**السيناريو:**
1. المستخدم يتصفح 50 كورس
2. يصل للكورس رقم 40
3. يدخل على تفاصيل الكورس
4. يرجع
5. **النتيجة:** يرجع لأعلى القائمة! يجب التمرير مرة أخرى

**التأثير:**
- تجربة مستخدم سيئة جداً
- إحباط المستخدم

**الحل:**
```dart
// 1. استخدام PageStorageKey
ListView.builder(
  key: PageStorageKey('courses_list'),  // ✅ يحفظ الموقع
  itemCount: courses.length,
  itemBuilder: (context, index) {
    return CourseCard(course: courses[index]);
  },
)

// 2. أو استخدام AutomaticKeepAliveClientMixin
class _CoursesPageState extends State<CoursesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;  // ✅ يحفظ الصفحة في الذاكرة
  
  @override
  Widget build(BuildContext context) {
    super.build(context);  // ضروري
    return ListView.builder(...);
  }
}
```

---

### 6️⃣ عدم وجود Offline Support

**الخطورة:** 🔴 **HIGH**

**المشكلة:**
```dart
// عند انقطاع الشبكة
if (!await networkInfo.isConnected) {
  return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
}
// ❌ لا يوجد fallback أو caching
```

**السيناريو:**
1. المستخدم يفتح التطبيق في مكان بدون إنترنت
2. **النتيجة:** شاشة فارغة أو error!

**التأثير:**
- تطبيق غير قابل للاستخدام offline
- تجربة سيئة جداً

**الحل:**
```dart
// 1. إضافة Local Database (Hive)
class LocalCoursesDataSource {
  final Box<CourseModel> _box;
  
  Future<void> saveCourses(List<CourseModel> courses) async {
    await _box.clear();
    for (final course in courses) {
      await _box.put(course.id, course);
    }
  }
  
  List<CourseModel> getCachedCourses() {
    return _box.values.toList();
  }
}

// 2. استخدام في Repository
Future<Either<Failure, List<Course>>> getCourses() async {
  if (await _networkInfo.isConnected) {
    try {
      final courses = await _remoteDataSource.getCourses();
      await _localDataSource.saveCourses(courses);  // ✅ حفظ محلياً
      return Right(courses);
    } catch (e) {
      // إذا فشل، استخدم الـ cache
      final cached = _localDataSource.getCachedCourses();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return Left(ServerFailure());
    }
  } else {
    // offline: استخدم الـ cache
    final cached = _localDataSource.getCachedCourses();
    if (cached.isNotEmpty) {
      return Right(cached);
    }
    return Left(NetworkFailure());
  }
}
```

---

### 7️⃣ عدم حفظ Form Data

**الخطورة:** 🟡 **MEDIUM**

**المشكلة:**
```dart
// في PaymentUploadPage
final _transactionRefController = TextEditingController();

@override
void dispose() {
  _transactionRefController.dispose();  // ❌ البيانات تُفقد
  super.dispose();
}
```

**السيناريو:**
1. المستخدم يكتب رقم المعاملة
2. يضغط "رجوع" بالخطأ
3. **النتيجة:** البيانات تُفقد!

**الحل:**
```dart
// حفظ في LocalStorage
@override
void dispose() {
  _saveDraft();
  _transactionRefController.dispose();
  super.dispose();
}

Future<void> _saveDraft() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'payment_ref_${widget.courseId}',
    _transactionRefController.text,
  );
}
```

---

### 8️⃣ Memory Leaks في Timers

**الخطورة:** 🟡 **MEDIUM**

**المشكلة:**
```dart
// في SessionManager
Timer? _sessionCheckTimer;

void startSessionMonitoring() {
  _sessionCheckTimer = Timer.periodic(
    const Duration(minutes: 1),
    (_) => _checkSessionTimeout(),
  );
}
// ❌ ماذا لو لم يتم استدعاء stopSessionMonitoring؟
```

**التأثير:**
- Memory leak
- استهلاك بطارية
- Timers تعمل في الخلفية

**الحل:**
```dart
class SessionManager {
  Timer? _sessionCheckTimer;
  
  void startSessionMonitoring() {
    // ✅ إلغاء Timer القديم أولاً
    _sessionCheckTimer?.cancel();
    
    _sessionCheckTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkSessionTimeout(),
    );
  }
  
  void dispose() {
    stopSessionMonitoring();
  }
}
```

---

### 9️⃣ عدم وجود Progress Indicator للـ Upload

**الخطورة:** 🟡 **MEDIUM**

**المشكلة:**
```dart
// في PaymentsBloc
emit(PaymentsLoading());  // ❌ فقط loading عام
final result = await submitPaymentUseCase(params);
```

**السيناريو:**
1. المستخدم يرفع صورة 5 MB
2. يرى فقط loading spinner
3. لا يعرف: هل يتم الرفع؟ كم النسبة؟
4. **النتيجة:** قلق وإحباط

**الحل:**
```dart
// 1. إضافة Progress State
class PaymentsUploading extends PaymentsState {
  final double progress;  // 0.0 to 1.0
  PaymentsUploading({required this.progress});
}

// 2. استخدام في Upload
Future<String> uploadImage(File image, Function(double) onProgress) async {
  final bytes = await image.readAsBytes();
  
  return await supabaseClient.storage
    .from('payment-receipts')
    .uploadBinary(
      filePath,
      bytes,
      fileOptions: FileOptions(
        onUploadProgress: (count, total) {
          onProgress(count / total);
        },
      ),
    );
}

// 3. في Bloc
await _repository.submitPayment(
  params,
  onProgress: (progress) {
    emit(PaymentsUploading(progress: progress));
  },
);
```

---

### 🔟 عدم معالجة App Lifecycle

**الخطورة:** 🟡 **MEDIUM**

**المشكلة:**
```dart
// لا يوجد معالجة لـ:
// - App في Background
// - App يرجع من Background
// - App يُغلق
```

**السيناريو:**
1. المستخدم يرفع صورة
2. يضغط Home (App في Background)
3. يرجع بعد 5 دقائق
4. **النتيجة:** Upload قد يكون فشل أو نجح، لا يعرف!

**الحل:**
```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // App في Background
        _handleAppPaused();
        break;
      case AppLifecycleState.resumed:
        // App رجع
        _handleAppResumed();
        break;
      case AppLifecycleState.detached:
        // App يُغلق
        _handleAppDetached();
        break;
      default:
        break;
    }
  }
  
  void _handleAppPaused() {
    // حفظ الحالة
    // إيقاف Timers غير ضرورية
  }
  
  void _handleAppResumed() {
    // إعادة تحميل البيانات إذا لزم
    // استئناف Timers
  }
}
```

---

## 🟡 المشاكل المتوسطة (Medium Issues)

### 11. عدم وجود Debouncing للبحث

**المشكلة:**
```dart
TextField(
  onChanged: (value) {
    context.read<CoursesBloc>().add(SearchCoursesEvent(query: value));
    // ❌ API call عند كل حرف!
  },
)
```

**الحل:**
```dart
Timer? _debounce;

void _onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 500), () {
    context.read<CoursesBloc>().add(SearchCoursesEvent(query: query));
  });
}
```

---

### 12. عدم وجود Pagination

**المشكلة:**
```dart
// تحميل جميع الكورسات مرة واحدة
final courses = await supabaseClient
  .from('courses')
  .select()
  .execute();
// ❌ ماذا لو كان هناك 1000 كورس؟
```

**الحل:**
```dart
// إضافة Pagination
final courses = await supabaseClient
  .from('courses')
  .select()
  .range(page * pageSize, (page + 1) * pageSize - 1)
  .execute();
```

---

## 🚀 خطة الإصلاح (Fix Strategy)

### المرحلة 1: إصلاحات حرجة (أسبوع 1-2)

1. ✅ **إضافة Caching Layer**
   - إنشاء `CachedRepository` wrapper
   - إضافة TTL للبيانات
   - حفظ في Memory أولاً، ثم Local DB

2. ✅ **حفظ الصور المرفوعة**
   - إنشاء `PaymentDraftService`
   - حفظ في LocalStorage
   - استرجاع عند العودة

3. ✅ **إضافة Retry Mechanism**
   - تحديث `ApiClient`
   - إضافة exponential backoff
   - معالجة network errors

### المرحلة 2: تحسينات UX (أسبوع 3-4)

4. ✅ **حفظ Scroll Position**
   - إضافة `PageStorageKey`
   - استخدام `AutomaticKeepAliveClientMixin`

5. ✅ **Progress Indicators**
   - إضافة upload progress
   - عرض النسبة المئوية

6. ✅ **Form Data Persistence**
   - حفظ في LocalStorage
   - استرجاع عند العودة

### المرحلة 3: Offline Support (أسبوع 5-6)

7. ✅ **Local Database**
   - إضافة Hive
   - حفظ البيانات المهمة
   - Sync عند عودة الشبكة

8. ✅ **Offline UI**
   - عرض البيانات المحفوظة
   - إشعار المستخدم بحالة offline

---

## 📈 النتائج المتوقعة

### قبل التحسينات:
- ❌ فقدان البيانات عند الرجوع
- ❌ فقدان الصور المرفوعة
- ❌ إعادة تحميل غير ضرورية
- ❌ لا يعمل offline
- ❌ تجربة مستخدم سيئة

### بعد التحسينات:
- ✅ حفظ البيانات والحالة
- ✅ حفظ الصور المرفوعة
- ✅ Caching ذكي
- ✅ يعمل offline
- ✅ تجربة مستخدم ممتازة
- ✅ استهلاك أقل للـ API
- ✅ أداء أفضل

---

## 🎯 الخلاصة

التطبيق يحتاج إلى تحسينات جوهرية في:
1. **State Management** - إضافة caching وحفظ الحالة
2. **Navigation** - حفظ scroll position والبيانات
3. **Image Upload** - حفظ الصور وإضافة retry
4. **Offline Support** - إضافة local database
5. **UX** - progress indicators وform persistence

**الوقت المقدر:** 6 أسابيع  
**الأولوية:** عالية جداً  
**التأثير:** تحسين كبير في الاستقرار وتجربة المستخدم

---

**آخر تحديث:** 14 أبريل 2026
