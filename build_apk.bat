@echo off
echo ========================================
echo بناء تطبيق وصلة أكاديمي
echo ========================================
echo.

REM التحقق من وجود مفتاح التوقيع
if not exist "android\app\wasla-key.jks" (
    echo توليد مفتاح التوقيع...
    keytool -genkey -v -keystore android\app\wasla-key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias wasla -storepass wasla123 -keypass wasla123 -dname "CN=Wasla Academy, OU=Development, O=Wasla, L=City, S=State, C=SA"
    echo تم توليد مفتاح التوقيع بنجاح!
    echo.
)

echo تنظيف المشروع...
call flutter clean
echo.

echo جلب المكتبات...
call flutter pub get
echo.

echo بناء APK...
call flutter build apk --release --split-per-abi
echo.

if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo تم بناء التطبيق بنجاح!
    echo ========================================
    echo.
    echo ملفات APK موجودة في:
    echo build\app\outputs\flutter-apk\
    echo.
    echo الملفات المتاحة:
    dir /B build\app\outputs\flutter-apk\*.apk
    echo.
    echo ========================================
) else (
    echo ========================================
    echo فشل بناء التطبيق!
    echo ========================================
)

pause
