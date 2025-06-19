import 'package:flutter/material.dart';

void main() {
  runApp(const ChatP2PApp());
}

class ChatP2PApp extends StatelessWidget {
  const ChatP2PApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat P2P Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const ChatHomePage(),
    );
  }
}

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final List<ChatItem> _chats = [
    ChatItem(
      name: 'أحمد محمد',
      lastMessage: 'مرحباً! كيف حالك؟ 👋',
      time: '5 دقائق',
      unreadCount: 2,
      isOnline: true,
    ),
    ChatItem(
      name: 'فاطمة علي',
      lastMessage: 'شكراً لك على الملف 📁',
      time: 'ساعة واحدة',
      unreadCount: 0,
      isOnline: false,
    ),
    ChatItem(
      name: 'محمد حسن',
      lastMessage: 'أراك غداً 👋',
      time: 'أمس',
      unreadCount: 0,
      isOnline: true,
    ),
    ChatItem(
      name: 'سارة أحمد',
      lastMessage: 'الاجتماع كان رائعاً! 🎉',
      time: 'يومين',
      unreadCount: 1,
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
            onPressed: () => _showInfoDialog(),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Chat P2P Demo',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تطبيق دردشة لامركزي آمن',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            chat.name[0],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (chat.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      chat.name,
                      style: TextStyle(
                        fontWeight: chat.unreadCount > 0 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          chat.time,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (chat.unreadCount > 0) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6, 
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () => _openChat(chat.name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatDialog(),
        tooltip: 'محادثة جديدة',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openChat(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('محادثة مع $name'),
        content: const Text('هذه نسخة تجريبية من التطبيق.\n\nالمحادثات الفعلية ستكون متاحة في النسخة الكاملة.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('محادثة جديدة'),
        content: const Text('في النسخة الكاملة، ستتمكن من:\n\n• مسح QR Code للاتصال\n• البحث عن الأقران في الشبكة\n• إضافة جهات اتصال جديدة'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Chat P2P Demo',
      applicationVersion: '1.0.0-demo',
      applicationIcon: const Icon(Icons.chat, size: 48),
      children: [
        const Text('تطبيق دردشة لامركزي مع تشفير كامل من طرف إلى طرف.'),
        const SizedBox(height: 16),
        const Text('الميزات المخططة:'),
        const Text('🔐 تشفير E2E'),
        const Text('🌐 اتصالات P2P مباشرة'),
        const Text('📱 اكتشاف الأقران'),
        const Text('📁 نقل الملفات الآمن'),
        const Text('🔄 رسائل غير متصلة'),
      ],
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
