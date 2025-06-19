# 🚀 إعداد GitHub لبناء APK تلقائياً

## 📋 الخطوات السريعة

### 1. إنشاء Repository جديد
```bash
# إنشاء repository على GitHub
# اسم مقترح: chat-p2p-demo
```

### 2. رفع الكود
```bash
# في مجلد المشروع
git init
git add .
git commit -m "Initial commit: Chat P2P Demo App"
git branch -M main
git remote add origin https://github.com/[USERNAME]/chat-p2p-demo.git
git push -u origin main
```

### 3. تشغيل GitHub Actions
1. اذهب إلى: `https://github.com/[USERNAME]/chat-p2p-demo/actions`
2. اختر "Build Chat P2P Demo APK"
3. اضغط "Run workflow"
4. اختر branch: `main`
5. اضغط "Run workflow" الأخضر

### 4. تحميل APK
بعد 5-10 دقائق:
- **Artifacts**: تحميل مباشر للـ APK
- **Releases**: إصدار تلقائي مع رقم النسخة

---

## 🔧 إعدادات متقدمة

### تخصيص اسم التطبيق:
```yaml
# في .github/workflows/build-apk.yml
name: Build [YOUR_APP_NAME] APK
```

### تخصيص معلومات الإصدار:
```kotlin
// في simple_chat_apk/android/app/build.gradle.kts
defaultConfig {
    applicationId = "com.yourcompany.yourapp"
    versionCode = 1
    versionName = "1.0.0"
}
```

### إضافة أيقونة مخصصة:
```bash
# استبدل الأيقونات في:
simple_chat_apk/android/app/src/main/res/mipmap-*/ic_launcher.png
```

---

## 📱 نتائج البناء

### Debug APK:
- **الحجم**: ~50 MB
- **الاستخدام**: التطوير والاختبار
- **الميزات**: معلومات التشخيص مفعلة

### Release APK:
- **الحجم**: ~25 MB  
- **الاستخدام**: الإنتاج والتوزيع
- **الميزات**: محسن للأداء

---

## 🎯 الخطوات التالية

1. **اختبار التطبيق** على أجهزة مختلفة
2. **تخصيص التصميم** والألوان
3. **إضافة ميزات جديدة** حسب الحاجة
4. **نشر التطبيق** على متاجر التطبيقات

---

## 🔗 روابط مفيدة

- [Flutter Documentation](https://docs.flutter.dev/)
- [GitHub Actions for Flutter](https://docs.github.com/en/actions)
- [Android App Bundle](https://developer.android.com/guide/app-bundle)
- [Material Design 3](https://m3.material.io/)

---

**نصيحة**: احفظ رابط GitHub Actions في المفضلة لسهولة الوصول إليه لاحقاً!
