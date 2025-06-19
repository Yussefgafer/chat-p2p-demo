# 📱 تعليمات بناء APK لتطبيق Chat P2P

## 🚀 الطرق المتاحة لبناء APK

### 1. **GitHub Actions (الطريقة الموصى بها)**

#### المتطلبات:
- حساب GitHub
- رفع الكود إلى repository

#### الخطوات:
1. **رفع الكود إلى GitHub:**
   ```bash
   git add .
   git commit -m "Add Chat P2P demo app"
   git push origin main
   ```

2. **تشغيل GitHub Actions:**
   - اذهب إلى تبويب "Actions" في GitHub
   - اختر "Build Chat P2P Demo APK"
   - اضغط "Run workflow"
   - انتظر اكتمال البناء (5-10 دقائق)

3. **تحميل APK:**
   - بعد اكتمال البناء، ستجد ملفات APK في:
     - **Artifacts**: للتحميل المباشر
     - **Releases**: إصدار تلقائي مع رقم النسخة

#### المخرجات:
- `chat-p2p-demo-debug.apk` - للتطوير والاختبار
- `chat-p2p-demo-release.apk` - للاستخدام العادي

---

### 2. **البناء المحلي (إذا كان NDK يعمل)**

#### المتطلبات:
- Flutter SDK
- Android Studio
- Android SDK
- NDK مثبت بشكل صحيح

#### الخطوات:
```bash
# الانتقال إلى مجلد المشروع
cd simple_chat_apk

# تحديث التبعيات
flutter pub get

# بناء APK للتطوير
flutter build apk --debug

# بناء APK للإنتاج
flutter build apk --release
```

#### مكان الملفات:
```
simple_chat_apk/build/app/outputs/flutter-apk/
├── app-debug.apk
└── app-release.apk
```

---

### 3. **حل مشاكل NDK الشائعة**

#### المشكلة: `NDK did not have a source.properties file`

**الحل 1: إنشاء الملف المفقود**
```bash
# إنشاء ملف source.properties
echo "Pkg.Desc = Android NDK" > "C:\Users\[USERNAME]\AppData\Local\Android\sdk\ndk\[VERSION]\source.properties"
echo "Pkg.Revision = [VERSION]" >> "C:\Users\[USERNAME]\AppData\Local\Android\sdk\ndk\[VERSION]\source.properties"
```

**الحل 2: تعطيل NDK في المشروع**
```kotlin
// في android/app/build.gradle.kts
android {
    // تعطيل NDK
    ndkVersion = null
    
    defaultConfig {
        ndk {
            abiFilters.clear()
        }
    }
}
```

**الحل 3: استخدام إصدار أقدم من NDK**
```bash
# في Android Studio
# Tools > SDK Manager > SDK Tools
# ألغ تحديد NDK الحالي وثبت إصدار أقدم
```

---

## 🔧 إعدادات التطبيق

### معلومات التطبيق:
- **اسم التطبيق**: Chat P2P - تطبيق دردشة لامركزي
- **Package Name**: `com.example.simple_chat_apk`
- **الإصدار**: 1.0.0
- **الحد الأدنى لـ Android**: API 21 (Android 5.0)
- **الهدف**: API 34 (Android 14)

### الميزات:
- 🔒 تشفير تجريبي (XOR للعرض)
- 🌐 واجهة عربية كاملة
- 🎨 تصميم Material 3 مع الوضع المظلم
- 📱 دعم الهواتف والأجهزة اللوحية
- 🚀 أداء محسن وحجم صغير

---

## 📋 قائمة التحقق قبل البناء

- [ ] Flutter SDK مثبت ومحدث
- [ ] Android SDK مثبت
- [ ] Java 17 مثبت
- [ ] متغيرات البيئة مضبوطة
- [ ] `flutter doctor` يظهر نتائج إيجابية
- [ ] التبعيات محدثة (`flutter pub get`)

---

## 🐛 استكشاف الأخطاء

### خطأ: `Gradle task failed`
```bash
# تنظيف المشروع
flutter clean
flutter pub get

# إعادة المحاولة
flutter build apk --debug
```

### خطأ: `Android license not accepted`
```bash
# قبول تراخيص Android
flutter doctor --android-licenses
```

### خطأ: `Java version incompatible`
```bash
# التحقق من إصدار Java
java -version

# يجب أن يكون Java 17 أو أحدث
```

---

## 🎯 النتيجة النهائية

بعد اكتمال البناء بنجاح، ستحصل على:

1. **APK Debug** (~50 MB):
   - للتطوير والاختبار
   - يحتوي على معلومات التشخيص
   - أسرع في البناء

2. **APK Release** (~25 MB):
   - محسن للأداء
   - حجم أصغر
   - للاستخدام النهائي

3. **PWA Web** (اختياري):
   - يعمل في المتصفح
   - قابل للتثبيت كتطبيق ويب
   - متوافق مع جميع الأجهزة

---

## 📞 الدعم

إذا واجهت مشاكل:
1. تحقق من `flutter doctor`
2. راجع سجلات GitHub Actions
3. استخدم الطريقة البديلة (Web PWA)
4. تواصل مع فريق التطوير

---

**ملاحظة**: هذا مشروع تجريبي للعرض. في النسخة الكاملة ستتوفر ميزات تشفير حقيقية وإمكانيات P2P متقدمة.
