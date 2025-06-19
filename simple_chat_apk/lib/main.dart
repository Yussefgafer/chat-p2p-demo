import 'package:flutter/material.dart';

void main() {
  runApp(const ChatP2PApp());
}

class ChatP2PApp extends StatelessWidget {
  const ChatP2PApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat P2P - تجريبي',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ChatHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final List<ChatItem> _demoChats = [
    ChatItem(
      name: 'أحمد محمد',
      lastMessage: 'مرحبا، كيف حالك؟',
      time: '10:30 ص',
      unreadCount: 2,
      isOnline: true,
    ),
    ChatItem(
      name: 'فاطمة علي',
      lastMessage: 'شكراً لك على المساعدة',
      time: '9:15 ص',
      unreadCount: 0,
      isOnline: false,
    ),
    ChatItem(
      name: 'محمد حسن',
      lastMessage: 'سأرسل لك الملفات قريباً',
      time: 'أمس',
      unreadCount: 1,
      isOnline: true,
    ),
    ChatItem(
      name: 'سارة أحمد',
      lastMessage: 'تم إرسال الصور',
      time: 'أمس',
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat P2P - تجريبي'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'Chat P2P Demo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'تطبيق دردشة لامركزي آمن',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: _demoChats.length,
              itemBuilder: (context, index) {
                final chat = _demoChats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: chat.isOnline ? Colors.green : Colors.grey,
                    child: Text(
                      chat.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    chat.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chat.lastMessage),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chat.time,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () => _openChat(context, chat),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatDialog(context),
        tooltip: 'محادثة جديدة',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openChat(BuildContext context, ChatItem chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('محادثة مع ${chat.name}'),
        content: const Text(
          'هذه نسخة تجريبية من التطبيق.\nفي النسخة الكاملة، ستفتح نافذة المحادثة هنا.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
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
          'في النسخة الكاملة، ستتمكن من:\n• مسح QR Code للاتصال\n• إدخال معرف المستخدم\n• البحث عن الأصدقاء القريبين',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat P2P Demo'),
        content: const Text(
          'تطبيق دردشة لامركزي مع تشفير كامل من طرف إلى طرف.\n\nالميزات:\n• دردشة آمنة ومشفرة\n• لا حاجة لخوادم مركزية\n• اتصال مباشر بين الأجهزة\n• حماية الخصوصية\n\nهذه نسخة تجريبية للعرض فقط.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}

class ChatItem {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}
