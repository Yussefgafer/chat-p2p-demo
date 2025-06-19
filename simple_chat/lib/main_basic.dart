import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat P2P Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              child: SvgPicture.asset(
                'assets/animations/chat_loading.svg',
                width: 120,
                height: 120,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Chat P2P Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('تطبيق دردشة لامركزي', style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListPage()),
                );
              },
              child: Text('بدء المحادثات'),
            ),
            SizedBox(height: 20),
            Text(
              'نسخة تجريبية - Infinix Hot 50I',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatListPage extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {'name': 'أحمد محمد', 'message': 'مرحباً'},
    {'name': 'فاطمة علي', 'message': 'كيف حالك؟'},
    {'name': 'محمد حسن', 'message': 'أراك لاحقاً'},
    {'name': 'سارة أحمد', 'message': 'شكراً لك'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المحادثات'), backgroundColor: Colors.blue),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(chats[index]['name']![0]),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            title: Text(chats[index]['name']!),
            subtitle: Text(chats[index]['message']!),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('محادثة مع ${chats[index]['name']}'),
                  content: Text(
                    'هذه نسخة تجريبية.\n\nالميزات الكاملة قريباً:\n• تشفير آمن\n• اتصال مباشر\n• نقل ملفات\n• رسائل صوتية',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('حسناً'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('محادثة جديدة'),
              content: Text('ميزة إضافة محادثات جديدة قريباً!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('حسناً'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
