import 'package:flutter/material.dart';

void main() {
  runApp(const InfinixSafeApp());
}

class InfinixSafeApp extends StatelessWidget {
  const InfinixSafeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat P2P',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat P2P Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.chat_bubble,
                color: Colors.white,
                size: 40,
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              'Chat P2P Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            
            const SizedBox(height: 10),
            
            const Text(
              'تطبيق دردشة آمن',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatListPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text('المحادثات'),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'نسخة آمنة لـ Infinix Hot 50I',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () => _showAboutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              child: const Text('معلومات التطبيق'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat P2P Demo'),
        content: const Text(
          'تطبيق دردشة لامركزي آمن\n\n'
          'النسخة: 1.0.0\n'
          'محسن لـ: Infinix Hot 50I\n'
          'نظام التشغيل: Android 14\n\n'
          'الميزات المخططة:\n'
          '• تشفير من طرف إلى طرف\n'
          '• اتصالات P2P مباشرة\n'
          '• نقل ملفات آمن\n'
          '• رسائل صوتية\n'
          '• اكتشاف الأقران\n\n'
          'هذه نسخة تجريبية للاختبار.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'أحمد محمد', 'message': 'مرحباً! كيف حالك؟', 'time': '10:30'},
      {'name': 'فاطمة علي', 'message': 'شكراً على الملف', 'time': '09:15'},
      {'name': 'محمد حسن', 'message': 'أراك غداً', 'time': 'أمس'},
      {'name': 'سارة أحمد', 'message': 'الاجتماع كان رائعاً', 'time': 'أمس'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                child: Text(chat['name']![0]),
              ),
              title: Text(
                chat['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(chat['message']!),
              trailing: Text(
                chat['time']!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              onTap: () => _showChatDialog(context, chat['name']!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => _showNewChatDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showChatDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('محادثة مع $name'),
        content: const Text(
          'هذه نسخة تجريبية من تطبيق Chat P2P.\n\n'
          'في النسخة الكاملة ستتمكن من:\n'
          '• إرسال رسائل مشفرة\n'
          '• مشاركة الملفات\n'
          '• إجراء مكالمات صوتية\n'
          '• الدردشة بدون إنترنت\n\n'
          'محسن خصيصاً لهاتف Infinix Hot 50I',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showNewChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('محادثة جديدة'),
        content: const Text(
          'في النسخة الكاملة ستتمكن من:\n\n'
          '• البحث عن أصدقاء قريبين\n'
          '• مسح رمز QR للاتصال\n'
          '• إضافة جهات اتصال\n'
          '• إنشاء مجموعات\n\n'
          'قريباً جداً!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
