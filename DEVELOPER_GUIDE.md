# Chat P2P - دليل المطور الشامل

## 📋 جدول المحتويات

1. [نظرة عامة على المشروع](#نظرة-عامة-على-المشروع)
2. [البنية المعمارية](#البنية-المعمارية)
3. [إعداد بيئة التطوير](#إعداد-بيئة-التطوير)
4. [دليل التطوير](#دليل-التطوير)
5. [الاختبار](#الاختبار)
6. [النشر](#النشر)
7. [المساهمة](#المساهمة)

## 🎯 نظرة عامة على المشروع

Chat P2P هو تطبيق دردشة لامركزي مطور بـ Flutter يستخدم:
- **Clean Architecture** للبنية المعمارية
- **WebRTC** للاتصالات P2P
- **End-to-End Encryption** للأمان
- **Material Design 3** للواجهة

### الميزات الرئيسية
- ✅ اتصالات P2P مباشرة
- ✅ تشفير كامل E2E
- ✅ اكتشاف الأقران (QR, LAN, Bluetooth)
- ✅ نقل الملفات الآمن
- ✅ العمل في الخلفية
- ✅ Offline Message Relay

## 🏗️ البنية المعمارية

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│  (Pages, Widgets, State Management) │
├─────────────────────────────────────┤
│            Domain Layer             │
│   (Entities, Use Cases, Repos)     │
├─────────────────────────────────────┤
│             Data Layer              │
│  (Data Sources, Models, Repos Impl)│
├─────────────────────────────────────┤
│             Core Layer              │
│   (Utils, Constants, Services)     │
└─────────────────────────────────────┘
```

### هيكل المجلدات

```
lib/
├── core/                    # الطبقة الأساسية
│   ├── animations/          # الرسوم المتحركة
│   ├── constants/           # الثوابت
│   ├── di/                  # حقن التبعيات
│   ├── errors/              # إدارة الأخطاء
│   ├── performance/         # تحسين الأداء
│   ├── services/            # الخدمات الأساسية
│   ├── theme/               # المظاهر
│   └── utils/               # الأدوات المساعدة
├── features/                # الميزات
│   ├── auth/                # المصادقة
│   ├── chat/                # الدردشة
│   ├── file_transfer/       # نقل الملفات
│   ├── peer_discovery/      # اكتشاف الأقران
│   ├── settings/            # الإعدادات
│   └── webrtc/              # WebRTC
├── shared/                  # المكونات المشتركة
│   ├── models/              # النماذج
│   ├── theme/               # المظاهر المشتركة
│   └── widgets/             # الواجهات المشتركة
└── main.dart                # نقطة البداية
```

## ⚙️ إعداد بيئة التطوير

### المتطلبات الأساسية

```bash
# Flutter SDK
flutter --version  # >= 3.0.0

# Dart SDK  
dart --version     # >= 3.0.0

# Android Studio / VS Code
# Android SDK (للأندرويد)
# Xcode (لـ iOS)
```

### خطوات الإعداد

1. **استنساخ المشروع**
```bash
git clone https://github.com/your-repo/chat_p2p.git
cd chat_p2p
```

2. **تحميل التبعيات**
```bash
flutter pub get
```

3. **إعداد المنصات**
```bash
# للأندرويد
flutter config --android-sdk /path/to/android/sdk

# لـ iOS (macOS only)
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

4. **تشغيل التطبيق**
```bash
# تشغيل في وضع التطوير
flutter run

# تشغيل مع Hot Reload
flutter run --hot
```

## 🛠️ دليل التطوير

### إضافة ميزة جديدة

1. **إنشاء Feature Module**
```bash
mkdir -p lib/features/new_feature/{domain,data,presentation}
mkdir -p lib/features/new_feature/domain/{entities,repositories,usecases}
mkdir -p lib/features/new_feature/data/{datasources,models,repositories}
mkdir -p lib/features/new_feature/presentation/{pages,widgets,bloc}
```

2. **إنشاء Entity**
```dart
// lib/features/new_feature/domain/entities/new_entity.dart
import 'package:equatable/equatable.dart';

class NewEntity extends Equatable {
  final String id;
  final String name;
  
  const NewEntity({
    required this.id,
    required this.name,
  });
  
  @override
  List<Object> get props => [id, name];
}
```

3. **إنشاء Repository Interface**
```dart
// lib/features/new_feature/domain/repositories/new_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/new_entity.dart';

abstract class NewRepository {
  Future<Either<Failure, List<NewEntity>>> getItems();
  Future<Either<Failure, NewEntity>> createItem(NewEntity item);
}
```

4. **إنشاء Use Case**
```dart
// lib/features/new_feature/domain/usecases/get_items_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/new_entity.dart';
import '../repositories/new_repository.dart';

class GetItemsUseCase {
  final NewRepository repository;
  
  GetItemsUseCase(this.repository);
  
  Future<Either<Failure, List<NewEntity>>> call() async {
    return await repository.getItems();
  }
}
```

### إدارة الحالة

استخدم Provider لإدارة الحالة:

```dart
// lib/features/new_feature/presentation/providers/new_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/new_entity.dart';
import '../../domain/usecases/get_items_usecase.dart';

class NewProvider extends ChangeNotifier {
  final GetItemsUseCase getItemsUseCase;
  
  List<NewEntity> _items = [];
  bool _isLoading = false;
  String? _error;
  
  List<NewEntity> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  NewProvider({required this.getItemsUseCase});
  
  Future<void> loadItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await getItemsUseCase();
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (items) {
        _items = items;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
```

### إضافة الرسوم المتحركة

استخدم AppAnimations للرسوم المتحركة:

```dart
import '../../../../core/animations/app_animations.dart';

class AnimatedWidget extends StatefulWidget {
  @override
  _AnimatedWidgetState createState() => _AnimatedWidgetState();
}

class _AnimatedWidgetState extends State<AnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.mediumAnimation,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.defaultCurve,
    );
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return AppAnimations.fadeScaleTransition(
      child: YourWidget(),
      animation: _animation,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### إدارة الأخطاء

```dart
// استخدام Either للتعامل مع الأخطاء
final result = await someUseCase();
result.fold(
  (failure) {
    // التعامل مع الخطأ
    if (failure is NetworkFailure) {
      showSnackBar('Network error occurred');
    } else if (failure is CacheFailure) {
      showSnackBar('Cache error occurred');
    }
  },
  (data) {
    // التعامل مع النجاح
    updateUI(data);
  },
);
```

## 🧪 الاختبار

### أنواع الاختبارات

1. **Unit Tests** - اختبار الوحدات
2. **Widget Tests** - اختبار الواجهات
3. **Integration Tests** - اختبار التكامل

### تشغيل الاختبارات

```bash
# جميع الاختبارات
flutter test

# اختبارات الوحدة فقط
flutter test test/unit/

# اختبارات الواجهة فقط
flutter test test/widget/

# اختبارات التكامل
flutter test integration_test/

# مع تقرير التغطية
flutter test --coverage
```

### كتابة اختبار وحدة

```dart
// test/unit/features/new_feature/domain/usecases/get_items_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

void main() {
  group('GetItemsUseCase', () {
    late GetItemsUseCase useCase;
    late MockNewRepository mockRepository;
    
    setUp(() {
      mockRepository = MockNewRepository();
      useCase = GetItemsUseCase(mockRepository);
    });
    
    test('should return list of items when repository call is successful', () async {
      // Arrange
      final items = [NewEntity(id: '1', name: 'Test')];
      when(mockRepository.getItems()).thenAnswer((_) async => Right(items));
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result, Right(items));
      verify(mockRepository.getItems());
    });
  });
}
```

### كتابة اختبار واجهة

```dart
// test/widget/features/new_feature/presentation/pages/new_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewPage Widget Tests', () {
    testWidgets('should display loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NewPage(),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

## 🚀 النشر

### بناء للإنتاج

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### إعداد التوقيع (Android)

1. **إنشاء Keystore**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **إعداد key.properties**
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<location of the key store file>
```

### متغيرات البيئة

```bash
# Development
export ENVIRONMENT=development
export API_BASE_URL=https://dev-api.chatp2p.com

# Production
export ENVIRONMENT=production
export API_BASE_URL=https://api.chatp2p.com
```

## 🤝 المساهمة

### قواعد المساهمة

1. **Fork** المشروع
2. إنشاء **feature branch**
3. **Commit** التغييرات
4. **Push** للفرع
5. إنشاء **Pull Request**

### معايير الكود

- اتبع **Dart Style Guide**
- استخدم **meaningful names**
- اكتب **documentation**
- أضف **tests** للكود الجديد

### Git Workflow

```bash
# إنشاء فرع جديد
git checkout -b feature/new-feature

# إضافة التغييرات
git add .
git commit -m "feat: add new feature"

# رفع للمستودع
git push origin feature/new-feature
```

### Commit Messages

استخدم **Conventional Commits**:

```
feat: add new feature
fix: resolve bug in encryption
docs: update README
style: format code
refactor: improve performance
test: add unit tests
chore: update dependencies
```

## 📚 موارد إضافية

### الوثائق
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [WebRTC Documentation](https://webrtc.org/)

### الأدوات المفيدة
- [Flutter Inspector](https://docs.flutter.dev/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Flutter Performance](https://docs.flutter.dev/perf)

### المجتمع
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [GitHub Discussions](https://github.com/flutter/flutter/discussions)

---

**Happy Coding! 🚀**
