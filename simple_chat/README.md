# 📱 Chat P2P Demo

[![Build APK](https://github.com/yourusername/simple_chat/actions/workflows/build-apk.yml/badge.svg)](https://github.com/yourusername/simple_chat/actions/workflows/build-apk.yml)

تطبيق دردشة لامركزي تجريبي مطور بـ Flutter مع تشفير كامل من طرف إلى طرف.

## 🎯 نظرة عامة

هذا التطبيق التجريبي يعرض واجهة المستخدم والميزات الأساسية لتطبيق Chat P2P. النسخة الكاملة ستتضمن اتصالات P2P حقيقية وتشفير E2E.

## ✨ الميزات المتاحة

- 🎨 **Material Design 3** - تصميم حديث ومتجاوب
- 🌙 **الوضع المظلم** - كافتراضي مع إمكانية التبديل
- 📱 **قائمة محادثات** - واجهة تجريبية للمحادثات
- 💬 **حوارات تفاعلية** - معلومات عن الميزات المخططة
- 🌐 **دعم العربية** - واجهة باللغة العربية
- 📊 **حالة الاتصال** - مؤشرات الحالة للمستخدمين

## 🚀 الميزات المخططة (النسخة الكاملة)

- 🔐 **تشفير E2E** - تشفير كامل من طرف إلى طرف
- 🌐 **اتصالات P2P** - اتصالات مباشرة بدون خوادم
- 📱 **اكتشاف الأقران** - QR Code, LAN, Bluetooth
- 📁 **نقل الملفات** - نقل آمن للملفات
- 🔄 **رسائل غير متصلة** - تخزين ونقل الرسائل
- 🔔 **الإشعارات** - إشعارات ذكية
- ⚙️ **إعدادات متقدمة** - تخصيص كامل

## 🛠️ التطوير

### المتطلبات
- Flutter 3.32.4+
- Dart 3.8.1+
- Android Studio (للبناء المحلي)

### التشغيل المحلي
```bash
# استنساخ المشروع
git clone https://github.com/yourusername/simple_chat.git
cd simple_chat

# تحميل التبعيات
flutter pub get

# تشغيل التطبيق
flutter run
```

### بناء APK
```bash
# APK تجريبي
flutter build apk --debug

# APK للإنتاج
flutter build apk --release
```

## 📦 تحميل APK

### GitHub Actions (الأسهل)
1. اذهب إلى [Actions](https://github.com/yourusername/simple_chat/actions)
2. اختر أحدث build ناجح
3. حمل APK من Artifacts

### البناء المحلي
```bash
# تأكد من إعداد Android toolchain
flutter doctor

# بناء APK
flutter build apk --release
```

## 🔧 استكشاف الأخطاء

### مشكلة Android Toolchain
```bash
# تثبيت Android licenses
flutter doctor --android-licenses

# التحقق من الحالة
flutter doctor -v
```

---

**مطور بـ ❤️ باستخدام Flutter**
