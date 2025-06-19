# 🚀 تشغيل تطبيق Chat P2P

## 📱 طرق التشغيل

### 1. تشغيل على المتصفح (الأسرع)
```bash
flutter run -d chrome
```

### 2. تشغيل على الهاتف (عبر USB)
```bash
# تأكد من تفعيل USB Debugging
flutter run
```

### 3. تشغيل على محاكي Android
```bash
# تشغيل المحاكي أولاً، ثم:
flutter run
```

---

## 🔧 أوامر مفيدة

### تنظيف المشروع:
```bash
flutter clean
flutter pub get
```

### بناء للويب:
```bash
flutter build web
```

### بناء APK:
```bash
flutter build apk --debug
flutter build apk --release
```

### تشغيل الاختبارات:
```bash
flutter test
```

### تحليل الكود:
```bash
flutter analyze
```

---

## 📋 متطلبات التشغيل

- Flutter SDK 3.32.4+
- Dart SDK 3.5.0+
- Chrome (للويب)
- Android Studio (للهاتف/محاكي)

---

## 🎯 ميزات التطبيق

### الواجهة الرئيسية:
- 📱 قائمة المحادثات التجريبية
- 🎨 تصميم Material 3 مع الوضع المظلم
- 🌐 دعم اللغة العربية كاملاً
- ⚡ أداء سريع ومحسن

### الوظائف المتاحة:
- 💬 عرض المحادثات التجريبية
- ➕ إضافة محادثة جديدة (تجريبي)
- ℹ️ معلومات التطبيق
- 🔄 تحديث الحالة

### الوظائف المستقبلية:
- 🔒 تشفير حقيقي من طرف إلى طرف
- 🌐 اتصال P2P مباشر
- 📷 مشاركة الصور والملفات
- 🔍 البحث في المحادثات
- 🔔 الإشعارات الذكية

---

## 🐛 حل المشاكل الشائعة

### المشكلة: "No devices found"
```bash
# للويب:
flutter config --enable-web

# للهاتف:
# تأكد من تفعيل USB Debugging
# تأكد من تثبيت drivers الهاتف
```

### المشكلة: "Gradle build failed"
```bash
flutter clean
flutter pub get
flutter run
```

### المشكلة: "Hot reload not working"
```bash
# اضغط 'r' في terminal
# أو اضغط 'R' لـ hot restart
```

---

## 📊 معلومات الأداء

### حجم التطبيق:
- **Debug**: ~50 MB
- **Release**: ~25 MB
- **Web**: ~2 MB (مضغوط)

### سرعة التشغيل:
- **البدء البارد**: 2-3 ثواني
- **البدء الساخن**: <1 ثانية
- **Hot Reload**: <500ms

---

## 🎨 تخصيص التطبيق

### تغيير الألوان:
```dart
// في lib/main.dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue, // غير هذا اللون
  brightness: Brightness.dark,
),
```

### تغيير اسم التطبيق:
```dart
// في lib/main.dart
title: 'Chat P2P - تجريبي', // غير هذا النص
```

### إضافة محادثات جديدة:
```dart
// في lib/main.dart - _demoChats
ChatItem(
  name: 'اسم جديد',
  lastMessage: 'آخر رسالة',
  time: 'الوقت',
  unreadCount: 0,
  isOnline: true,
),
```

---

## 📞 الدعم والمساعدة

### الموارد المفيدة:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design](https://material.io/design)

### نصائح للتطوير:
1. استخدم Hot Reload للتطوير السريع
2. اختبر على أجهزة مختلفة
3. راقب الأداء باستمرار
4. اتبع أفضل ممارسات Flutter

---

**استمتع بالتطوير! 🚀**
